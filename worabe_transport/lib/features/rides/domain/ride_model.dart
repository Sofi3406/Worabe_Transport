class RideModel {
  const RideModel({
    required this.id,
    required this.passengerId,
    required this.driverId,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.status,
    required this.createdAt,
    this.agreedFare,
    this.passengerName,
    this.driverName,
  });

  final String id;
  final String passengerId;
  final String driverId;
  final String pickupLabel;
  final String destinationLabel;
  final String status;
  final DateTime createdAt;
  final num? agreedFare;
  final String? passengerName;
  final String? driverName;

  bool get isPending => status == 'pending';
  bool get isAccepted => status == 'accepted';
  bool get isCompleted => status == 'completed';
  bool get isCancelled => status == 'cancelled';
  bool get isRejected => status == 'rejected';

  static String _refId(dynamic value) {
    if (value == null) return '';
    if (value is String) return value;
    if (value is Map<String, dynamic>) {
      return (value['_id'] ?? value['id']).toString();
    }
    return value.toString();
  }

  static String? _refName(dynamic value) {
    if (value is Map<String, dynamic>) {
      return value['fullName'] as String?;
    }
    return null;
  }

  factory RideModel.fromJson(Map<String, dynamic> json) {
    final pickup = json['pickup'];
    final dest = json['destination'];
    final passenger = json['passengerId'];
    final driver = json['driverId'];

    return RideModel(
      id: (json['_id'] ?? json['id']).toString(),
      passengerId: _refId(passenger),
      driverId: _refId(driver),
      pickupLabel: pickup is Map
          ? pickup['label'] as String
          : pickup as String? ?? '',
      destinationLabel: dest is Map
          ? dest['label'] as String
          : dest as String? ?? '',
      status: json['status'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      agreedFare: json['agreedFare'] as num?,
      passengerName: _refName(passenger),
      driverName: _refName(driver),
    );
  }
}
