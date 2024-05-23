import '../../domain/entity/User.dart';

abstract class IUseCase{
  List<User> getUsers();
  User createUser(User user);
  User updateUser(int uuid, User user);
  User getUser(int uuid);
  void deleteUser(int uuid);
}