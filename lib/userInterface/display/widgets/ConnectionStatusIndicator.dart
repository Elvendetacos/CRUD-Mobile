import 'package:flutter/material.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_timer/Infraestructure/repository/UserRepositoryImpl.dart';
import 'package:provider/provider.dart';

class ConnectionStatusIndicator extends StatelessWidget {
  final Stream<ConnectivityResult> _connectionStatusStream = Connectivity().onConnectivityChanged;

  @override
  Widget build(BuildContext context) {
    UserRepositoryImpl userRepository = Provider.of<UserRepositoryImpl>(context, listen: false);

    return StreamBuilder<ConnectivityResult>(
      stream: _connectionStatusStream,
      builder: (BuildContext context, AsyncSnapshot<ConnectivityResult> snapshot) {
        if (snapshot.hasData) {
          if (snapshot.data == ConnectivityResult.none) {
            return Row(
              children: [
                Icon(Icons.flash_off, color: Colors.red),
                Text('No connection', style: TextStyle(color: Colors.red)),
              ],
            );
          } else {// Llama a syncWithCloud cuando se restablece la conexión a Internet
            return Row(
              children: [
                Icon(Icons.flash_on, color: Colors.green),
                Text('Connected', style: TextStyle(color: Colors.green)),
              ],
            );
          }
        }
        return CircularProgressIndicator();  // Se muestra mientras se espera el primer evento del Stream
      },
    );
  }
}