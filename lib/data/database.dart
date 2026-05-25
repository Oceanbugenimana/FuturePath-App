import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'models.dart';

class FuturePathDatabase {
  static final FuturePathDatabase instance = FuturePathDatabase._internal();
  FuturePathDatabase._internal();

  Database? _db;

  Future<Database> get database async {
    _db ??= await _initDb();
    return _db!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'futurepath.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: _onCreate,
      onUpgrade: (db, oldVersion, newVersion) async {
        await db.execute('DROP TABLE IF EXISTS user_profiles');
        await db.execute('DROP TABLE IF EXISTS chat_messages');
        await db.execute('DROP TABLE IF EXISTS simulations');
        await _onCreate(db, newVersion);
      },
    );
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE user_profiles (
        id TEXT PRIMARY KEY,
        age INTEGER,
        country TEXT,
        interests TEXT,
        skills TEXT,
        grades TEXT,
        budget TEXT,
        internetAccess TEXT,
        preferredLifestyle TEXT,
        strengths TEXT,
        weaknesses TEXT,
        learningHabits TEXT,
        timeCommitment TEXT,
        isPremium INTEGER,
        favoriteTheme TEXT,
        xp INTEGER,
        level INTEGER,
        streak INTEGER,
        futureScore INTEGER,
        lastUpdate INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE chat_messages (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        sender TEXT,
        text TEXT,
        timestamp INTEGER
      )
    ''');

    await db.execute('''
      CREATE TABLE simulations (
        id TEXT PRIMARY KEY,
        profileId TEXT,
        optimisticTitle TEXT,
        optimisticBrief TEXT,
        optimisticSalary TEXT,
        optimisticDetails TEXT,
        realisticTitle TEXT,
        realisticBrief TEXT,
        realisticSalary TEXT,
        realisticDetails TEXT,
        riskTitle TEXT,
        riskBrief TEXT,
        riskSalary TEXT,
        riskDetails TEXT,
        salariesOptimistic TEXT,
        salariesRealistic TEXT,
        salariesRisk TEXT,
        skillGaps TEXT,
        skillRoadmap TEXT
      )
    ''');
  }

  // ---- UserProfile ----

  Future<UserProfile?> getUserProfile() async {
    final db = await database;
    final rows = await db.query('user_profiles',
        where: 'id = ?', whereArgs: ['current_user'], limit: 1);
    if (rows.isEmpty) return null;
    return UserProfile.fromMap(rows.first);
  }

  Future<void> saveUserProfile(UserProfile profile) async {
    final db = await database;
    await db.insert('user_profiles', profile.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // ---- ChatMessages ----

  Future<List<ChatMessage>> getChatMessages() async {
    final db = await database;
    final rows = await db.query('chat_messages', orderBy: 'timestamp ASC');
    return rows.map(ChatMessage.fromMap).toList();
  }

  Future<void> insertChatMessage(ChatMessage msg) async {
    final db = await database;
    await db.insert('chat_messages', msg.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<void> clearChat() async {
    final db = await database;
    await db.delete('chat_messages');
  }

  // ---- Simulation ----

  Future<CareerSimulation?> getSimulation() async {
    final db = await database;
    final rows = await db.query('simulations',
        where: 'id = ?', whereArgs: ['current_simulation'], limit: 1);
    if (rows.isEmpty) return null;
    return CareerSimulation.fromMap(rows.first);
  }

  Future<void> saveSimulation(CareerSimulation sim) async {
    final db = await database;
    await db.insert('simulations', sim.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }
}
