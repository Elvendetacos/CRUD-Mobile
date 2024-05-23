import 'package:flutter/material.dart';
import 'package:flutter_timer/Infraestructure/repository/UserRepositoryImpl.dart';
import 'package:flutter_timer/domain/entity/User.dart';
import 'package:provider/provider.dart';

class UserUpdateScreen extends StatefulWidget {
  final User user;

  UserUpdateScreen({required this.user});

  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  late UserRepositoryImpl userRepository;
  final _formKey = GlobalKey<FormState>();

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    userRepository = Provider.of<UserRepositoryImpl>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update User'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              decoration: InputDecoration(labelText: 'Name'),
              initialValue: widget.user.name,
              onSaved: (value) {
                widget.user.name = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Email'),
              initialValue: widget.user.email,
              onSaved: (value) {
                widget.user.email = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Age'),
              initialValue: widget.user.age.toString(),
              onSaved: (value) {
                widget.user.age = int.parse(value!);
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Phone'),
              initialValue: widget.user.phone,
              onSaved: (value) {
                widget.user.phone = value!;
              },
            ),
            TextFormField(
              decoration: InputDecoration(labelText: 'Password'),
              initialValue: widget.user.password,
              onSaved: (value) {
                widget.user.password = value!;
              },
            ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                  userRepository.updateUser(widget.user.id, widget.user);
                  Navigator.pop(context);
                  setState(() {});
                }
              },
              child: Text('Update User'),
            ),
          ],
        ),
      ),
    );
  }
}