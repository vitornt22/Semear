import 'dart:convert';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/models/church_model.dart';
import 'package:semear/models/donor_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/register/project_register.dart';
import 'package:semear/validators/login_validator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

enum LoginState { idle, loading, success, fail }

class UserBloc extends BlocBase with LoginValidators {
  Map<int, User> listUsers = {};
  Map<int, dynamic?> listCategoryData = {};
  ApiSettings apiSettings = ApiSettings();

  final _userController = BehaviorSubject<Map<int, User>>();
  final _myId = BehaviorSubject<int>();
  final _emailController = BehaviorSubject<String>();
  final _categoryDataController = BehaviorSubject<Map<int, dynamic?>>();
  final _passwordController = BehaviorSubject<String>();
  final _tokenController = BehaviorSubject<String>();
  final _visibility = BehaviorSubject<bool>();
  final _stateController = BehaviorSubject<LoginState>();

  @override
  void dispose() {
    _emailController.close();
    _passwordController.close();
    _stateController.close();
    _categoryDataController.close();
    _userController.close();
    super.dispose();
  }

  Sink get inMyId => _myId.sink;
  Stream<String> get outEmail =>
      _emailController.stream.transform(validateEmail);

  Stream<int> get outMyId => _myId.stream;
  Stream<Map<int, dynamic>> get outCategory => _categoryDataController.stream;

  Stream<String> get outPassword =>
      _passwordController.stream.transform(validatePassword);
  Stream<bool> get outVisibility =>
      _visibility.stream.transform(changeBoolValue);
  Stream<bool> get outSubmitedValid =>
      Rx.combineLatest2(outEmail, outPassword, (a, b) {
        return true;
      });
  Map<int, dynamic>? get outCategoryValue =>
      _categoryDataController.valueOrNull;
  Map<int, User>? get outUserValue => _userController.valueOrNull;
  Stream<Map<int, User?>> get outUser => _userController.stream;
  String? get outToken => _tokenController.valueOrNull;
  int? get outMyIdValue => _myId.valueOrNull;

  Stream<LoginState> get outState => _stateController.stream;

  Function(String) get changeEmail => _emailController.sink.add;
  Function(String) get changePassword => _passwordController.sink.add;

  addUser(user) {
    listUsers[user.id] = user;
    _userController.add(listUsers);
  }

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
        "https://backend-semear.herokuapp.com/$method/api/${_myId.value}/get${method}Data/"));
    print("GET CATEGORYYYY: ${jsonDecode(response.body)}");
    return jsonDecode(response.body);
  }

  void updatePasswordOrEmail(field, value) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final decodedMap = json.decode(sharedPreferences.getString('map')!);
    decodedMap[field] = value;
    sharedPreferences.setString('map', json.encode(decodedMap));
  }

  void updateUser(user) async {
    print("UPDATE USER $user");
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    final decodedMap = json.decode(sharedPreferences.getString('map')!);
    decodedMap['user'] = user;
    sharedPreferences.setString('map', json.encode(decodedMap));
    addUser(user);
  }

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    //sharedPreferences.clear();
    if (sharedPreferences.getString('map') != null) {
      final decodedMap = json.decode(sharedPreferences.getString('map')!);
      final user = User.fromJson(decodedMap['user']);
      _myId.add(user.id!);
      final value = await apiSettings.getUser(user.id);
      addUser(value);

      _tokenController.add(decodedMap['token']);
      //print("EIIII AQUI O VALOR: ${listUsers[_myId.value]!.information!.id!}");

      final c = await getCategory(_myId.value);
      addCategory(_myId.value, c);
      print("ADD ${listUsers[_myId.value]}");
      print("dynamic USERRRRRR: ${_userController.valueOrNull}");
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
      final api = ApiSettings();
      await api.getUser(_myId.value).then((value) {
        updateUser(value);
      });
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
    final user = User.fromJson(userMap);
    final value = await apiSettings.getUser(user.id);
    _myId.add(user.id!);
    addUser(value);
    // print("EIIII AQUI O VALOR: ${_userController.value.information!.resume}");

    // print("OUTTTT CATEGORY: $outCategoryValue");

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

  Future<String?> addMap(response) async {
    print("CATEGORYYYY");
    //print("OUT CATEGORY: ${listUsers[_myId.value]!.category}");

    final value = await getCategory(_myId.value);
    addCategory(_myId.value, value);
    print(value);
    print("OPS");
    // _tokenController.add(jsonDecode(response)['token']);

    Map<String, dynamic> saveItems = {
      "email": _emailController.valueOrNull,
      "password": _passwordController.valueOrNull,
      "token": jsonDecode(response)['access'],
      "refresh": jsonDecode(response)['refresh'],
      "user": _userController.valueOrNull![_myId.value],
      "categoryData": _categoryDataController.value[_myId.value]
    };

    String encodedMap = json.encode(saveItems);
    print(encodedMap);
    return encodedMap;
  }

  addCategory(id, data) {
    listCategoryData[id] = data;
    _categoryDataController.add(listCategoryData);
  }

  Future<dynamic> getCategory(id) async {
    final value =
        await getCategoryData(_userController.value[_myId.value]!.category);
    final category = _userController.value[_myId.value]!.category;
    print("PSIU CATEGORU: $category");
    switch (category) {
      case 'project':
        return Project.fromJson(value);
      case 'missionary':
        return Missionary.fromJson(value);
      case 'donor':
        return Donor.fromJson(value);
      case 'church':
        return Church.fromJson(value);
      default:
        return null;
    }
  }
}
