class AppException implements Exception {
  const AppException(this.message);
  final String message;

  @override
  String toString() => message;
}

class NetworkException extends AppException {
  const NetworkException([super.message = 'No internet connection.']);
}

class UnauthorizedException extends AppException {
  const UnauthorizedException([super.message = 'Session expired. Please log in again.']);
}

class ForbiddenException extends AppException {
  const ForbiddenException([super.message = 'You do not have permission to do this.']);
}

class NotFoundException extends AppException {
  const NotFoundException([super.message = 'The requested resource was not found.']);
}

class ConflictException extends AppException {
  const ConflictException([super.message = 'A conflict occurred.']);
}

class ValidationException extends AppException {
  const ValidationException([super.message = 'Please check the submitted information.']);
}

class ServerException extends AppException {
  const ServerException([super.message = 'An unexpected server error occurred.']);
}
