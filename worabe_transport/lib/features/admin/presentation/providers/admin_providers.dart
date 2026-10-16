import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/admin/data/admin_repository.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';

final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  return AdminRepository(apiClient: ref.watch(apiClientProvider));
});

final pendingDriversProvider =
    AsyncNotifierProvider<PendingDriversNotifier, List<PendingDriverModel>>(
        PendingDriversNotifier.new);

class PendingDriversNotifier extends AsyncNotifier<List<PendingDriverModel>> {
  @override
  Future<List<PendingDriverModel>> build() =>
      ref.read(adminRepositoryProvider).listPendingDrivers();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(adminRepositoryProvider).listPendingDrivers(),
    );
  }

  Future<void> review(String profileId, String status) async {
    await ref.read(adminRepositoryProvider).reviewDriver(profileId, status);
    await refresh();
  }
}

final adminComplaintsProvider =
    AsyncNotifierProvider<AdminComplaintsNotifier, List<ComplaintModel>>(
        AdminComplaintsNotifier.new);

class AdminComplaintsNotifier extends AsyncNotifier<List<ComplaintModel>> {
  String? _statusFilter;

  @override
  Future<List<ComplaintModel>> build() => ref
      .read(adminRepositoryProvider)
      .listAllComplaints(status: _statusFilter);

  Future<void> refresh({String? status}) async {
    _statusFilter = status;
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref
          .read(adminRepositoryProvider)
          .listAllComplaints(status: _statusFilter),
    );
  }

  Future<void> updateComplaint({
    required String id,
    required String status,
    String? adminNote,
  }) async {
    await ref.read(adminRepositoryProvider).reviewComplaint(
          complaintId: id,
          status: status,
          adminNote: adminNote,
        );
    await refresh(status: _statusFilter);
  }
}
