import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/driver/data/driver_repository.dart';
import 'package:worabe_transport/features/driver/domain/driver_model.dart';

final driverRepositoryProvider = Provider<DriverRepository>((ref) {
  return DriverRepository(apiClient: ref.watch(apiClientProvider));
});

final driverListProvider =
    AsyncNotifierProvider<DriverListNotifier, List<DriverModel>>(
        DriverListNotifier.new);

class DriverListNotifier extends AsyncNotifier<List<DriverModel>> {
  @override
  Future<List<DriverModel>> build() =>
      ref.read(driverRepositoryProvider).listDrivers();

  Future<void> refresh({String? availability}) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(driverRepositoryProvider).listDrivers(availability: availability),
    );
  }
}

final myDriverProfileProvider =
    AsyncNotifierProvider<MyDriverProfileNotifier, DriverModel?>(
        MyDriverProfileNotifier.new);

class MyDriverProfileNotifier extends AsyncNotifier<DriverModel?> {
  @override
  Future<DriverModel?> build() =>
      ref.read(driverRepositoryProvider).getMyProfile();

  Future<void> toggleAvailability(String current) async {
    final next = current == 'online' ? 'offline' : 'online';
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(driverRepositoryProvider).updateAvailability(next);
      return ref.read(driverRepositoryProvider).getMyProfile();
    });
  }
}
