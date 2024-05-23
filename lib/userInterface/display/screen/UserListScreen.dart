import 'package:flutter/material.dart';
import 'package:flutter_timer/Infraestructure/repository/UserRepositoryImpl.dart';
import 'package:flutter_timer/domain/entity/User.dart';
import 'package:provider/provider.dart';

import '../widgets/ConnectionStatusIndicator.dart';
import 'UpdateScreen.dart';
import 'UserCreateScreen.dart';

class UserListScreen extends StatefulWidget {
  @override
  _UserListScreenState createState() => _UserListScreenState();
}

class _UserListScreenState extends State<UserListScreen> {
  late UserRepositoryImpl userRepository;
  late Future<List<User>> _userListFuture;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRepository = Provider.of<UserRepositoryImpl>(context);
    _userListFuture = userRepository.getUsers();
  }

  void refreshUserList() {
    setState(() {
      _userListFuture = userRepository.getUsers();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Users'),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: refreshUserList,
          ),
          ConnectionStatusIndicator(),
        ],
      ),
      body: FutureBuilder<List<User>>(
        future: _userListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(snapshot.data![index].name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => UserUpdateScreen(user: snapshot.data![index])),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          userRepository.deleteUser(snapshot.data![index].id);
                          refreshUserList();
                        },
                      ),
                    ],
                  ),
                );
              },
            );
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => UserCreateScreen()),
          ).then((_) {
            refreshUserList();
          });
        },
      ),
    );
  }
}