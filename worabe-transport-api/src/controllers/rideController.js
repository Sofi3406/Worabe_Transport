
const mongoose = require("mongoose");

const User = require("../models/User");
const RideRequest = require("../models/RideRequest");
const DriverProfile = require("../models/DriverProfile");

// POST /api/rides
// A passenger requests a ride from a specific driver.
async function createRideRequest(req, res) {
  const passengerId = req.user.id;
  const { driverId, pickup, destination } = req.body;
  const requestKey = req.get("Idempotency-Key")?.trim();

  // Accept either a plain string or an object with a label field.
  const pickupLabel = typeof pickup === "object" && pickup !== null ? pickup.label : pickup;
  const destinationLabel = typeof destination === "object" && destination !== null ? destination.label : destination;

  if (
    !mongoose.Types.ObjectId.isValid(driverId || "") ||
    typeof pickupLabel !== "string" ||
    typeof destinationLabel !== "string" ||
    !pickupLabel.trim() ||
    !destinationLabel.trim()
  ) {
    return res.status(400).json({
      message: "A valid driver, pickup, and destination are required.",
    });
  }

  if (pickupLabel.trim().length > 200 || destinationLabel.trim().length > 200) {
    return res.status(400).json({
      message: "Pickup and destination must be 200 characters or fewer.",
    });
  }

  if (requestKey !== undefined && (!requestKey || requestKey.length > 100)) {
    return res.status(400).json({
      message: "The idempotency key must contain 1 to 100 characters.",
    });
  }

  let session;

  try {
    session = await mongoose.startSession();

    let createdRide;

    await session.withTransaction(async () => {
      // Return the original request when a client retries the same key.
      if (requestKey) {
        const existing = await RideRequest.findOne({
          passengerId,
          requestKey,
        }).session(session);

        if (existing) {
          createdRide = existing;
          return;
        }
      }

      const driverProfile = await DriverProfile.findOne({
        userId: driverId,
        verificationStatus: "approved",
        isVerified: true,
        availability: "online",
      }).session(session);

      if (!driverProfile) {
        const error = new Error("DRIVER_UNAVAILABLE");
        throw error;
      }

      const ride = new RideRequest({
        passengerId,
        driverId,
        pickup: { label: pickupLabel.trim() },
        destination: { label: destinationLabel.trim() },
        status: "pending",
        ...(requestKey ? { requestKey } : {}),
      });

      await ride.save({ session });

      // Reserve the passenger's active-ride slot.
      // The conditional update prevents competing requests from both winning.
      const passenger = await User.findOneAndUpdate(
        {
          _id: passengerId,
          role: "passenger",
          isActive: true,
          activeRideRequestId: null,
          activeRideRole: null,
        },
        {
          $set: {
            activeRideRequestId: ride._id,
            activeRideRole: "passenger",
          },
        },
        { new: true, session }
      );

      if (!passenger) {
        const error = new Error("PASSENGER_ACTIVE_RIDE");
        throw error;
      }

      createdRide = ride;
    });

    return res.status(201).json({
      message: "Ride request created successfully.",
      ride: createdRide,
    });
  } catch (error) {
    // A concurrent retry may have created this request first.
    if (error.code === 11000 && requestKey) {
      const existing = await RideRequest.findOne({
        passengerId,
        requestKey,
      });

      if (existing) {
        return res.status(200).json({
          message: "This ride request has already been submitted.",
          ride: existing,
        });
      }
    }

    if (error.message === "DRIVER_UNAVAILABLE") {
      return res.status(400).json({
        message: "This driver is not currently available for requests.",
      });
    }

    if (error.message === "PASSENGER_ACTIVE_RIDE") {
      return res.status(409).json({
        message: "You already have an active ride request.",
      });
    }

    console.error("Create ride error:", error.message);

    return res.status(500).json({
      message: "Unable to create the ride request.",
    });
  } finally {
    if (session) await session.endSession();
  }
}

