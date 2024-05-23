import 'package:flutter_timer/domain/entity/User.dart';
import '../../application/useCase/IUseCase.dart';

class UserController {
  final IUseCase _useCase;

  UserController(this._useCase);

  Future<List<User>> getUsers() async {
    return await _useCase.getUsers();
  }

  Future<User> createUser(User user) async {
    return await _useCase.createUser(user);
  }

  Future<User> updateUser(int id, User user) async {
    return await _useCase.updateUser(id, user);
  }

  Future<User> getUser(int id) async {
    return await _useCase.getUser(id);
  }
}