import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/constants/dp_paths/movi_db_paths.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/datasources/local/local_database.dart';
import 'package:movi_mobile/data/models/user_model.dart';
import 'package:movi_mobile/domain/entities/user.dart';

abstract class UserLocalDataSource {
  Future<Either<Failure, List<UserModel>>> getUsers();
  Future<Either<Failure, UserModel>> getUser(int id);
  Future<Either<Failure, void>> addUser(UserModel user);
  Future<Either<Failure, void>> deleteUser(User user);
}

class UserLocalDataSourceImpl implements UserLocalDataSource {
  final LocalDatabase db;

  UserLocalDataSourceImpl(this.db);

  // Méthode utilitaire pour exécuter une opération et capturer les erreurs
  Future<Either<Failure, T>> _safeExecute<T>(Future<T> Function() operation, String errorMessage) async {
    try {
      return Right(await operation());
    } catch (e) {
      return Left(DatabaseFailure(message: '$errorMessage: $e'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(User user) async {
    return _safeExecute(
      () async {
        final database = await db.database;
        await database.delete(MoviDbPaths.userTable, where: 'id = ?', whereArgs: [user.id]);
      },
      'Failed to delete user',
    );
  }

  @override
  Future<Either<Failure, List<UserModel>>> getUsers() async {
    return _safeExecute(
      () async {
        final database = await db.database;
        final usersMap = await database.query(MoviDbPaths.userTable);
        return usersMap.map((userMap) => UserModel.fromJson(userMap)).toList();
      },
      'Failed to fetch users',
    );
  }

  @override
  Future<Either<Failure, void>> addUser(UserModel user) async {
    return _safeExecute(
      () async {
        final database = await db.database;
        await database.insert(MoviDbPaths.userTable, user.toJson());
      },
      'Failed to add new user',
    );
  }

  @override
  Future<Either<Failure, UserModel>> getUser(int id) async {
    return _safeExecute(
      () async {
        final database = await db.database;
        final userMap = await database.query(MoviDbPaths.userTable, where: 'id = ?', whereArgs: [id]);

        if (userMap.isNotEmpty) {
          return UserModel.fromJson(userMap.first);
        } else {
          throw Exception('No user found with id $id');
        }
      },
      'Failed to fetch user with id $id',
    );
  }
}
