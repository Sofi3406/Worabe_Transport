import 'package:worabe_transport/core/storage/local_database.dart';
import 'package:worabe_transport/features/rides/data/ride_repository.dart';
import 'package:worabe_transport/features/rides/domain/ride_model.dart';

class DraftRide {
  const DraftRide({
    required this.id,
    required this.driverId,
    required this.driverName,
    required this.pickupLabel,
    required this.destinationLabel,
    required this.createdAt,
    required this.syncStatus,
  });

  final String id;
  final String driverId;
  final String driverName;
  final String pickupLabel;
  final String destinationLabel;
  final DateTime createdAt;
  final String syncStatus;

  factory DraftRide.fromMap(Map<String, dynamic> map) => DraftRide(
        id: map['id'] as String,
        driverId: map['driver_id'] as String,
        driverName: map['driver_name'] as String,
        pickupLabel: map['pickup_label'] as String,
        destinationLabel: map['destination_label'] as String,
        createdAt: DateTime.parse(map['created_at'] as String),
        syncStatus: map['sync_status'] as String,
      );
}

class SyncService {
  SyncService({required RideRepository rideRepository})
      : _repo = rideRepository;

  final RideRepository _repo;

  String _newId() =>
      DateTime.now().microsecondsSinceEpoch.toString();

  Future<void> saveDraft({
    required String driverId,
    required String driverName,
    required String pickupLabel,
    required String destinationLabel,
  }) async {
    await LocalDatabase.instance.insertDraft({
      'id': _newId(),
      'driver_id': driverId,
      'driver_name': driverName,
      'pickup_label': pickupLabel,
      'destination_label': destinationLabel,
      'created_at': DateTime.now().toIso8601String(),
      'sync_status': 'pending',
    });
  }

  Future<List<DraftRide>> getPendingDrafts() async {
    await LocalDatabase.instance.resetSubmittingDrafts();
    final maps = await LocalDatabase.instance.getPendingDrafts();
    return maps.map(DraftRide.fromMap).toList();
  }

  Future<List<DraftRide>> getAllDrafts() async {
    await LocalDatabase.instance.resetSubmittingDrafts();
    final maps = await LocalDatabase.instance.getAllDrafts();
    return maps.map(DraftRide.fromMap).toList();
  }

  Future<RideModel> submitDraft(DraftRide draft) async {
    await LocalDatabase.instance.updateDraftStatus(draft.id, 'submitting');
    try {
      final ride = await _repo.createRide(
        driverId: draft.driverId,
        pickupLabel: draft.pickupLabel,
        destinationLabel: draft.destinationLabel,
        idempotencyKey: draft.id,
      );
      await LocalDatabase.instance.deleteDraft(draft.id);
      return ride;
    } catch (e) {
      await LocalDatabase.instance.updateDraftStatus(draft.id, 'pending');
      rethrow;
    }
  }

  Future<void> deleteDraft(String id) =>
      LocalDatabase.instance.deleteDraft(id);
}
