import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  LocalDatabase._();
  static final LocalDatabase instance = LocalDatabase._();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _open();
    return _db!;
  }

  Future<Database> _open() async {
    final path = join(await getDatabasesPath(), 'worabe_transport.db');
    return openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE cached_drivers (
        id TEXT PRIMARY KEY,
        full_name TEXT NOT NULL,
        phone TEXT NOT NULL,
        vehicle_plate TEXT NOT NULL,
        service_areas_json TEXT NOT NULL,
        availability TEXT NOT NULL,
        updated_at TEXT NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE ride_drafts (
        id TEXT PRIMARY KEY,
        driver_id TEXT NOT NULL,
        driver_name TEXT NOT NULL,
        pickup_label TEXT NOT NULL,
        destination_label TEXT NOT NULL,
        created_at TEXT NOT NULL,
        sync_status TEXT NOT NULL
      )
    ''');
  }

  // ── Cached drivers ──────────────────────────────────────────────────────────

  Future<void> upsertDrivers(List<Map<String, dynamic>> drivers) async {
    final db = await database;
    final batch = db.batch();
    for (final d in drivers) {
      batch.insert('cached_drivers', d, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  Future<List<Map<String, dynamic>>> getCachedDrivers() async {
    final db = await database;
    return db.query('cached_drivers', orderBy: 'full_name ASC');
  }

  // ── Ride drafts ─────────────────────────────────────────────────────────────

  Future<void> insertDraft(Map<String, dynamic> draft) async {
    final db = await database;
    await db.insert('ride_drafts', draft, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Map<String, dynamic>>> getPendingDrafts() async {
    final db = await database;
    return db.query(
      'ride_drafts',
      where: 'sync_status IN (?, ?)',
      whereArgs: ['pending', 'submitting'],
      orderBy: 'created_at ASC',
    );
  }

  Future<void> updateDraftStatus(String id, String status) async {
    final db = await database;
    await db.update(
      'ride_drafts',
      {'sync_status': status},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> resetSubmittingDrafts() async {
    final db = await database;
    await db.update(
      'ride_drafts',
      {'sync_status': 'pending'},
      where: 'sync_status = ?',
      whereArgs: ['submitting'],
    );
  }

  Future<void> deleteDraft(String id) async {
    final db = await database;
    await db.delete('ride_drafts', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Map<String, dynamic>>> getAllDrafts() async {
    final db = await database;
    return db.query('ride_drafts', orderBy: 'created_at DESC');
  }
}
