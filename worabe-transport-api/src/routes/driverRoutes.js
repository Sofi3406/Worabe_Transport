
const express = require("express");

const {
  listDrivers,
  getMyDriverProfile,
  updateAvailability,
} = require("../controllers/driverController");

const {
  authenticate,
  authorize,
} = require("../middleware/auth");

const router = express.Router();

// All endpoints require a valid login.
router.use(authenticate);

// View the verified driver directory.
router.get(
  "/",
  authorize("passenger", "driver", "admin"),
  listDrivers
);

// View your own driver profile.
router.get(
  "/me",
  authorize("driver"),
  getMyDriverProfile
);

// Change your own availability.
router.patch(
  "/me/availability",
  authorize("driver"),
  updateAvailability
);

module.exports = router;
