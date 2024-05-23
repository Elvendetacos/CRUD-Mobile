import 'package:flutter/cupertino.dart';

import '../../domain/entity/User.dart';

class UserListNotifier extends ValueNotifier<List<User>> {
  UserListNotifier(List<User> users) : super(users);
}