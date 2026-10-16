
const express = require("express");

const {
  createRideRequest,
  listMyRides,
  respondToRide,
  cancelRide,
  completeRide,
} = require("../controllers/rideController");

const {
  authenticate,
  authorize,
} = require("../middleware/auth");

const router = express.Router();

// All ride endpoints require authentication.
router.use(authenticate);

// Passenger creates a request to a specific driver.
router.post(
  "/",
  authorize("passenger"),
  createRideRequest
);

// Passengers and drivers view their own ride records.
router.get(
  "/",
  authorize("passenger", "driver"),
  listMyRides
);

// Assigned driver accepts or rejects.
router.patch(
  "/:rideId/response",
  authorize("driver"),
  respondToRide
);

// Passenger cancels their own ride.
router.patch(
  "/:rideId/cancel",
  authorize("passenger"),
  cancelRide
);

// Assigned driver completes the ride.
router.patch(
  "/:rideId/complete",
  authorize("driver"),
  completeRide
);

module.exports = router;
