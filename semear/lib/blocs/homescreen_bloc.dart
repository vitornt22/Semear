import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/validators/login_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HomeScreenBloc extends BlocBase {
  final _userController = BehaviorSubject<Map<String, dynamic>>();

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }

  Stream<Map<String, dynamic>> get outUser => _userController.stream;
  Function(Map<String, dynamic>) get changeUser => _userController.sink.add;
}
