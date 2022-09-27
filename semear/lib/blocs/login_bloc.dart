import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/validators/login_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum LoginState { idle, loading, success, fail }

class LoginBloc extends BlocBase with LoginValidators {
  final _emailController = BehaviorSubject<String>();
  final _category = BehaviorSubject<Map<String, dynamic>>();
  final _passwordController = BehaviorSubject<String>();
  final _visibility = BehaviorSubject<bool>();
  final _stateController = BehaviorSubject<LoginState>();

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _category.close();
    super.dispose();
  }

  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);
  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get outVisibility =>
      _visibility.stream.transform(changeBoolValue);
  Stream<bool> get outSubmitedValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) {
        return true;
      });
  Map<String, dynamic>? get outCategory => _category.valueOrNull;

  Stream<LoginState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  Future<bool> submit() async {
    _stateController.add(LoginState.loading);

    bool allRight = await login();
    print("ALLRTIGHT: $allRight");
    if (allRight == true) {
      _stateController.add(LoginState.success);
      return true;
    } else {
      _stateController.add(LoginState.fail);
      _passwordController.add('');
      return false;
    }
  }

  Future<bool> login() async {
    print('${_emailController.valueOrNull}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    http.Response response = await http.post(
      Uri.parse("https://backend-semear.herokuapp.com/user/api/token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.valueOrNull,
        "password": _passwordController.valueOrNull
      }),
    );

    http.Response userData = await http.get(
      Uri.parse(
          "https://backend-semear.herokuapp.com/user/api/${_emailController.valueOrNull}/getUserData/"),
      headers: {"Content-Type": "application/json"},
    );

    print("DECODE ${jsonDecode(userData.body)["user"]["category"]}");
    _category.add(jsonDecode(userData.body)["user"]);
    print("OUTTTT CATEGORY: $outCategory");

    if (response.statusCode == 200) {
      print('ENTROU E O CODIGO DEU CERTO');
      sharedPreferences.setString('map', addMap(response.body));
      return true;
    } else {
      print('KKKKKK NAO ENTROu');
      print(jsonDecode(response.body));
      return false;
    }
  }

  String addMap(var response) {
    print("OUT CATEGORY: ${outCategory!['category']}");
    Map<String, dynamic> saveItems = {
      "email": _emailController.valueOrNull,
      "password": _passwordController.valueOrNull,
      "token": jsonDecode(response)['access'],
      "refresh": jsonDecode(response)['refresh'],
      "category": _category.valueOrNull
    };

    String encodedMap = json.encode(saveItems);
    print(encodedMap);
    return encodedMap;
  }
}
