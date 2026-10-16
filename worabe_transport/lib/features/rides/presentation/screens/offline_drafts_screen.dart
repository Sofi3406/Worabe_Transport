import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/features/rides/data/sync_service.dart';
import 'package:worabe_transport/features/rides/presentation/providers/ride_providers.dart';
final _draftsProvider = FutureProvider<List<DraftRide>>((ref) {
  return ref.watch(syncServiceProvider).getAllDrafts();
});

class OfflineDraftsScreen extends ConsumerWidget {
  const OfflineDraftsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final draftsAsync = ref.watch(_draftsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Drafts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.invalidate(_draftsProvider),
          ),
        ],
      ),
      body: draftsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (drafts) {
          if (drafts.isEmpty) {
            return const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: Text(
                  'No offline drafts. Drafts are saved when you request a ride without connectivity.',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: drafts.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _DraftCard(
              draft: drafts[i],
              onSubmit: () async {
                try {
                  await ref.read(syncServiceProvider).submitDraft(drafts[i]);
                  await ref.read(myRidesProvider.notifier).refresh();
                  ref.invalidate(_draftsProvider);
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Draft submitted.')),
                    );
                  }
                } on AppException catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.message)),
                    );
                  }
                }
              },
              onDelete: () async {
                await ref.read(syncServiceProvider).deleteDraft(drafts[i].id);
                ref.invalidate(_draftsProvider);
              },
            ),
          );
        },
      ),
    );
  }
}

class _DraftCard extends StatelessWidget {
  const _DraftCard({
    required this.draft,
    required this.onSubmit,
    required this.onDelete,
  });

  final DraftRide draft;
  final Future<void> Function() onSubmit;
  final Future<void> Function() onDelete;

  @override
  Widget build(BuildContext context) {
    final isPending = draft.syncStatus == 'pending';

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                const Icon(Icons.drafts, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    draft.driverName,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(label: Text(draft.syncStatus)),
              ],
            ),
            const SizedBox(height: 8),
            Text('From: ${draft.pickupLabel}'),
            Text('To: ${draft.destinationLabel}'),
            const SizedBox(height: 4),
            Text(
              'Local draft — not confirmed until you submit.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (isPending) ...[
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: onSubmit,
                child: const Text('Submit to Server'),
              ),
            ],
            TextButton(
              onPressed: onDelete,
              child: const Text('Delete draft'),
            ),
          ],
        ),
      ),
    );
  }
}
