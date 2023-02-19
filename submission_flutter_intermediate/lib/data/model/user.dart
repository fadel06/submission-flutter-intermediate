import 'dart:convert';

class User {
  User({
    required this.userId,
    required this.name,
    required this.token,
  });

  String? userId;
  String? name;
  String? token;

  // factory LoginResult.fromJson(Map<String, dynamic> json) => LoginResult(
  //       userId: json["userId"],
  //       name: json["name"],
  //       token: json["token"],
  //     );

  // Map<String, dynamic> toJson() => {
  //       "userId": userId ?? '',
  //       "name": name ?? '',
  //       "token": token ?? '',
  //     };

  // @override
  // String toString() => 'User(name: $name, userId: $userId, token: $token)';

  @override
  String toString() => 'User(userId: $userId, name:$name, token: $token)';

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'name': name,
      'token': token,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User(
      userId: map['userId'],
      name: map['name'],
      token: map['token'],
    );
  }

  String toJson() => json.encode(toMap());

  factory User.fromJson(String source) => User.fromMap(json.decode(source));
}
