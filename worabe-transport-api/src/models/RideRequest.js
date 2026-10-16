
const mongoose = require("mongoose");

const placeSchema = new mongoose.Schema(
  {
    label: {
      type: String,
      required: true,
      trim: true,
      maxlength: 200,
    },
  },
  { _id: false }
);

const rideRequestSchema = new mongoose.Schema(
  {
    passengerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    driverId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      index: true,
    },

    pickup: {
      type: placeSchema,
      required: true,
    },

    destination: {
      type: placeSchema,
      required: true,
    },

    status: {
      type: String,
      enum: [
        "pending",
        "accepted",
        "rejected",
        "cancelled",
        "completed",
      ],
      default: "pending",
      index: true,
    },

    agreedFare: {
      type: Number,
      min: 0,
      default: null,
    },

    // Identifies retries of the same passenger request.
    requestKey: {
      type: String,
      trim: true,
      maxlength: 100,
    },
  },
  { timestamps: true }
);

// Prevent duplicate requests when the same passenger retries
// with the same non-empty idempotency key.
rideRequestSchema.index(
  { passengerId: 1, requestKey: 1 },
  {
    unique: true,
    partialFilterExpression: {
      requestKey: { $type: "string" },
    },
  }
);

module.exports = mongoose.model("RideRequest", rideRequestSchema);
