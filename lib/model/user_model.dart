import 'dart:convert';

class User {
  late String name;
  late String email;
  late String image;
  late String gender;
  late String birthDate;
  late List<dynamic> testsHistory;

  fromJson(String source) {
    final data = jsonDecode(source);
    name = data["data"]["name"];
    email = data["data"]["email"];
    image = data["data"]["image"];
    gender = data["data"]["gender"];
    birthDate = data["data"]["birthDate"];
    testsHistory = data["data"]["testsHistory"];
  }
}