// GET /api/rides
// Each passenger or driver sees only their own ride records.
async function listMyRides(req, res) {
  try {
    const filter =
      req.user.role === "passenger"
        ? { passengerId: req.user.id }
        : { driverId: req.user.id };

    const rides = await RideRequest.find(filter)
      .populate("passengerId", "fullName phone")
      .populate("driverId", "fullName phone")
      .sort({ createdAt: -1 })
      .lean();

    return res.status(200).json({
      count: rides.length,
      rides,
    });
  } catch (error) {
    console.error("List rides error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve ride history.",
    });
  }
}

// PATCH /api/rides/:rideId/response
// The assigned driver accepts or rejects a pending request.
async function respondToRide(req, res) {
  const { rideId } = req.params;
  const { action } = req.body;
  const decision = action === "accept" ? "accepted" : action === "reject" ? "rejected" : action;

  if (!mongoose.Types.ObjectId.isValid(rideId)) {
    return res.status(400).json({
      message: "Invalid ride ID.",
    });
  }

  if (!["accepted", "rejected"].includes(decision)) {
    return res.status(400).json({
      message: "Action must be accept or reject.",
    });
  }

  let session;

  try {
    session = await mongoose.startSession();

    let updatedRide;

    await session.withTransaction(async () => {
      const ride = await RideRequest.findOne({
        _id: rideId,
        driverId: req.user.id,
        status: "pending",
      }).session(session);

      if (!ride) {
        const error = new Error("RIDE_NOT_PENDING");
        throw error;
      }

      if (decision === "accepted") {
        const profile = await DriverProfile.findOne({
          userId: req.user.id,
          verificationStatus: "approved",
          isVerified: true,
          availability: "online",
        }).session(session);

        if (!profile) {
          const error = new Error("DRIVER_NOT_APPROVED_ONLINE");
          throw error;
        }

        // Reserve this driver's active-ride slot.
        const driver = await User.findOneAndUpdate(
          {
            _id: req.user.id,
            role: "driver",
            isActive: true,
            activeRideRequestId: null,
            activeRideRole: null,
          },
          {
            $set: {
              activeRideRequestId: ride._id,
              activeRideRole: "driver",
            },
          },
          { new: true, session }
        );

        if (!driver) {
          const error = new Error("DRIVER_HAS_ACTIVE_RIDE");
          throw error;
        }
      }

      // The status transition and active-slot change share a transaction.
      ride.status = decision;
      await ride.save({ session });

      // Rejection ends the pending ride, so release the passenger's slot.
      if (decision === "rejected") {
        await User.updateOne(
          {
            _id: ride.passengerId,
            activeRideRequestId: ride._id,
            activeRideRole: "passenger",
          },
          {
            $set: {
              activeRideRequestId: null,
              activeRideRole: null,
            },
          },
          { session }
        );
      }

      updatedRide = ride;
    });

    return res.status(200).json({
      message: `Ride ${decision} successfully.`,
      ride: updatedRide,
    });
  } catch (error) {
    if (error.message === "RIDE_NOT_PENDING") {
      return res.status(409).json({
        message:
          "Ride not found, not assigned to you, or no longer pending.",
      });
    }

    if (error.message === "DRIVER_NOT_APPROVED_ONLINE") {
      return res.status(403).json({
        message: "Only approved, online drivers can accept rides.",
      });
    }

    if (error.message === "DRIVER_HAS_ACTIVE_RIDE") {
      return res.status(409).json({
        message: "You already have an active ride.",
      });
    }

    console.error("Respond to ride error:", error.message);

    return res.status(500).json({
      message: "Unable to respond to the ride request.",
    });
  } finally {
    if (session) await session.endSession();
  }
}

