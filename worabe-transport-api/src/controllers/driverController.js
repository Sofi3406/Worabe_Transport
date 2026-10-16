
const DriverProfile = require("../models/DriverProfile");

// GET /api/drivers
// List verified drivers for the driver directory.
async function listDrivers(req, res) {
  try {
    const filter = {
      verificationStatus: "approved",
      isVerified: true,
    };

    // Optional filter: /api/drivers?availability=online
    if (req.query.availability) {
      if (!["online", "offline"].includes(req.query.availability)) {
        return res.status(400).json({
          message: "Availability must be online or offline.",
        });
      }

      filter.availability = req.query.availability;
    }

    const drivers = await DriverProfile.find(filter)
      .populate("userId", "fullName phone")
      .sort({ createdAt: -1 })
      .lean();

    const results = drivers
      .filter((driver) => driver.userId)
      .map((driver) => ({
        // Ride requests use the driver's user id, not the profile id.
        id: driver.userId._id.toString(),
        profileId: driver._id.toString(),
        fullName: driver.userId.fullName,
        phone: driver.userId.phone,
        vehicleType: driver.vehicleType,
        vehiclePlate: driver.vehiclePlate,
        serviceAreas: driver.serviceAreas,
        destinations: driver.destinations,
        availability: driver.availability,
      }));

    return res.status(200).json({
      count: results.length,
      drivers: results,
    });
  } catch (error) {
    console.error("List drivers error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve drivers.",
    });
  }
}

// GET /api/drivers/me
// Get the logged-in driver's own profile.
async function getMyDriverProfile(req, res) {
  try {
    const driver = await DriverProfile.findOne({
      userId: req.user.id,
    })
      .populate("userId", "fullName phone preferredLanguage")
      .lean();

    if (!driver || !driver.userId) {
      return res.status(404).json({
        message: "Driver profile not found.",
      });
    }

    return res.status(200).json({
      driver: {
        id: driver._id,
        fullName: driver.userId.fullName,
        phone: driver.userId.phone,
        preferredLanguage: driver.userId.preferredLanguage,
        vehicleType: driver.vehicleType,
        vehiclePlate: driver.vehiclePlate,
        serviceAreas: driver.serviceAreas,
        destinations: driver.destinations,
        verificationStatus: driver.verificationStatus,
        isVerified: driver.isVerified,
        availability: driver.availability,
      },
    });
  } catch (error) {
    console.error("Get driver profile error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve your driver profile.",
    });
  }
}

// PATCH /api/drivers/me/availability
// Change the logged-in driver's availability.
async function updateAvailability(req, res) {
  try {
    const { availability } = req.body;

    if (!["online", "offline"].includes(availability)) {
      return res.status(400).json({
        message: "Availability must be online or offline.",
      });
    }

    const driver = await DriverProfile.findOne({
      userId: req.user.id,
    });

    if (!driver) {
      return res.status(404).json({
        message: "Driver profile not found.",
      });
    }

    // Unapproved drivers cannot become available for rides.
    if (
      availability === "online" &&
      (driver.verificationStatus !== "approved" ||
        driver.isVerified !== true)
    ) {
      return res.status(403).json({
        message: "Your driver account must be approved before going online.",
      });
    }

    driver.availability = availability;
    await driver.save();

    return res.status(200).json({
      message: `Availability updated to ${availability}.`,
      availability: driver.availability,
    });
  } catch (error) {
    console.error("Update availability error:", error.message);

    return res.status(500).json({
      message: "Unable to update availability.",
    });
  }
}

module.exports = {
  listDrivers,
  getMyDriverProfile,
  updateAvailability,
};
