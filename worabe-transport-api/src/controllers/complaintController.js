
const mongoose = require("mongoose");

const Complaint = require("../models/Complaint");
const RideRequest = require("../models/RideRequest");

// POST /api/complaints
// A passenger or driver submits a complaint.
async function createComplaint(req, res) {
  try {
    const { rideId, category, description } = req.body;

    const allowedCategories = [
      "driver_behavior",
      "passenger_behavior",
      "fare_dispute",
      "driver_not_arriving",
      "safety_concern",
      "other",
    ];

    if (!allowedCategories.includes(category)) {
      return res.status(400).json({
        message: "Please provide a valid complaint category.",
      });
    }

    if (
      typeof description !== "string" ||
      !description.trim() ||
      description.trim().length > 2000
    ) {
      return res.status(400).json({
        message: "Description is required and must be 2000 characters or fewer.",
      });
    }

    // If a ride is supplied, verify that the reporter belongs to it.
    if (rideId !== undefined && rideId !== null && rideId !== "") {
      if (!mongoose.Types.ObjectId.isValid(rideId)) {
        return res.status(400).json({
          message: "Invalid ride ID.",
        });
      }

      const ride = await RideRequest.findOne({
        _id: rideId,
        $or: [
          { passengerId: req.user.id },
          { driverId: req.user.id },
        ],
      });

      if (!ride) {
        return res.status(404).json({
          message: "Ride not found or you are not part of this ride.",
        });
      }
    }

    const complaint = await Complaint.create({
      reporterId: req.user.id,
      rideId: rideId || null,
      category,
      description: description.trim(),
    });

    return res.status(201).json({
      message: "Complaint submitted successfully.",
      complaint: {
        id: complaint._id,
        rideId: complaint.rideId,
        category: complaint.category,
        description: complaint.description,
        status: complaint.status,
        createdAt: complaint.createdAt,
      },
    });
  } catch (error) {
    console.error("Create complaint error:", error.message);

    return res.status(500).json({
      message: "Unable to submit your complaint.",
    });
  }
}

// GET /api/complaints
// Passengers and drivers see only complaints they submitted.
async function listMyComplaints(req, res) {
  try {
    const complaints = await Complaint.find({
      reporterId: req.user.id,
    })
      .sort({ createdAt: -1 })
      .lean();

    return res.status(200).json({
      count: complaints.length,
      complaints,
    });
  } catch (error) {
    console.error("List complaints error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve your complaints.",
    });
  }
}

// GET /api/complaints/admin/all
// Administrators can review all submitted complaints.
async function listAllComplaints(req, res) {
  try {
    const filter = {};

    if (req.query.status) {
      const allowedStatuses = [
        "open",
        "under_review",
        "resolved",
        "dismissed",
      ];

      if (!allowedStatuses.includes(req.query.status)) {
        return res.status(400).json({
          message: "Invalid complaint status filter.",
        });
      }

      filter.status = req.query.status;
    }

    const complaints = await Complaint.find(filter)
      .populate("reporterId", "fullName phone role")
      .populate("rideId", "pickup destination status createdAt")
      .sort({ createdAt: -1 })
      .lean();

    return res.status(200).json({
      count: complaints.length,
      complaints,
    });
  } catch (error) {
    console.error("List all complaints error:", error.message);

    return res.status(500).json({
      message: "Unable to retrieve complaints.",
    });
  }
}

// PATCH /api/complaints/admin/:complaintId
// An administrator updates the review status and optional note.
async function reviewComplaint(req, res) {
  try {
    const { complaintId } = req.params;
    const { status, adminNote } = req.body;

    if (!mongoose.Types.ObjectId.isValid(complaintId)) {
      return res.status(400).json({
        message: "Invalid complaint ID.",
      });
    }

    const allowedStatuses = [
      "open",
      "under_review",
      "resolved",
      "dismissed",
    ];

    if (!allowedStatuses.includes(status)) {
      return res.status(400).json({
        message: "Please provide a valid complaint status.",
      });
    }

    if (
      adminNote !== undefined &&
      (typeof adminNote !== "string" || adminNote.length > 1000)
    ) {
      return res.status(400).json({
        message: "Admin note must be text of 1000 characters or fewer.",
      });
    }

    const update = { status };

    if (adminNote !== undefined) {
      update.adminNote = adminNote.trim();
    }

    const complaint = await Complaint.findByIdAndUpdate(
      complaintId,
      { $set: update },
      { new: true, runValidators: true }
    );

    if (!complaint) {
      return res.status(404).json({
        message: "Complaint not found.",
      });
    }

    return res.status(200).json({
      message: "Complaint updated successfully.",
      complaint,
    });
  } catch (error) {
    console.error("Review complaint error:", error.message);

    return res.status(500).json({
      message: "Unable to update this complaint.",
    });
  }
}

module.exports = {
  createComplaint,
  listMyComplaints,
  listAllComplaints,
  reviewComplaint,
};
