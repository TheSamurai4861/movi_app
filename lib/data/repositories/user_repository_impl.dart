import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/data/datasources/local/user_local_datasource.dart';
import 'package:movi_mobile/data/models/user_model.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/user_repository.dart';

class UserRepositoryImpl extends UserRepository {
  final UserLocalDataSource userLocalDataSource;

  UserRepositoryImpl({required this.userLocalDataSource});

  @override
  Future<Either<Failure, void>> addUser(User user) async {
    try {
      // Conversion de User (entity) en UserModel
      final userModel = UserModel.fromEntity(user);
      return await userLocalDataSource.addUser(userModel);
    } catch (e) {
      // Gestion des erreurs inattendues
      return Left(DatabaseFailure(message: 'Failed to add user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> deleteUser(User user) async {
    try {
      return await userLocalDataSource.deleteUser(user);
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to delete user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(int id) async {
    try {
      final result = await userLocalDataSource.getUser(id);
      return result.fold(
        (failure) => Left(failure),
        (userModel) => Right(userModel.toEntity()), // Conversion UserModel en User
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch user: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, List<User>>> getUsers() async {
    try {
      final result = await userLocalDataSource.getUsers();
      return result.fold(
        (failure) => Left(failure),
        (userModels) => Right(userModels.map((model) => model.toEntity()).toList()), // Conversion en liste d'entités User
      );
    } catch (e) {
      return Left(DatabaseFailure(message: 'Failed to fetch users: ${e.toString()}'));
    }
  }
}
