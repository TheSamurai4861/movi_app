import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/user.dart';

abstract class UserRepository {
  Future<Either<Failure, List<User>>> getUsers();
  Future<Either<Failure,User>> getUser(int id);
  Future<Either<Failure,void>> addUser(User user);
  Future<Either<Failure,void>> deleteUser(User user);
}
