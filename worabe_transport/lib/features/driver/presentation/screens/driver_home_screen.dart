import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/shared/widgets/error_message.dart';
import 'package:worabe_transport/features/driver/presentation/providers/driver_providers.dart';
import 'package:worabe_transport/features/driver/domain/driver_model.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/rides/presentation/providers/ride_providers.dart';
import 'package:worabe_transport/features/notifications/presentation/providers/notification_providers.dart';

class DriverHomeScreen extends ConsumerWidget {
  const DriverHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(myDriverProfileProvider);
    final ridesAsync = ref.watch(myRidesProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = notificationsAsync.maybeWhen(
      data: (items) => items.where((item) => !item.isRead).length,
      orElse: () => 0,
    );
    final pendingCount = ridesAsync.maybeWhen(
      data: (rides) => rides.where((r) => r.isPending).length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Driver Dashboard'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: pendingCount + unreadCount > 0,
              label: Text('${pendingCount + unreadCount}'),
              child: const Icon(Icons.notifications),
            ),
            tooltip: 'Notifications and requests',
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ride History',
            onPressed: () => context.push('/driver/rides'),
          ),
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: 'Complaints',
            onPressed: () => context.push('/complaints'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await ref.read(authNotifierProvider.notifier).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      body: profileAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: ErrorMessage(e.toString())),
        data: (DriverModel? profile) {
          if (profile == null) {
            return const Center(child: Text('Driver profile not found.'));
          }
          final isPending = profile.verificationStatus == 'pending';
          final isRejected = profile.verificationStatus == 'rejected';

          return Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _StatusCard(
                  name: profile.fullName,
                  plate: profile.vehiclePlate,
                  verificationStatus: profile.verificationStatus ?? 'pending',
                  availability: profile.availability,
                ),
                const SizedBox(height: 24),
                if (isPending)
                  const ErrorMessage(
                      'Your account is awaiting admin verification. You cannot go online yet.'),
                if (isRejected)
                  const ErrorMessage(
                      'Your driver application was rejected. Please contact support.'),
                if (!isPending && !isRejected)
                  _AvailabilityToggle(
                    availability: profile.availability,
                    onToggle: () => ref
                        .read(myDriverProfileProvider.notifier)
                        .toggleAvailability(profile.availability),
                  ),
                const SizedBox(height: 24),
                ridesAsync.when(
                  loading: () => const SizedBox.shrink(),
                  error: (_, __) => const SizedBox.shrink(),
                  data: (rides) {
                    final pending =
                        rides.where((r) => r.isPending).toList();
                    if (pending.isEmpty) return const SizedBox.shrink();
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Incoming requests',
                            style: Theme.of(context).textTheme.titleMedium),
                        const SizedBox(height: 8),
                        ...pending.take(3).map(
                              (r) => Card(
                                child: ListTile(
                                  title: Text(r.passengerName ?? 'Passenger'),
                                  subtitle: Text(
                                      '${r.pickupLabel} → ${r.destinationLabel}'),
                                  trailing: const Icon(Icons.chevron_right),
                                  onTap: () => context.push('/driver/rides'),
                                ),
                              ),
                            ),
                        if (pending.length > 3)
                          TextButton(
                            onPressed: () => context.push('/driver/rides'),
                            child: Text('View all ${pending.length} requests'),
                          ),
                      ],
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({
    required this.name,
    required this.plate,
    required this.verificationStatus,
    required this.availability,
  });

  final String name;
  final String plate;
  final String verificationStatus;
  final String availability;

  Color _statusColor() {
    switch (verificationStatus) {
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.orange;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text('Plate: $plate'),
            const SizedBox(height: 8),
            Row(
              children: [
                Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                      color: _statusColor(), shape: BoxShape.circle),
                ),
                const SizedBox(width: 6),
                Text('Verification: $verificationStatus'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AvailabilityToggle extends ConsumerWidget {
  const _AvailabilityToggle(
      {required this.availability, required this.onToggle});
  final String availability;
  final VoidCallback onToggle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final loading = ref.watch(myDriverProfileProvider).isLoading;
    final isOnline = availability == 'online';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(isOnline ? 'You are Online' : 'You are Offline',
                style: Theme.of(context).textTheme.titleMedium),
            Switch(
                value: isOnline,
                onChanged: loading ? null : (_) => onToggle()),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          isOnline
              ? 'Passengers can see and request you.'
              : 'You are not visible to passengers.',
          style: Theme.of(context).textTheme.bodySmall,
        ),
      ],
    );
  }
}
