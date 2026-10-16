
const express = require("express");

const {
  register,
  login,
  getMe,
} = require("../controllers/authController");

const { authenticate } = require("../middleware/auth");

const router = express.Router();

router.post("/register", register);
router.post("/login", login);

// Protected route: requires a valid JWT.
router.get("/me", authenticate, getMe);

module.exports = router;
