
const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");

const User = require("../models/User");
const DriverProfile = require("../models/DriverProfile");

// Create a JWT token after successful authentication
function generateToken(user) {
  return jwt.sign(
    {
      id: user._id.toString(),
      role: user.role,
    },
    process.env.JWT_SECRET,
    {
      expiresIn: process.env.JWT_EXPIRES_IN || "1d",
    }
  );
}

// POST /api/auth/register
async function register(req, res) {
  try {
    const { fullName, phone, password, role, vehiclePlate } = req.body;

    if (!fullName || !phone || !password) {
      return res.status(400).json({
        message: "Full name, phone, and password are required.",
      });
    }

    if (typeof fullName !== "string" ||
        typeof phone !== "string" ||
        typeof password !== "string") {
      return res.status(400).json({
        message: "Invalid input types.",
      });
    }

    if (password.length < 8) {
      return res.status(400).json({
        message: "Password must be at least 8 characters long.",
      });
    }

    // Public registration must never create an admin account.
    const accountRole = role || "passenger";

    if (!["passenger", "driver"].includes(accountRole)) {
      return res.status(400).json({
        message: "Role must be passenger or driver.",
      });
    }

    const normalizedPhone = phone.trim();

    if (!normalizedPhone) {
      return res.status(400).json({
        message: "Phone number is required.",
      });
    }

    if (accountRole === "driver" &&
        (typeof vehiclePlate !== "string" || !vehiclePlate.trim())) {
      return res.status(400).json({
        message: "Vehicle plate is required for driver registration.",
      });
    }

    const existingUser = await User.findOne({
      phone: normalizedPhone,
    });

    if (existingUser) {
      return res.status(409).json({
        message: "An account with this phone number already exists.",
      });
    }

    const passwordHash = await bcrypt.hash(password, 12);

    const user = await User.create({
      fullName: fullName.trim(),
      phone: normalizedPhone,
      passwordHash,
      role: accountRole,
    });

    // New driver accounts require admin verification.
    if (accountRole === "driver") {
      try {
        await DriverProfile.create({
          userId: user._id,
          vehicleType: "bajaj",
          vehiclePlate: vehiclePlate.trim(),
          verificationStatus: "pending",
          isVerified: false,
          availability: "offline",
        });
      } catch (error) {
        // Avoid leaving a driver account without its profile.
        await User.deleteOne({ _id: user._id });
        throw error;
      }
    }

    return res.status(201).json({
      message:
        accountRole === "driver"
          ? "Registration successful. Your driver account awaits admin verification."
          : "Registration successful.",
      user: {
        id: user._id,
        fullName: user.fullName,
        phone: user.phone,
        role: user.role,
      },
    });
  } catch (error) {
    if (error.code === 11000) {
      return res.status(409).json({
        message: "An account with this phone number already exists.",
      });
    }

    console.error("Registration error:", error.message);

    return res.status(500).json({
      message: "Unable to register. Please try again.",
    });
  }
}

// POST /api/auth/login
async function login(req, res) {
  try {
    const { phone, password } = req.body;

    if (
      typeof phone !== "string" ||
      typeof password !== "string" ||
      !phone.trim() ||
      !password
    ) {
      return res.status(400).json({
        message: "Phone and password are required.",
      });
    }

    const user = await User.findOne({
      phone: phone.trim(),
    }).select("+passwordHash");

    if (!user || !(await bcrypt.compare(password, user.passwordHash))) {
      return res.status(401).json({
        message: "Invalid phone number or password.",
      });
    }

    if (!user.isActive) {
      return res.status(403).json({
        message: "This account has been disabled.",
      });
    }

    const token = generateToken(user);

    return res.status(200).json({
      message: "Login successful.",
      token,
      user: {
        id: user._id,
        fullName: user.fullName,
        phone: user.phone,
        role: user.role,
        preferredLanguage: user.preferredLanguage,
      },
    });
  } catch (error) {
    console.error("Login error:", error.message);

    return res.status(500).json({
      message: "Unable to log in. Please try again.",
    });
  }
}



async function getMe(req, res) {
  return res.status(200).json({
    user: req.user,
  });
}


module.exports = {
  register,
  login,
  getMe,
};

