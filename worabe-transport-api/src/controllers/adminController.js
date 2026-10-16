
const mongoose = require("mongoose");
const DriverProfile = require("../models/DriverProfile");

// GET /api/admin/drivers/pending
// View driver applications awaiting review.
async function listPendingDrivers(req, res) {
  try {
    const drivers = await DriverProfile.find({
      verificationStatus: "pending",
    })
      .populate("userId", "fullName phone")
      .sort({ createdAt: 1 })
      .lean();

    const results = drivers
      .filter((driver) => driver.userId)
      .map((driver) => ({
        id: driver._id,
        fullName: driver.userId.fullName,
        phone: driver.userId.phone,
        vehicleType: driver.vehicleType,
        vehiclePlate: driver.vehiclePlate,
        serviceAreas: driver.serviceAreas,
        destinations: driver.destinations,
        verificationStatus: driver.verificationStatus,
        createdAt: driver.createdAt,
      }));

    return res.status(200).json({
      count: results.length,
      drivers: results,
    });
  } catch (error) {
    console.error("List pending drivers error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve pending driver applications.",
    });
  }
}

// PATCH /api/admin/drivers/:driverId/verification
// Approve or reject a driver's application.
async function reviewDriver(req, res) {
  try {
    const { driverId } = req.params;
    const { status: verificationStatus } = req.body;

    if (!mongoose.Types.ObjectId.isValid(driverId)) {
      return res.status(400).json({
        message: "Invalid driver ID.",
      });
    }

    if (!["approved", "rejected"].includes(verificationStatus)) {
      return res.status(400).json({
        message: "Status must be approved or rejected.",
      });
    }

    const driver = await DriverProfile.findById(driverId);

    if (!driver) {
      return res.status(404).json({
        message: "Driver profile not found.",
      });
    }

    driver.verificationStatus = verificationStatus;
    driver.isVerified = verificationStatus === "approved";

    // Drivers must explicitly choose to go online after approval.
    // Rejected drivers must always remain offline.
    driver.availability = "offline";

    await driver.save();

    return res.status(200).json({
      message:
        verificationStatus === "approved"
          ? "Driver approved successfully."
          : "Driver application rejected.",
      driver: {
        id: driver._id,
        verificationStatus: driver.verificationStatus,
        isVerified: driver.isVerified,
        availability: driver.availability,
      },
    });
  } catch (error) {
    console.error("Review driver error:", error.message);

    return res.status(500).json({
      message: "Unable to review this driver application.",
    });
  }
}

module.exports = {
  listPendingDrivers,
  reviewDriver,
};
