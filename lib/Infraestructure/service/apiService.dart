import 'dart:convert';
import 'package:flutter_timer/domain/entity/User.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl;

  ApiService({required this.baseUrl});

  Future<List<User>> getUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/all'));
    print("response: ${response}");
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((item) => User.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }

  Future<User> createUser(User user) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to create user');
    }
  }

  Future<User> updateUser(int uuid, User user) async {
    final response = await http.put(
      Uri.parse('$baseUrl/users/update/$uuid'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(user.toMap()),
    );
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update user');
    }
  }

  Future<User> getUser(int uuid) async {
    final response = await http.get(Uri.parse('$baseUrl/users/$uuid'));
    if (response.statusCode == 200) {
      return User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  Future<void> deleteUser(int uuid) async {
    final response = await http.delete(Uri.parse('$baseUrl/users/delete/$uuid'));
    if (response.statusCode != 200) {
      throw Exception('Failed to delete user');
    }
  }
}