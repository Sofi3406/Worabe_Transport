import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:worabe_transport/features/admin/presentation/providers/admin_providers.dart';
import 'package:worabe_transport/features/rides/domain/ride_model.dart';

class AdminRideHistoryScreen extends ConsumerWidget {
  const AdminRideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = ref.watch(adminRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Passenger & Driver History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref.read(adminRidesProvider.notifier).refresh(),
          ),
        ],
      ),
      body: ridesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(error.toString())),
        data: (rides) => rides.isEmpty
            ? const Center(child: Text('No ride history found.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: rides.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (_, index) => _AdminRideCard(ride: rides[index]),
              ),
      ),
    );
  }
}

class _AdminRideCard extends StatelessWidget {
  const _AdminRideCard({required this.ride});

  final RideModel ride;

  @override
  Widget build(BuildContext context) {
    final date = DateFormat.yMMMd().add_jm().format(ride.createdAt.toLocal());
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    ride.status.toUpperCase(),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                Text(date, style: Theme.of(context).textTheme.bodySmall),
              ],
            ),
            const Divider(),
            _DetailLine(
              icon: Icons.person,
              label: 'Passenger',
              value: ride.passengerName ?? 'Unknown passenger',
            ),
            const SizedBox(height: 6),
            _DetailLine(
              icon: Icons.directions_car,
              label: 'Driver',
              value: ride.driverName ?? 'Unknown driver',
            ),
            const SizedBox(height: 6),
            _DetailLine(
              icon: Icons.trip_origin,
              label: 'From',
              value: ride.pickupLabel,
            ),
            const SizedBox(height: 6),
            _DetailLine(
              icon: Icons.location_on,
              label: 'To',
              value: ride.destinationLabel,
            ),
          ],
        ),
      ),
    );
  }
}

class _DetailLine extends StatelessWidget {
  const _DetailLine({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 18),
        const SizedBox(width: 8),
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Expanded(child: Text(value)),
      ],
    );
  }
}
