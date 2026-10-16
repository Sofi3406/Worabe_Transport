import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/rides/data/ride_repository.dart';
import 'package:worabe_transport/features/rides/data/sync_service.dart';
import 'package:worabe_transport/features/rides/domain/ride_model.dart';

final rideRepositoryProvider = Provider<RideRepository>((ref) {
  return RideRepository(apiClient: ref.watch(apiClientProvider));
});

final syncServiceProvider = Provider<SyncService>((ref) {
  return SyncService(rideRepository: ref.watch(rideRepositoryProvider));
});

final myRidesProvider =
    AsyncNotifierProvider<MyRidesNotifier, List<RideModel>>(MyRidesNotifier.new);

class MyRidesNotifier extends AsyncNotifier<List<RideModel>> {
  @override
  Future<List<RideModel>> build() =>
      ref.read(rideRepositoryProvider).listMyRides();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
        () => ref.read(rideRepositoryProvider).listMyRides());
  }

  Future<void> respond(String rideId, String action) async {
    state = await AsyncValue.guard(() async {
      await ref.read(rideRepositoryProvider).respondToRide(rideId, action);
      return ref.read(rideRepositoryProvider).listMyRides();
    });
  }

  Future<void> cancel(String rideId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(rideRepositoryProvider).cancelRide(rideId);
      return ref.read(rideRepositoryProvider).listMyRides();
    });
  }

  Future<void> complete(String rideId) async {
    state = await AsyncValue.guard(() async {
      await ref.read(rideRepositoryProvider).completeRide(rideId);
      return ref.read(rideRepositoryProvider).listMyRides();
    });
  }
}
