import 'package:dio/dio.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../domain/ride_model.dart';

class RideRepository {
  RideRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  AppException _map(DioException e) =>
      e.error is AppException ? e.error as AppException : ServerException(e.message ?? 'Request failed.');

  Future<RideModel> createRide({
    required String driverId,
    required String pickupLabel,
    required String destinationLabel,
    String? idempotencyKey,
  }) async {
    try {
      final options = idempotencyKey != null
          ? Options(headers: {'Idempotency-Key': idempotencyKey})
          : null;
      final res = await _dio.post(
        '/rides',
        data: {
          'driverId': driverId,
          'pickup': {'label': pickupLabel},
          'destination': {'label': destinationLabel},
        },
        options: options,
      );
      return RideModel.fromJson(res.data['ride'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<List<RideModel>> listMyRides() async {
    try {
      final res = await _dio.get('/rides');
      final list = res.data['rides'] as List<dynamic>;
      return list
          .map((e) => RideModel.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<RideModel> respondToRide(String rideId, String action) async {
    try {
      final res = await _dio.patch(
        '/rides/$rideId/response',
        data: {'action': action},
      );
      return RideModel.fromJson(res.data['ride'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<RideModel> cancelRide(String rideId) async {
    try {
      final res = await _dio.patch('/rides/$rideId/cancel');
      return RideModel.fromJson(res.data['ride'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<RideModel> completeRide(String rideId) async {
    try {
      final res = await _dio.patch('/rides/$rideId/complete');
      return RideModel.fromJson(res.data['ride'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }
}
