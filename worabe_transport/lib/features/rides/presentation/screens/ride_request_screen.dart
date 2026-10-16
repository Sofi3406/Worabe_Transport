import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:worabe_transport/core/errors/app_exception.dart';
import 'package:worabe_transport/shared/widgets/loading_button.dart';
import 'package:worabe_transport/shared/widgets/error_message.dart';
import 'package:worabe_transport/features/driver/domain/driver_model.dart';
import 'package:worabe_transport/features/rides/presentation/providers/ride_providers.dart';

class RideRequestScreen extends ConsumerStatefulWidget {
  const RideRequestScreen({super.key, required this.driver});
  final DriverModel driver;

  @override
  ConsumerState<RideRequestScreen> createState() => _RideRequestScreenState();
}

class _RideRequestScreenState extends ConsumerState<RideRequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final _pickupCtrl = TextEditingController();
  final _destCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _pickupCtrl.dispose();
    _destCtrl.dispose();
    super.dispose();
  }

  Future<bool> _isOnline() async {
    final result = await Connectivity().checkConnectivity();
    return result.any((r) => r != ConnectivityResult.none);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() {
      _loading = true;
      _error = null;
    });

    final online = await _isOnline();

    if (!online) {
      await ref.read(syncServiceProvider).saveDraft(
            driverId: widget.driver.id,
            driverName: widget.driver.fullName,
            pickupLabel: _pickupCtrl.text.trim(),
            destinationLabel: _destCtrl.text.trim(),
          );
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content:
                  Text('Saved as offline draft. Submit when connected.')),
        );
        context.pop();
      }
      return;
    }

    try {
      await ref.read(rideRepositoryProvider).createRide(
            driverId: widget.driver.id,
            pickupLabel: _pickupCtrl.text.trim(),
            destinationLabel: _destCtrl.text.trim(),
          );
      await ref.read(myRidesProvider.notifier).refresh();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Ride request sent!')),
        );
        context.go('/passenger/rides');
      }
    } on AppException catch (e) {
      setState(() => _error = e.message);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Request a Ride')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Card(
                child: ListTile(
                  leading: const Icon(Icons.directions_car),
                  title: Text(widget.driver.fullName),
                  subtitle: Text(widget.driver.vehiclePlate),
                ),
              ),
              const SizedBox(height: 24),
              if (_error != null) ...[
                ErrorMessage(_error!),
                const SizedBox(height: 16),
              ],
              TextFormField(
                controller: _pickupCtrl,
                decoration: const InputDecoration(
                  labelText: 'Pickup location',
                  prefixIcon: Icon(Icons.my_location),
                  hintText: 'e.g. Near Worabe bus station',
                ),
                maxLength: 200,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Pickup is required.'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _destCtrl,
                decoration: const InputDecoration(
                  labelText: 'Destination',
                  prefixIcon: Icon(Icons.location_on),
                  hintText: 'e.g. Worabe market',
                ),
                maxLength: 200,
                validator: (v) => v == null || v.trim().isEmpty
                    ? 'Destination is required.'
                    : null,
              ),
              const SizedBox(height: 24),
              LoadingButton(
                  label: 'Send Request',
                  loading: _loading,
                  onPressed: _submit),
            ],
          ),
        ),
      ),
    );
  }
}
