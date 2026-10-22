import 'package:dio/dio.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/core/network/api_client.dart';
import '../domain/notification_model.dart';

class NotificationRepository {
  NotificationRepository({required ApiClient apiClient}) : _dio = apiClient.dio;

  final Dio _dio;

  AppException _map(DioException e) => e.error is AppException
      ? e.error as AppException
      : ServerException(e.message ?? 'Request failed.');

  Future<List<NotificationModel>> listMine() async {
    try {
      final response = await _dio.get('/notifications');
      final items = response.data['notifications'] as List<dynamic>;
      return items
          .map((item) => NotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<void> markRead(String id) async {
    try {
      await _dio.patch('/notifications/$id/read');
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<void> markAllRead() async {
    try {
      await _dio.patch('/notifications/read-all');
    } on DioException catch (e) {
      throw _map(e);
    }
  }
}
