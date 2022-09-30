import 'dart:convert';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/register/project_register.dart';
import 'package:semear/validators/login_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum LoginState { idle, loading, success, fail }

class UserBloc extends BlocBase with LoginValidators {
  final _userController = BehaviorSubject<User>();
  final _emailController = BehaviorSubject<String>();
  final _categoryDataController = BehaviorSubject<Map<String, dynamic>>();
  final _passwordController = BehaviorSubject<String>();
  final _visibility = BehaviorSubject<bool>();
  final _stateController = BehaviorSubject<LoginState>();

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _categoryDataController.close();
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
  Map<String, dynamic>? get outCategory => _categoryDataController.valueOrNull;
  User get outUserValue => _userController.value;
  Stream<User> get outUser => _userController.stream;

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

  Future<Map<String, dynamic>> getCategoryData(method) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/$method/api/${_userController.value.id}/get${method}Data/"));
    return jsonDecode(response.body);
  }

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //if there is data saved on SharedPreferences
    if (sharedPreferences.getString('map') != null) {
      final decodedMap = json.decode(sharedPreferences.getString('map')!);

      // final userrr = User.fromJson(decodedMap['category']);
      // _user.add(userrr);
      print("OBJECT USERRRRRR: ${_userController.valueOrNull}");
      print("CATEGORU MAP: ${decodedMap['category']}");
      print("PRINT 2: $decodedMap");

      // 1- Verify if token is valid
      http.Response tokenVerify = await http.post(
        Uri.parse(
            "https://backend-semear.herokuapp.com/user/api/token/verify/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": decodedMap['token']}),
      );

      // if token valid
      if (tokenVerify.statusCode == 200) {
        return true;
      } else {
        // if token is invalid

        print("TOKEN EXPIROU");

        // Check if refresh token has expired
        http.Response refreshVerify = await http.post(
          Uri.parse(
              "https://backend-semear.herokuapp.com/user/api/token/verify/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token": decodedMap['refresh']}),
        );

        // if refresh token has  expired
        if (refreshVerify.statusCode != 200) {
          print("REFRESH TOKEN EXPIROU");
          _emailController.add(decodedMap['email']);
          _passwordController.add(decodedMap['password']);
          await login();
          //sing in again, with email and password saved in sharedPreferences
        } else {
          // If refresh token dont  been has expired
          print("REFRESH AINDA SERVE");

          http.Response newToken = await http.post(
            Uri.parse(
                "https://backend-semear.herokuapp.com/user/api/token/refresh/"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"refresh": decodedMap["refresh"]}),
          );
          decodedMap['token'] = jsonDecode(newToken.body)["access"];
        }
        sharedPreferences.setString('map', json.encode(decodedMap));
      }
      return true;
    } else {
      return false;
    }
  }

  Future<bool> login() async {
    print('${_emailController.valueOrNull}');
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    // Verify is email exists
    bool checkEmail = await apiForm.checkEmail(_emailController.valueOrNull);
    if (checkEmail == false) return false;

    // Singing up and obtain refresh and token field to Shared Preference
    http.Response response = await http.post(
      Uri.parse("https://backend-semear.herokuapp.com/user/api/token/"),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "email": _emailController.valueOrNull,
        "password": _passwordController.valueOrNull
      }),
    );

    // Take user data to save in shared preferences
    http.Response userData = await http.get(
      Uri.parse(
          "https://backend-semear.herokuapp.com/user/api/${_emailController.valueOrNull}/getUserData/"),
      headers: {"Content-Type": "application/json"},
    );

    print("DECODE ${jsonDecode(userData.body)["user"]["category"]}");
    final userMap = jsonDecode(userData.body)["user"];
    _userController.add(User.fromJson(userMap));

    print("OUTTTT CATEGORY: $outCategory");

    if (response.statusCode == 200) {
      print('ENTROU E O CODIGO DEU CERTO');
      final checkMap = await addMap(response.body);
      if (checkMap != null) {
        sharedPreferences.setString('map', checkMap);
        return true;
      }
      return false;
    } else {
      print('KKKKKK NAO ENTROu');
      print(jsonDecode(response.body));
      return false;
    }
  }

  Future<String?> addMap(var response) async {
    print("OUT CATEGORY: ${_userController.value.category}");

    _categoryDataController
        .add(await getCategoryData(_userController.value.category));

    Map<String, dynamic> saveItems = {
      "email": _emailController.valueOrNull,
      "password": _passwordController.valueOrNull,
      "token": jsonDecode(response)['access'],
      "refresh": jsonDecode(response)['refresh'],
      "user": _userController.valueOrNull,
      "categoryData": _categoryDataController.valueOrNull,
    };

    String encodedMap = json.encode(saveItems);
    print(encodedMap);
    return encodedMap;
  }
}