// PATCH /api/rides/:rideId/cancel
// The passenger cancels their own pending or accepted ride.
async function cancelRide(req, res) {
  const { rideId } = req.params;

  if (!mongoose.Types.ObjectId.isValid(rideId)) {
    return res.status(400).json({
      message: "Invalid ride ID.",
    });
  }

  let session;

  try {
    session = await mongoose.startSession();

    let cancelledRide;

    await session.withTransaction(async () => {
      const ride = await RideRequest.findOne({
        _id: rideId,
        passengerId: req.user.id,
        status: { $in: ["pending", "accepted"] },
      }).session(session);

      if (!ride) {
        const error = new Error("RIDE_NOT_CANCELLABLE");
        throw error;
      }

      const previousStatus = ride.status;

      ride.status = "cancelled";
      await ride.save({ session });

      // Release the passenger's active-ride slot.
      await User.updateOne(
        {
          _id: ride.passengerId,
          activeRideRequestId: ride._id,
          activeRideRole: "passenger",
        },
        {
          $set: {
            activeRideRequestId: null,
            activeRideRole: null,
          },
        },
        { session }
      );

      // If accepted, also release the driver's slot.
      if (previousStatus === "accepted") {
        await User.updateOne(
          {
            _id: ride.driverId,
            activeRideRequestId: ride._id,
            activeRideRole: "driver",
          },
          {
            $set: {
              activeRideRequestId: null,
              activeRideRole: null,
            },
          },
          { session }
        );
      }

      cancelledRide = ride;
    });

    return res.status(200).json({
      message: "Ride cancelled successfully.",
      ride: cancelledRide,
    });
  } catch (error) {
    if (error.message === "RIDE_NOT_CANCELLABLE") {
      return res.status(409).json({
        message:
          "Ride not found, not owned by you, or cannot be cancelled.",
      });
    }

    console.error("Cancel ride error:", error.message);

    return res.status(500).json({
      message: "Unable to cancel the ride.",
    });
  } finally {
    if (session) await session.endSession();
  }
}

// PATCH /api/rides/:rideId/complete
// The assigned driver completes an accepted ride.
async function completeRide(req, res) {
  const { rideId } = req.params;

  if (!mongoose.Types.ObjectId.isValid(rideId)) {
    return res.status(400).json({
      message: "Invalid ride ID.",
    });
  }

  let session;

  try {
    session = await mongoose.startSession();

    let completedRide;

    await session.withTransaction(async () => {
      const ride = await RideRequest.findOne({
        _id: rideId,
        driverId: req.user.id,
        status: "accepted",
      }).session(session);

      if (!ride) {
        const error = new Error("RIDE_NOT_COMPLETABLE");
        throw error;
      }

      ride.status = "completed";
      await ride.save({ session });

      // Release passenger's active-ride slot.
      await User.updateOne(
        {
          _id: ride.passengerId,
          activeRideRequestId: ride._id,
          activeRideRole: "passenger",
        },
        {
          $set: {
            activeRideRequestId: null,
            activeRideRole: null,
          },
        },
        { session }
      );

      // Release driver's active-ride slot.
      await User.updateOne(
        {
          _id: ride.driverId,
          activeRideRequestId: ride._id,
          activeRideRole: "driver",
        },
        {
          $set: {
            activeRideRequestId: null,
            activeRideRole: null,
          },
        },
        { session }
      );

      completedRide = ride;
    });

    return res.status(200).json({
      message: "Ride completed successfully.",
      ride: completedRide,
    });
  } catch (error) {
    if (error.message === "RIDE_NOT_COMPLETABLE") {
      return res.status(409).json({
        message:
          "Ride not found, not assigned to you, or not accepted.",
      });
    }

    console.error("Complete ride error:", error.message);

    return res.status(500).json({
      message: "Unable to complete the ride.",
    });
  } finally {
    if (session) await session.endSession();
  }
}

module.exports = {
  createRideRequest,
  listMyRides,
  respondToRide,
  cancelRide,
  completeRide,
};
