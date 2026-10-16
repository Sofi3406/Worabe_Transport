
const express = require("express");

const {
  createComplaint,
  listMyComplaints,
  listAllComplaints,
  reviewComplaint,
} = require("../controllers/complaintController");

const {
  authenticate,
  authorize,
} = require("../middleware/auth");

const router = express.Router();

router.use(authenticate);

// Passengers and drivers can submit complaints.
router.post(
  "/",
  authorize("passenger", "driver"),
  createComplaint
);

// Users can see only the complaints they submitted.
router.get(
  "/",
  authorize("passenger", "driver"),
  listMyComplaints
);

// Admin-only complaint review.
router.get(
  "/admin/all",
  authorize("admin"),
  listAllComplaints
);

router.patch(
  "/admin/:complaintId",
  authorize("admin"),
  reviewComplaint
);

module.exports = router;
