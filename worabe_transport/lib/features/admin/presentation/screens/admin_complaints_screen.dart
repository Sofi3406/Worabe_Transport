import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:worabe_transport/features/admin/presentation/providers/admin_providers.dart';
import 'package:worabe_transport/features/complaints/domain/complaint_model.dart';

class AdminComplaintsScreen extends ConsumerStatefulWidget {
  const AdminComplaintsScreen({super.key});

  @override
  ConsumerState<AdminComplaintsScreen> createState() =>
      _AdminComplaintsScreenState();
}

class _AdminComplaintsScreenState extends ConsumerState<AdminComplaintsScreen> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    final complaintsAsync = ref.watch(adminComplaintsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaint Review'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) {
              setState(() => _filter = v);
              ref.read(adminComplaintsProvider.notifier).refresh(status: v);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All')),
              PopupMenuItem(value: 'open', child: Text('Open')),
              PopupMenuItem(value: 'under_review', child: Text('Under review')),
              PopupMenuItem(value: 'resolved', child: Text('Resolved')),
              PopupMenuItem(value: 'dismissed', child: Text('Dismissed')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(adminComplaintsProvider.notifier)
                .refresh(status: _filter),
          ),
        ],
      ),
      body: complaintsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (items) {
          if (items.isEmpty) {
            return const Center(child: Text('No complaints found.'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 8),
            itemBuilder: (_, i) => _AdminComplaintCard(complaint: items[i]),
          );
        },
      ),
    );
  }
}

class _AdminComplaintCard extends ConsumerWidget {
  const _AdminComplaintCard({required this.complaint});
  final ComplaintModel complaint;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              complaintCategories[complaint.category] ?? complaint.category,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (complaint.reporterName != null)
              Text(
                'Reported by: ${complaint.reporterName}'
                '${complaint.reporterRole == null ? '' : ' (${complaint.reporterRole})'}'
                '${complaint.reporterPhone == null ? '' : ' · ${complaint.reporterPhone}'}',
              ),
            if (complaint.passengerName != null)
              Text('Passenger: ${complaint.passengerName}'),
            if (complaint.driverName != null)
              Text('Driver: ${complaint.driverName}'),
            if (complaint.pickupLabel != null)
              Text('From: ${complaint.pickupLabel}'),
            if (complaint.destinationLabel != null)
              Text('To: ${complaint.destinationLabel}'),
            if (complaint.rideStatus != null)
              Text('Ride status: ${complaint.rideStatus}'),
            const SizedBox(height: 8),
            Text(complaint.description),
            const SizedBox(height: 8),
            Text('Status: ${complaint.status}'),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              children: [
                OutlinedButton(
                  onPressed: () => ref
                      .read(adminComplaintsProvider.notifier)
                      .updateComplaint(
                        id: complaint.id,
                        status: 'under_review',
                      ),
                  child: const Text('Under review'),
                ),
                ElevatedButton(
                  onPressed: () => ref
                      .read(adminComplaintsProvider.notifier)
                      .updateComplaint(id: complaint.id, status: 'resolved'),
                  child: const Text('Resolve'),
                ),
                TextButton(
                  onPressed: () => ref
                      .read(adminComplaintsProvider.notifier)
                      .updateComplaint(id: complaint.id, status: 'dismissed'),
                  child: const Text('Dismiss'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
