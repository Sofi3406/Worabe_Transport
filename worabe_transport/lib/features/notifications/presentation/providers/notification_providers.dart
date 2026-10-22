import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import '../../data/notification_repository.dart';
import '../../domain/notification_model.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  return NotificationRepository(apiClient: ref.watch(apiClientProvider));
});

final notificationsProvider = AsyncNotifierProvider<NotificationsNotifier,
    List<NotificationModel>>(NotificationsNotifier.new);

class NotificationsNotifier extends AsyncNotifier<List<NotificationModel>> {
  @override
  Future<List<NotificationModel>> build() {
    return ref.read(notificationRepositoryProvider).listMine();
  }

  Future<void> refresh() async {
    state = await AsyncValue.guard(
      () => ref.read(notificationRepositoryProvider).listMine(),
    );
  }

  Future<void> markRead(String id) async {
    await ref.read(notificationRepositoryProvider).markRead(id);
    await refresh();
  }

  Future<void> markAllRead() async {
    await ref.read(notificationRepositoryProvider).markAllRead();
    await refresh();
  }
}
