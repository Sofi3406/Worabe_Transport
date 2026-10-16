
const mongoose = require("mongoose");

const complaintSchema = new mongoose.Schema(
  {
    reporterId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    rideId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "RideRequest",
      default: null,
    },

    category: {
      type: String,
      enum: [
        "driver_behavior",
        "passenger_behavior",
        "fare_dispute",
        "driver_not_arriving",
        "safety_concern",
        "other",
      ],
      required: true,
    },

    description: {
      type: String,
      required: true,
      trim: true,
      maxlength: 2000,
    },

    status: {
      type: String,
      enum: ["open", "under_review", "resolved", "dismissed"],
      default: "open",
      index: true,
    },

    adminNote: {
      type: String,
      trim: true,
      maxlength: 1000,
      default: "",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("Complaint", complaintSchema);
