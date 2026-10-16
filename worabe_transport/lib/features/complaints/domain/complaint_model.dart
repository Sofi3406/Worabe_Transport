class ComplaintModel {
  const ComplaintModel({
    required this.id,
    required this.category,
    required this.description,
    required this.status,
    required this.createdAt,
    this.rideId,
    this.adminNote,
    this.reporterName,
  });

  final String id;
  final String? rideId;
  final String category;
  final String description;
  final String status;
  final DateTime createdAt;
  final String? adminNote;
  final String? reporterName;

  static String? _optionalRefId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is Map<String, dynamic>) {
      return (value['_id'] ?? value['id'])?.toString();
    }
    return value.toString();
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final reporter = json['reporterId'];
    return ComplaintModel(
      id: (json['_id'] ?? json['id']).toString(),
      rideId: _optionalRefId(json['rideId']),
      category: json['category'] as String,
      description: json['description'] as String,
      status: json['status'] as String? ?? 'open',
      createdAt: DateTime.parse(json['createdAt'] as String),
      adminNote: json['adminNote'] as String?,
      reporterName: reporter is Map<String, dynamic>
          ? reporter['fullName'] as String?
          : null,
    );
  }
}

const complaintCategories = <String, String>{
  'driver_behavior': 'Driver behavior',
  'passenger_behavior': 'Passenger behavior',
  'fare_dispute': 'Fare dispute',
  'driver_not_arriving': 'Driver not arriving',
  'safety_concern': 'Safety concern',
  'other': 'Other',
};
