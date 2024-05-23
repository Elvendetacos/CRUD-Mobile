import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timer/Infraestructure/repository/UserRepositoryImpl.dart';
import 'package:flutter_timer/Infraestructure/service/apiService.dart';
import 'package:flutter_timer/userInterface/display/screen/UserListScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final userRepository = UserRepositoryImpl(ApiService(baseUrl: 'http://44.222.48.224'));

    return Provider(
      create: (context) => userRepository,
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: FutureBuilder(
          future: userRepository.initDatabase().then((_) => userRepository.syncWithCloud()),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return UserListScreen();
            } else {
              return CircularProgressIndicator();
            }
          },
        ),
      ),
    );
  }
}