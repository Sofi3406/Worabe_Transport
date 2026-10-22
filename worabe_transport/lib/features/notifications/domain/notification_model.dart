class NotificationModel {
  const NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.createdAt,
    required this.isRead,
  });

  final String id;
  final String type;
  final String title;
  final String message;
  final DateTime createdAt;
  final bool isRead;

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: (json['_id'] ?? json['id']).toString(),
      type: json['type'] as String? ?? 'general',
      title: json['title'] as String? ?? 'Notification',
      message: json['message'] as String? ?? '',
      createdAt: DateTime.parse(json['createdAt'] as String),
      isRead: json['readAt'] != null,
    );
  }
}
