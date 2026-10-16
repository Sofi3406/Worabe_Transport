
const mongoose = require("mongoose");

const userSchema = new mongoose.Schema(
  {
    fullName: {
      type: String,
      required: true,
      trim: true,
    },

    phone: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },

    passwordHash: {
      type: String,
      required: true,
      select: false,
    },

    role: {
      type: String,
      enum: ["passenger", "driver", "admin"],
      required: true,
      default: "passenger",
    },

    preferredLanguage: {
      type: String,
      enum: ["en", "am"],
      default: "en",
    },

    isActive: {
      type: Boolean,
      default: true,
    },

    // Tracks the user's currently active ride.
    // Updated by the backend during ride lifecycle transactions.
    activeRideRequestId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "RideRequest",
      default: null,
    },

    // Identifies how the user participates in that active ride.
    activeRideRole: {
      type: String,
      enum: ["passenger", "driver", null],
      default: null,
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model("User", userSchema);
