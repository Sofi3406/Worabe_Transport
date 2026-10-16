import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';
import 'package:worabe_transport/features/complaints/presentation/providers/complaint_providers.dart';

class ComplaintsScreen extends ConsumerWidget {
  const ComplaintsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final complaintsAsync = ref.watch(myComplaintsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(myComplaintsProvider.notifier).refresh(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => context.push('/complaints/new'),
        icon: const Icon(Icons.add),
        label: const Text('New'),
      ),
      body: complaintsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No complaints submitted yet.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _ComplaintTile(complaint: items[i]),
          );
        },
      ),
    );
  }
}

class _ComplaintTile extends StatelessWidget {
  const _ComplaintTile({required this.complaint});
  final ComplaintModel complaint;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(complaintCategories[complaint.category] ?? complaint.category),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(complaint.description, maxLines: 3, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 4),
            Text('Status: ${complaint.status}'),
            if (complaint.adminNote != null && complaint.adminNote!.isNotEmpty)
              Text('Admin note: ${complaint.adminNote}'),
          ],
        ),
        isThreeLine: true,
      ),
    );
  }
}
