import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:worabe_transport/features/driver/presentation/providers/driver_providers.dart';
import 'package:worabe_transport/features/driver/domain/driver_model.dart';

class DriverDirectoryScreen extends ConsumerStatefulWidget {
  const DriverDirectoryScreen({super.key});

  @override
  ConsumerState<DriverDirectoryScreen> createState() =>
      _DriverDirectoryScreenState();
}

class _DriverDirectoryScreenState
    extends ConsumerState<DriverDirectoryScreen> {
  String? _filter;

  @override
  Widget build(BuildContext context) {
    final driversAsync = ref.watch(driverListProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Available Drivers'),
        actions: [
          PopupMenuButton<String?>(
            icon: const Icon(Icons.filter_list),
            onSelected: (v) {
              setState(() => _filter = v);
              ref.read(driverListProvider.notifier).refresh(availability: v);
            },
            itemBuilder: (_) => const [
              PopupMenuItem(value: null, child: Text('All')),
              PopupMenuItem(value: 'online', child: Text('Online only')),
              PopupMenuItem(value: 'offline', child: Text('Offline only')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => ref
                .read(driverListProvider.notifier)
                .refresh(availability: _filter),
          ),
        ],
      ),
      body: driversAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(e.toString()),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () => ref
                    .read(driverListProvider.notifier)
                    .refresh(availability: _filter),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (drivers) => drivers.isEmpty
            ? const Center(child: Text('No drivers found.'))
            : ListView.separated(
                padding: const EdgeInsets.all(16),
                itemCount: drivers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (_, i) => _DriverCard(
                  driver: drivers[i],
                  onRequest: () =>
                      context.push('/passenger/request', extra: drivers[i]),
                ),
              ),
      ),
    );
  }
}

class _DriverCard extends StatelessWidget {
  const _DriverCard({required this.driver, required this.onRequest});
  final DriverModel driver;
  final VoidCallback onRequest;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor:
              driver.isOnline ? Colors.green.shade100 : Colors.grey.shade200,
          child: Icon(Icons.directions_car,
              color: driver.isOnline ? Colors.green : Colors.grey),
        ),
        title: Text(driver.fullName),
        subtitle: Text('${driver.vehiclePlate} · ${driver.phone}'),
        trailing: driver.isOnline
            ? ElevatedButton(
                onPressed: onRequest, child: const Text('Request'))
            : Chip(
                label: const Text('Offline'),
                backgroundColor: Colors.grey.shade200,
              ),
      ),
    );
  }
}
