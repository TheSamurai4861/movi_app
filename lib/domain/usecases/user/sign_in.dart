import 'package:dartz/dartz.dart';
import 'package:movi_mobile/core/error/failures.dart';
import 'package:movi_mobile/domain/entities/user.dart';
import 'package:movi_mobile/domain/repositories/user_repository.dart';

class AddUser {
  final UserRepository repository;

  AddUser(this.repository);

  Future<Either<Failure,void>> call(User user) {
    return repository.addUser(user);
  }
}