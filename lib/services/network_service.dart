// import 'package:ascades/data/user.dart';
// import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

const baseUrl = "d695-136-158-44-81.ap.ngrok.io";

Uri requestFrom(String segment) {
  return Uri.https(baseUrl, "/api/app/$segment");
}

class NetworkService {
  static Future<Response?> getUser(String email) async {
    try {
      final url = requestFrom('get-user');
      final res = await http.post(url, body: {'email': email});
      return res;
    } catch (e) {
      return null;
    }
  }
}
