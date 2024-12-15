import 'dart:io';
import 'package:flutter/services.dart'; // Pour charger les fichiers depuis les assets
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class LocalDatabase {
  static final LocalDatabase _instance = LocalDatabase._internal();
  static Database? _database;

  factory LocalDatabase() {
    return _instance;
  }

  LocalDatabase._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    String databaseGeneralPath = await getDatabasesPath();
    String moviDatabasePath = join(databaseGeneralPath, 'movi.db');
    await deleteDatabase(moviDatabasePath);
    // Vérifiez si la base existe déjà
    bool exists = await databaseExists(moviDatabasePath);

    if (!exists) {
      print("Base de données inexistante, copie en cours depuis les assets...");
      await _copyDatabaseFromAssets(moviDatabasePath);
    } else {
      print("Ouverture de la base de données existante...");
    }

    return await openDatabase(moviDatabasePath);
  }

  Future<void> _copyDatabaseFromAssets(String destinationPath) async {
    try {
      // Charger le fichier de base de données depuis les assets
      ByteData data = await rootBundle.load('assets/databases/movi.db');
      List<int> bytes = data.buffer.asUint8List();

      // Créer le répertoire parent si nécessaire
      await Directory(dirname(destinationPath)).create(recursive: true);

      // Copier le fichier dans le dossier de destination
      await File(destinationPath).writeAsBytes(bytes, flush: true);

      print("Base de données copiée avec succès depuis les assets.");
    } catch (e) {
      print("Erreur lors de la copie de la base de données : $e");
      rethrow;
    }
  }

  Future<void> updateLastUpdated(String moviDatabasePath) async {
    try {
      final db = await openDatabase(moviDatabasePath);
      int newLastUpdated = DateTime.now().millisecondsSinceEpoch ~/ 1000;

      await db.update(
        'config',
        {'last_updated': newLastUpdated},
        where: 'id = ?',
        whereArgs: [1],
      );

      print("Date de mise à jour actualisée à : $newLastUpdated");
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
    }
  }

  Future<int> getLastUpdated(String moviDatabasePath) async {
    try {
      final db = await openDatabase(moviDatabasePath);

      List<Map<String, dynamic>> configResults = await db.query(
        'config',
        where: 'id = ?',
        whereArgs: [1],
      );

      Map<String, dynamic> configResult = {};

      if(configResults.isNotEmpty) {
        configResult = configResults.first;
      }

      print("Date de mise à jour récupérée : ${configResult['last_updated']}");
      return configResult['last_updated'];
    } catch (e) {
      print("Erreur lors de la mise à jour : $e");
      return -1;
    }
  }
}
