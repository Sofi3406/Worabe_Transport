const express = require("express");
const {
  listMyNotifications,
  markNotificationRead,
  markAllNotificationsRead,
} = require("../controllers/notificationController");
const { authenticate } = require("../middleware/auth");

const router = express.Router();

router.use(authenticate);
router.get("/", listMyNotifications);
router.patch("/read-all", markAllNotificationsRead);
router.patch("/:notificationId/read", markNotificationRead);

module.exports = router;
