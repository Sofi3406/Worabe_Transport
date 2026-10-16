import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/features/admin/presentation/providers/admin_providers.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';

class AdminHomeScreen extends ConsumerWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pendingAsync = ref.watch(pendingDriversProvider);
    final user = ref.watch(authUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.report),
            tooltip: 'All complaints',
            onPressed: () => context.push('/admin/complaints'),
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
            Text('Hello, ${user?.fullName ?? 'Admin'}',
                style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 8),
            const Text('Review driver applications awaiting verification.'),
            const SizedBox(height: 24),
            Text('Pending drivers',
                style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            pendingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Text(
                e is AppException ? e.message : e.toString(),
              ),
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
                                  icon: const Icon(Icons.close, color: Colors.red),
                                  tooltip: 'Reject',
                                  onPressed: () => ref
                                      .read(pendingDriversProvider.notifier)
                                      .review(d.profileId, 'rejected'),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.check, color: Colors.green),
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
