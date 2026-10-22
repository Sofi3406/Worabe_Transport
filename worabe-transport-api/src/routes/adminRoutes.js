
const express = require("express");

const {
  listPendingDrivers,
  reviewDriver,
  listAllRides,
} = require("../controllers/adminController");

const {
  authenticate,
  authorize,
} = require("../middleware/auth");

const router = express.Router();

// Every admin endpoint requires login and the admin role.
router.use(authenticate, authorize("admin"));

// View applications awaiting review.
router.get("/drivers/pending", listPendingDrivers);

// Approve or reject a driver.
router.patch(
  "/drivers/:driverId/verification",
  reviewDriver
);

// View all passenger and driver ride history.
router.get("/rides", listAllRides);

module.exports = router;
