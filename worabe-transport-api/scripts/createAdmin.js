
require("dotenv").config();

const mongoose = require("mongoose");
const bcrypt = require("bcryptjs");
const User = require("../src/models/User");

async function createAdmin() {
  try {
    if (
      !process.env.MONGODB_URI ||
      !process.env.ADMIN_FULL_NAME ||
      !process.env.ADMIN_PHONE ||
      !process.env.ADMIN_PASSWORD
    ) {
      throw new Error(
        "Set MONGODB_URI, ADMIN_FULL_NAME, ADMIN_PHONE, and ADMIN_PASSWORD in .env."
      );
    }

    if (process.env.ADMIN_PASSWORD.length < 12) {
      throw new Error(
        "Use an admin password with at least 12 characters."
      );
    }

    await mongoose.connect(process.env.MONGODB_URI);

    const phone = process.env.ADMIN_PHONE.trim();
    const existingUser = await User.findOne({ phone });

    if (existingUser) {
      throw new Error(
        "An account with this phone already exists. No changes were made."
      );
    }

    const passwordHash = await bcrypt.hash(
      process.env.ADMIN_PASSWORD,
      12
    );

    await User.create({
      fullName: process.env.ADMIN_FULL_NAME.trim(),
      phone,
      passwordHash,
      role: "admin",
      isActive: true,
    });

    console.log("Administrator account created successfully.");
  } catch (error) {
    console.error("Admin setup failed:", error.message);
    process.exitCode = 1;
  } finally {
    await mongoose.disconnect().catch(() => {});
  }
}

createAdmin();
