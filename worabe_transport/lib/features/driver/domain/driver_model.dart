import 'dart:convert';

class DriverModel {
  const DriverModel({
    required this.id,
    required this.fullName,
    required this.phone,
    required this.vehicleType,
    required this.vehiclePlate,
    required this.availability,
    this.serviceAreas = const [],
    this.destinations = const [],
    this.verificationStatus,
    this.isVerified,
  });

  final String id;
  final String fullName;
  final String phone;
  final String vehicleType;
  final String vehiclePlate;
  final String availability;
  final List<String> serviceAreas;
  final List<String> destinations;
  final String? verificationStatus;
  final bool? isVerified;

  bool get isOnline => availability == 'online';

  factory DriverModel.fromJson(Map<String, dynamic> json) => DriverModel(
        id: json['id'] as String,
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        vehicleType: json['vehicleType'] as String? ?? 'bajaj',
        vehiclePlate: json['vehiclePlate'] as String,
        availability: json['availability'] as String,
        serviceAreas: (json['serviceAreas'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        destinations: (json['destinations'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        verificationStatus: json['verificationStatus'] as String?,
        isVerified: json['isVerified'] as bool?,
      );

  Map<String, dynamic> toCacheMap() => {
        'id': id,
        'full_name': fullName,
        'phone': phone,
        'vehicle_plate': vehiclePlate,
        'service_areas_json': jsonEncode(serviceAreas),
        'availability': availability,
        'updated_at': DateTime.now().toIso8601String(),
      };

  factory DriverModel.fromCacheMap(Map<String, dynamic> map) => DriverModel(
        id: map['id'] as String,
        fullName: map['full_name'] as String,
        phone: map['phone'] as String,
        vehicleType: 'bajaj',
        vehiclePlate: map['vehicle_plate'] as String,
        availability: map['availability'] as String,
        serviceAreas: (jsonDecode(map['service_areas_json'] as String) as List)
            .map((e) => e as String)
            .toList(),
      );
}
