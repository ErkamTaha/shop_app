import 'dart:convert';
import '../models/http_exception.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Auth with ChangeNotifier {
  String _token;
  DateTime _expiryDate;
  String _userId;

  Future<void> _authenticate(
      String email, String password, String urlSegment) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:$urlSegment?key=AIzaSyAXdPf8kEXndHrD3WDLxCT5ZDP8ZBgWlhU');
    try {
      final response = await http.post(
        url,
        body: jsonEncode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      final responseData = jsonDecode(response.body);
      if(responseData['error']!=null){
        throw HttpException(responseData['error']['message']);
      }
    } catch (error) {
      throw error;
    }
  }

  Future<void> signUp(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signUp');
  }

  Future<void> logIn(
    String email,
    String password,
  ) async {
    return _authenticate(email, password, 'signInWithPassword');
  }
}
