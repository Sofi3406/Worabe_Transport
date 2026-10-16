import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/core/localization/locale_provider.dart';
import 'package:worabe_transport/core/network/api_client.dart';
import 'package:worabe_transport/core/storage/token_storage.dart';
import 'package:worabe_transport/shared/models/user_model.dart';
import 'package:worabe_transport/features/auth/data/auth_repository.dart';

final tokenStorageProvider = Provider<TokenStorage>((_) => const TokenStorage());

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(tokenStorage: ref.watch(tokenStorageProvider));
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepository(
    apiClient: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(tokenStorageProvider),
  );
});

class AuthUserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel? user) => state = user;
}

final authUserProvider =
    NotifierProvider<AuthUserNotifier, UserModel?>(AuthUserNotifier.new);

class AuthNotifier extends AsyncNotifier<UserModel?> {
  @override
  Future<UserModel?> build() async {
    final storage = ref.watch(tokenStorageProvider);
    final token = await storage.readToken();
    if (token == null) return null;
    try {
      final user = await ref.read(authRepositoryProvider).getMe();
      ref.read(authUserProvider.notifier).setUser(user);
      return user;
    } catch (_) {
      await storage.clearToken();
      return null;
    }
  }

  Future<void> login({required String phone, required String password}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      final result = await ref.read(authRepositoryProvider).login(
            phone: phone,
            password: password,
          );
      ref.read(authUserProvider.notifier).setUser(result.user);
      await ref
          .read(localeProvider.notifier)
          .setLocale(result.user.preferredLanguage);
      return result.user;
    });
  }

  Future<void> register({
    required String fullName,
    required String phone,
    required String password,
    required String role,
    String? vehiclePlate,
  }) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(authRepositoryProvider).register(
            fullName: fullName,
            phone: phone,
            password: password,
            role: role,
            vehiclePlate: vehiclePlate,
          );
      return null;
    });
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    ref.read(authUserProvider.notifier).setUser(null);
    state = const AsyncData(null);
  }
}

final authNotifierProvider =
    AsyncNotifierProvider<AuthNotifier, UserModel?>(AuthNotifier.new);
