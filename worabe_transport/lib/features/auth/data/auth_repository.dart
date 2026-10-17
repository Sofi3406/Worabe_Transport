import 'package:dio/dio.dart';
import '../../../core/network/api_client.dart';
import '../../../core/storage/token_storage.dart';
import '../../../shared/models/user_model.dart';
import '../../../core/errors/app_exception.dart';

class AuthRepository {
  AuthRepository({
    required ApiClient apiClient,
    required TokenStorage tokenStorage,
  }) : _dio = apiClient.dio,
       _tokenStorage = tokenStorage;

  final Dio _dio;
  final TokenStorage _tokenStorage;

  AppException _map(DioException e) => e.error is AppException
      ? e.error as AppException
      : ServerException(e.message ?? 'Request failed.');

  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
    String? vehiclePlate,
    String preferredLanguage = 'en',
  }) async {
    try {
      final body = <String, dynamic>{
        'fullName': fullName,
        'phone': phone,
        'password': password,
        'role': role,
        'preferredLanguage': preferredLanguage,
      };
      if (vehiclePlate != null) body['vehiclePlate'] = vehiclePlate;
      await _dio.post('/auth/register', data: body);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<({UserModel user, String token})> login({
    required String phone,
    required String password,
  }) async {
    try {
      final res = await _dio.post(
        '/auth/login',
        data: {'phone': phone, 'password': password},
      );
      final token = res.data['token'] as String;
      final user = UserModel.fromJson(res.data['user'] as Map<String, dynamic>);
      await _tokenStorage.saveToken(token);
      return (user: user, token: token);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<UserModel> getMe() async {
    try {
      final res = await _dio.get('/auth/me');
      return UserModel.fromJson(res.data['user'] as Map<String, dynamic>);
    } on DioException catch (e) {
      throw _map(e);
    }
  }

  Future<void> logout() => _tokenStorage.clearToken();
}
