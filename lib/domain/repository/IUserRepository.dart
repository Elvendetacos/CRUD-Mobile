import '../entity/User.dart';

abstract class IUserRepository {
  Future<List<User>> getUsers();
  Future<User> createUser(User user);
  Future<User> updateUser(int id, User user);
  Future<User> getUser(int id);
  Future<void> deleteUser(int id);
}