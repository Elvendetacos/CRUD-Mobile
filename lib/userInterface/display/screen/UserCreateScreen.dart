import 'package:flutter/material.dart';
import 'package:flutter_timer/Infraestructure/repository/UserRepositoryImpl.dart';
import 'package:flutter_timer/domain/entity/User.dart';
import 'package:provider/provider.dart';

class UserCreateScreen extends StatefulWidget {
  @override
  _UserCreateScreenState createState() => _UserCreateScreenState();
}

class _UserCreateScreenState extends State<UserCreateScreen> {
  late UserRepositoryImpl userRepository;
  final _formKey = GlobalKey<FormState>();
  final _user = User();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRepository = Provider.of<UserRepositoryImpl>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create User'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              onSaved: (value) {
                _user.name = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              onSaved: (value) {
                _user.email = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              onSaved: (value) {
                _user.age = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone'),
              onSaved: (value) {
                _user.phone = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              onSaved: (value) {
                _user.password = value!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  _user.id = 0;
                  userRepository.createUser(_user);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: Text('Create User'),
            ),
          ],
        ),
      ),
    );
  }
}