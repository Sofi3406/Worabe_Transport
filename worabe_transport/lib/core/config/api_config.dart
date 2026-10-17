import 'api_host.dart';

class ApiConfig {
  static const _configuredBaseUrl = String.fromEnvironment('API_BASE_URL');

  static final baseUrl = _configuredBaseUrl.isNotEmpty
      ? _configuredBaseUrl
      : 'http://$apiHost:5000/api';
}
