import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/complaints/data/complaint_repository.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';

final complaintRepositoryProvider = Provider<ComplaintRepository>((ref) {
  return ComplaintRepository(apiClient: ref.watch(apiClientProvider));
});

final myComplaintsProvider =
    AsyncNotifierProvider<MyComplaintsNotifier, List<ComplaintModel>>(
        MyComplaintsNotifier.new);

class MyComplaintsNotifier extends AsyncNotifier<List<ComplaintModel>> {
  @override
  Future<List<ComplaintModel>> build() =>
      ref.read(complaintRepositoryProvider).listMine();

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(complaintRepositoryProvider).listMine(),
    );
  }
}
