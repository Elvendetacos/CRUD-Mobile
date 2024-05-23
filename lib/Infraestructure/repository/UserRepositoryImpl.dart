import 'dart:convert';

import 'package:flutter_timer/Infraestructure/service/apiService.dart';
import 'package:flutter_timer/domain/entity/User.dart';
import 'package:flutter_timer/domain/repository/IUserRepository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:connectivity/connectivity.dart';

import '../service/UserListNotifier.dart';

class UserRepositoryImpl implements IUserRepository {
  late final ApiService _apiService;
  Database? _database;

  UserRepositoryImpl(this._apiService) {
    initDatabase();
  }

Future<void> initDatabase() async {
  _database = await openDatabase(
    join(await getDatabasesPath(), 'my_database.db'),
    onCreate: (db, version) {
      db.execute(
        "CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, email TEXT, age INTEGER, phone TEXT, password TEXT)",
      );
    },
    onUpgrade: (db, oldVersion, newVersion) {
      if (newVersion > oldVersion) {
        db.execute(
          "CREATE TABLE IF NOT EXISTS pending_operations(id INTEGER PRIMARY KEY AUTOINCREMENT, type TEXT, userId INTEGER, data TEXT)",
        );
      }
    },
    version: 3,
  );
}

  @override
  Future<User> createUser(User user) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      user.id = await _database!.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      await _database!.insert(
        'pending_operations',
        {
          'type': 'create',
          'userId': user.id,
          'data': json.encode(user.toMap()),
        },
      );
      return user;
    } else {
      User newUser = await _apiService.createUser(user);
      newUser.id = await _database!.insert(
        'users',
        newUser.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return newUser;
    }
  }

  @override
  Future<void> deleteUser(int id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await _database!.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      await _database!.insert(
        'pending_operations',
        {
          'type': 'delete',
          'userId': id,
          'data': null,
        },
      );
    } else {
      await _apiService.deleteUser(id);
      await _database!.delete(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
    }
  }

  @override
  Future<User> getUser(int id) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      List<Map> users = await _database!.query(
        'users',
        where: 'id = ?',
        whereArgs: [id],
      );
      if (users.length > 0) {
        return User.fromJson(users.first as Map<String, dynamic>);
      } else {
        throw Exception('User not found');
      }
    } else {
      User user = await _apiService.getUser(id);
      await _database!.insert(
        'users',
        user.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      return user;
    }
  }

  @override
  Future<List<User>> getUsers() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      if (_database != null) {
        final List<Map<String, dynamic>> maps = await _database!.query('users');
        return List.generate(maps.length, (i) => User.fromJson(maps[i]));
      } else {
        throw Exception('Database is not initialized');
      }
    } else {
      List<User> users = await _apiService.getUsers();
      for (User user in users) {
        if (_database != null) {
          await _database!.insert(
            'users',
            user.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
        } else {
          throw Exception('Database is not initialized');
        }
      }
      return users;
    }
  }

  @override
  Future<User> updateUser(int id, User user) async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      await _database!.update(
        'users',
        user.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      await _database!.insert(
        'pending_operations',
        {
          'type': 'update',
          'userId': id,
          'data': json.encode(user.toMap()),
        },
      );
      return user;
    } else {
      User updatedUser = await _apiService.updateUser(id, user);
      await _database!.update(
        'users',
        updatedUser.toMap(),
        where: 'id = ?',
        whereArgs: [id],
      );
      return updatedUser;
    }
  }

Future<void> syncWithCloud() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult != ConnectivityResult.none) {
    if (_database == null) {
      await initDatabase();
    }
    if (_apiService == null) {
      // Inicializa _apiService si es null
      _apiService = ApiService(baseUrl: 'http://44.222.48.224');
    }
    final List<Map<String, dynamic>> pendingOperations = await _database!.query('pending_operations');
    for (var operation in pendingOperations) {
      try {
        if (operation['type'] == 'create') {
          User user = User.fromJson(json.decode(operation['data']));
          await _apiService!.createUser(user);
        } else if (operation['type'] == 'update') {
          User user = User.fromJson(json.decode(operation['data']));
          await _apiService!.updateUser(user.id, user);
        } else if (operation['type'] == 'delete') {
          await _apiService!.deleteUser(operation['id']);
        }
        await _database!.delete(
          'pending_operations',
          where: 'id = ?',
          whereArgs: [operation['id']],
        );
      } catch (e) {
        // Handle exceptions, for example log the error
      }
    }
  }
}
}