import 'package:dio/dio.dart';
import '../config/api_config.dart';
import '../errors/app_exception.dart';
import '../storage/token_storage.dart';

class ApiClient {
  ApiClient({TokenStorage? tokenStorage})
      : _tokenStorage = tokenStorage ?? const TokenStorage() {
    dio = Dio(
      BaseOptions(
        baseUrl: ApiConfig.baseUrl,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 15),
        headers: {'Content-Type': 'application/json'},
      ),
    );
    dio.interceptors.add(_AuthInterceptor(_tokenStorage));
    dio.interceptors.add(_ErrorInterceptor());
  }

  late final Dio dio;
  final TokenStorage _tokenStorage;
}

class _AuthInterceptor extends Interceptor {
  _AuthInterceptor(this._storage);
  final TokenStorage _storage;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await _storage.readToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}

class _ErrorInterceptor extends Interceptor {
  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final status = err.response?.statusCode;
    final message = err.response?.data is Map
        ? (err.response!.data as Map)['message'] as String? ?? err.message
        : err.message;

    if (err.type == DioExceptionType.connectionError ||
        err.type == DioExceptionType.connectionTimeout ||
        err.type == DioExceptionType.receiveTimeout) {
      handler.reject(
        DioException(
          requestOptions: err.requestOptions,
          error: const NetworkException(),
          type: err.type,
        ),
      );
      return;
    }

    AppException mapped;
    switch (status) {
      case 400:
      case 422:
        mapped = ValidationException(message ?? 'Please check the submitted information.');
      case 401:
        mapped = UnauthorizedException(message ?? 'Unauthorized.');
      case 403:
        mapped = ForbiddenException(message ?? 'Forbidden.');
      case 404:
        mapped = NotFoundException(message ?? 'Not found.');
      case 409:
        mapped = ConflictException(message ?? 'Conflict.');
      default:
        mapped = ServerException(message ?? 'Server error.');
    }

    handler.reject(
      DioException(
        requestOptions: err.requestOptions,
        response: err.response,
        error: mapped,
        type: err.type,
      ),
    );
  }
}
