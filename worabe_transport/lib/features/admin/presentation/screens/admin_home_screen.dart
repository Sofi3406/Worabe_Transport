import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/features/admin/presentation/providers/admin_providers.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';
import 'package:worabe_transport/features/notifications/presentation/providers/notification_providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingDriversProvider);
    final complaintsAsync = ref.watch(adminComplaintsProvider);
    final user = ref.watch(authUserProvider);
    final notificationsAsync = ref.watch(notificationsProvider);
    final unreadCount = notificationsAsync.maybeWhen(
      data: (items) => items.where((item) => !item.isRead).length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            icon: Badge(
              isLabelVisible: unreadCount > 0,
              label: Text('$unreadCount'),
              child: const Icon(Icons.notifications),
            ),
            tooltip: 'Notifications',
            onPressed: () => context.push('/notifications'),
          ),
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: 'All complaints',
            onPressed: () => context.push('/admin/complaints'),
          ),
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'Ride history',
            onPressed: () => context.push('/admin/rides'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () => context.push('/settings'),
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
      body: RefreshIndicator(
        onRefresh: () => ref.read(pendingDriversProvider.notifier).refresh(),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              'Hello, ${user?.fullName ?? 'Admin'}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            const Text(
              'Manage driver verification, complaints, and platform activity.',
            ),
            const SizedBox(height: 24),
            Text('Operations', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _AdminSummaryCard(
                    icon: Icons.person_search,
                    label: 'Pending drivers',
                    value: pendingAsync.maybeWhen(
                      data: (drivers) => '${drivers.length}',
                      orElse: () => '...',
                    ),
                    onTap: () =>
                        ref.read(pendingDriversProvider.notifier).refresh(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _AdminSummaryCard(
                    icon: Icons.report_problem,
                    label: 'Open complaints',
                    value: complaintsAsync.maybeWhen(
                      data: (items) =>
                          '${items.where((item) => item.status == 'open').length}',
                      orElse: () => '...',
                    ),
                    onTap: () => context.push('/admin/complaints'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            OutlinedButton.icon(
              onPressed: () => context.push('/admin/rides'),
              icon: const Icon(Icons.history),
              label: const Text('View all passenger and driver history'),
            ),
            const SizedBox(height: 20),
            Text(
              'Pending drivers',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            pendingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) =>
                  Text(e is AppException ? e.message : e.toString()),
              data: (drivers) {
                if (drivers.isEmpty) {
                  return const Text('No pending driver applications.');
                }
                return Column(
                  children: drivers
                      .map(
                        (d) => Card(
                          child: ListTile(
                            title: Text(d.fullName),
                            subtitle: Text('${d.phone} · ${d.vehiclePlate}'),
                            trailing: Wrap(
                              spacing: 4,
                              children: [
                                IconButton(
                                  icon: const Icon(
                                    Icons.close,
                                    color: Colors.red,
                                  ),
                                  tooltip: 'Reject',
                                  onPressed: () => ref
                                      .read(pendingDriversProvider.notifier)
                                      .review(d.profileId, 'rejected'),
                                ),
                                IconButton(
                                  icon: const Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  ),
                                  tooltip: 'Approve',
                                  onPressed: () => ref
                                      .read(pendingDriversProvider.notifier)
                                      .review(d.profileId, 'approved'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      )
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminSummaryCard extends StatelessWidget {
  const _AdminSummaryCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon),
              const SizedBox(height: 12),
              Text(value, style: Theme.of(context).textTheme.headlineSmall),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}
