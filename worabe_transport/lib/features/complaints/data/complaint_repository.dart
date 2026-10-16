import 'package:dio/dio.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/core/network/api_client.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';

class ComplaintRepository {
  ComplaintRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  AppException _map(DioException e) => e.error is AppException
      ? e.error as AppException
      : ServerException(e.message ?? 'Request failed.');

  Future<ComplaintModel> submit({
    required String category,
    required String description,
    String? rideId,
  }) async {
    try {
      final res = await _dio.post('/complaints', data: {
        'category': category,
        'description': description,
        if (rideId != null && rideId.isNotEmpty) 'rideId': rideId,
      });
      return ComplaintModel.fromJson(
        res.data['complaint'] as Map<String, dynamic>,
      );
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<List<ComplaintModel>> listMine() async {
    try {
      final res = await _dio.get('/complaints');
      final list = res.data['complaints'] as List<dynamic>;
      return list
          .map((e) => ComplaintModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _map(e);
    }
  }
}
