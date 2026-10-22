const mongoose = require("mongoose");
const Notification = require("../models/Notification");

async function listMyNotifications(req, res) {
  try {
    const notifications = await Notification.find({ userId: req.user.id })
      .sort({ createdAt: -1 })
      .limit(50)
      .lean();

    return res.status(200).json({
      count: notifications.length,
      unreadCount: notifications.filter((item) => !item.readAt).length,
      notifications,
    });
  } catch (error) {
    console.error("List notifications error:", error.message);
    return res.status(500).json({ message: "Unable to retrieve notifications." });
  }
}

async function markNotificationRead(req, res) {
  try {
    if (!mongoose.Types.ObjectId.isValid(req.params.notificationId)) {
      return res.status(400).json({ message: "Invalid notification ID." });
    }

    const notification = await Notification.findOneAndUpdate(
      { _id: req.params.notificationId, userId: req.user.id },
      { $set: { readAt: new Date() } },
      { new: true }
    ).lean();

    if (!notification) {
      return res.status(404).json({ message: "Notification not found." });
    }

    return res.status(200).json({ notification });
  } catch (error) {
    console.error("Mark notification read error:", error.message);
    return res.status(500).json({ message: "Unable to update notification." });
  }
}

async function markAllNotificationsRead(req, res) {
  try {
    await Notification.updateMany(
      { userId: req.user.id, readAt: null },
      { $set: { readAt: new Date() } }
    );
    return res.status(200).json({ message: "Notifications marked as read." });
  } catch (error) {
    console.error("Mark all notifications read error:", error.message);
    return res.status(500).json({ message: "Unable to update notifications." });
  }
}

module.exports = {
  listMyNotifications,
  markNotificationRead,
  markAllNotificationsRead,
};
