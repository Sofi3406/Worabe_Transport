import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/features/auth/presentation/providers/auth_providers.dart';

class PassengerHomeScreen extends ConsumerWidget {
  const PassengerHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Worabe Transport'),
        actions: [
          IconButton(
            icon: const Icon(Icons.history),
            tooltip: 'My Rides',
            onPressed: () => context.push('/passenger/rides'),
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Settings',
            onPressed: () => context.push('/settings'),
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
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Hello, ${user?.fullName ?? ''}',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('Where would you like to go?',
                style: Theme.of(context).textTheme.bodyLarge),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              icon: const Icon(Icons.search),
              label: const Text('Find a Driver'),
              onPressed: () => context.push('/passenger/drivers'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              icon: const Icon(Icons.drafts),
              label: const Text('Offline Drafts'),
              onPressed: () => context.push('/passenger/drafts'),
            ),
          ],
        ),
      ),
    );
  }
}
