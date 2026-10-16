import 'package:dio/dio.dart';
import '../../../core/errors/app_exception.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/local_database.dart';
import '../domain/driver_model.dart';

class DriverRepository {
  DriverRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  AppException _map(DioException e) =>
      e.error is AppException ? e.error as AppException : ServerException(e.message ?? 'Request failed.');

  Future<List<DriverModel>> listDrivers({String? availability}) async {
    try {
      final params = <String, dynamic>{};
      if (availability != null) params['availability'] = availability;
      final res = await _dio.get('/drivers', queryParameters: params);
      final list = res.data['drivers'] as List<dynamic>;
      final drivers = list
          .map((e) => DriverModel.fromJson(e as Map<String, dynamic>))
          .toList();
      await LocalDatabase.instance
          .upsertDrivers(drivers.map((d) => d.toCacheMap()).toList());
      return drivers;
    } on DioException catch (e) {
      if (e.error is NetworkException) {
        final cached = await LocalDatabase.instance.getCachedDrivers();
        return cached.map(DriverModel.fromCacheMap).toList();
      }
      throw _map(e);
    }
  }

  Future<DriverModel> getMyProfile() async {
    try {
      final res = await _dio.get('/drivers/me');
      return DriverModel.fromJson(res.data['driver'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<String> updateAvailability(String availability) async {
    try {
      final res = await _dio.patch(
        '/drivers/me/availability',
        data: {'availability': availability},
      );
      return res.data['availability'] as String;
    } on DioException catch (e) {
      throw _map(e);
    }
  }
}
