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
    this.reporterPhone,
    this.reporterRole,
    this.passengerName,
    this.driverName,
    this.pickupLabel,
    this.destinationLabel,
    this.rideStatus,
  });

  final String id;
  final String? rideId;
  final String category;
  final String description;
  final String status;
  final DateTime createdAt;
  final String? adminNote;
  final String? reporterName;
  final String? reporterPhone;
  final String? reporterRole;
  final String? passengerName;
  final String? driverName;
  final String? pickupLabel;
  final String? destinationLabel;
  final String? rideStatus;

  static String? _optionalRefId(dynamic value) {
    if (value == null) return null;
    if (value is String) return value.isEmpty ? null : value;
    if (value is Map<String, dynamic>) {
      return (value['_id'] ?? value['id'])?.toString();
    }
    return value.toString();
  }

  static String? _optionalLabel(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['label'] as String?;
    }
    return null;
  }

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    final reporter = json['reporterId'];
    final ride = json['rideId'];
    final passenger = ride is Map<String, dynamic> ? ride['passengerId'] : null;
    final driver = ride is Map<String, dynamic> ? ride['driverId'] : null;
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
      reporterPhone: reporter is Map<String, dynamic>
          ? reporter['phone'] as String?
          : null,
      reporterRole: reporter is Map<String, dynamic>
          ? reporter['role'] as String?
          : null,
      passengerName: passenger is Map<String, dynamic>
          ? passenger['fullName'] as String?
          : null,
      driverName: driver is Map<String, dynamic>
          ? driver['fullName'] as String?
          : null,
      pickupLabel: ride is Map<String, dynamic>
          ? _optionalLabel(ride['pickup'])
          : null,
      destinationLabel: ride is Map<String, dynamic>
          ? _optionalLabel(ride['destination'])
          : null,
      rideStatus: ride is Map<String, dynamic>
          ? ride['status'] as String?
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
