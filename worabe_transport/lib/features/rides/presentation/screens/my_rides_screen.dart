import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/features/rides/domain/ride_model.dart';
import 'package:worabe_transport/features/rides/presentation/providers/ride_providers.dart';
import 'package:worabe_transport/shared/widgets/error_message.dart';

class MyRidesScreen extends ConsumerWidget {
  const MyRidesScreen({super.key, required this.forDriver});

  final bool forDriver;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(myRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(forDriver ? 'Ride Requests' : 'My Rides'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(myRidesProvider.notifier).refresh(),
          ),
        ],
      ),
      body: ridesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ErrorMessage(e is AppException ? e.message : e.toString()),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => ref.read(myRidesProvider.notifier).refresh(),
                  child: const Text('Retry'),
                ),
              ],
            ),
          ),
        ),
        data: (rides) {
          if (rides.isEmpty) {
            return const Center(child: Text('No rides yet.'));
          }
          return RefreshIndicator(
            onRefresh: () => ref.read(myRidesProvider.notifier).refresh(),
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: rides.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _RideCard(
                ride: rides[i],
                forDriver: forDriver,
                onRespond: (action) => ref
                    .read(myRidesProvider.notifier)
                    .respond(rides[i].id, action),
                onCancel: () =>
                    ref.read(myRidesProvider.notifier).cancel(rides[i].id),
                onComplete: () =>
                    ref.read(myRidesProvider.notifier).complete(rides[i].id),
                onComplaint: () => context.push(
                  '/complaints/new?rideId=${rides[i].id}',
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _RideCard extends StatelessWidget {
  const _RideCard({
    required this.ride,
    required this.forDriver,
    required this.onRespond,
    required this.onCancel,
    required this.onComplete,
    required this.onComplaint,
  });

  final RideModel ride;
  final bool forDriver;
  final Future<void> Function(String action) onRespond;
  final Future<void> Function() onCancel;
  final Future<void> Function() onComplete;
  final VoidCallback onComplaint;

  Color _statusColor(String status) {
    switch (status) {
      case 'accepted':
        return Colors.green;
      case 'pending':
        return Colors.orange;
      case 'completed':
        return Colors.blue;
      case 'cancelled':
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final counterpart = forDriver
        ? (ride.passengerName ?? 'Passenger')
        : (ride.driverName ?? 'Driver');

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    counterpart,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Chip(
                  label: Text(ride.status),
                  backgroundColor: _statusColor(ride.status).withValues(alpha: 0.15),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text('From: ${ride.pickupLabel}'),
            Text('To: ${ride.destinationLabel}'),
            const SizedBox(height: 12),
            if (forDriver && ride.isPending)
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => onRespond('reject'),
                      child: const Text('Reject'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => onRespond('accept'),
                      child: const Text('Accept'),
                    ),
                  ),
                ],
              ),
            if (!forDriver && ride.isPending)
              OutlinedButton(
                onPressed: onCancel,
                child: const Text('Cancel Request'),
              ),
            if (forDriver && ride.isAccepted)
              ElevatedButton(
                onPressed: onComplete,
                child: const Text('Mark Completed'),
              ),
            TextButton(
              onPressed: onComplaint,
              child: const Text('Report an issue'),
            ),
          ],
        ),
      ),
    );
  }
}
