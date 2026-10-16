
const mongoose = require("mongoose");

const driverProfileSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
      unique: true,
    },

    vehicleType: {
      type: String,
      enum: ["bajaj"],
      default: "bajaj",
      required: true,
    },

    vehiclePlate: {
      type: String,
      required: true,
      trim: true,
    },

    serviceAreas: {
      type: [String],
      default: [],
    },

    destinations: {
      type: [String],
      default: [],
    },

    verificationStatus: {
      type: String,
      enum: ["pending", "approved", "rejected"],
      default: "pending",
    },

    isVerified: {
      type: Boolean,
      default: false,
    },

    availability: {
      type: String,
      enum: ["online", "offline"],
      default: "offline",
    },
  },
  { timestamps: true }
);

module.exports = mongoose.model(
  "DriverProfile",
  driverProfileSchema,
  "bajaj"
);
