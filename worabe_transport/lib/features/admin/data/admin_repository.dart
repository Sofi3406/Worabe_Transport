import 'package:dio/dio.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/core/network/api_client.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';
class PendingDriverModel {
  const PendingDriverModel({
    required this.profileId,
    required this.fullName,
    required this.phone,
    required this.vehiclePlate,
    required this.verificationStatus,
  });

  final String profileId;
  final String fullName;
  final String phone;
  final String vehiclePlate;
  final String verificationStatus;

  factory PendingDriverModel.fromJson(Map<String, dynamic> json) =>
      PendingDriverModel(
        profileId: (json['id'] ?? json['_id']).toString(),
        fullName: json['fullName'] as String,
        phone: json['phone'] as String,
        vehiclePlate: json['vehiclePlate'] as String,
        verificationStatus: json['verificationStatus'] as String? ?? 'pending',
      );
}

class AdminRepository {
  AdminRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  AppException _map(DioException e) => e.error is AppException
      ? e.error as AppException
      : ServerException(e.message ?? 'Request failed.');

  Future<List<PendingDriverModel>> listPendingDrivers() async {
    try {
      final res = await _dio.get('/admin/drivers/pending');
      final list = res.data['drivers'] as List<dynamic>;
      return list
          .map((e) => PendingDriverModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<void> reviewDriver(String profileId, String status) async {
    try {
      await _dio.patch(
        '/admin/drivers/$profileId/verification',
        data: {'status': status},
      );
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<List<ComplaintModel>> listAllComplaints({String? status}) async {
    try {
      final res = await _dio.get(
        '/complaints/admin/all',
        queryParameters: status != null ? {'status': status} : null,
      );
      final list = res.data['complaints'] as List<dynamic>;
      return list
          .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<void> reviewComplaint({
    required String complaintId,
    required String status,
    String? adminNote,
  }) async {
    try {
      await _dio.patch(
        '/complaints/admin/$complaintId',
        data: {
          'status': status,
          if (adminNote != null) 'adminNote': adminNote,
        },
      );
    } on DioException catch (e) {
      throw _map(e);
    }
  }
}
