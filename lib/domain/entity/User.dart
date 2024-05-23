class User {
  int _id;
  String _name;
  String _email;
  int _age;
  String _phone;
  String _password;

  User({
    int id = 0,
    String name = '',
    String email = '',
    int age = 0,
    String phone = '',
    String password = '',
  })  : _id = id,
        _name = name,
        _email = email,
        _age = age,
        _phone = phone,
        _password = password;

  Map<String, dynamic> toMap() {
    return {
      'id': _id,
      'name': _name,
      'email': _email,
      'age': _age,
      'phone': _phone,
      'password': _password,
    };
  }

  // Método fromJson
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      age: json['age'],
      phone: json['phone'],
      password: json['password'],
    );
  }

  // Getters
  int get id => _id;
  String get name => _name;
  String get email => _email;
  int get age => _age;
  String get phone => _phone;
  String get password => _password;

  // Setters
  set id(int value) {
    _id = value;
  }

  set name(String value) {
    _name = value;
  }

  set email(String value) {
    _email = value;
  }

  set age(int value) {
    _age = value;
  }

  set phone(String value) {
    _phone = value;
  }

  set password(String value) {
    _password = value;
  }
}