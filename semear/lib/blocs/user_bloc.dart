import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserBloc extends BlocBase {
  final _user = BehaviorSubject<User>();

  Stream<User> get outUser => _user.stream;
  User get outUserValue => _user.value;

  Sink get inUser => _user.sink;

  @override
  void dispose() {}

  Future<bool> verificarToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();

    //if there is data saved on SharedPreferences
    if (sharedPreferences.getString('map') != null) {
      String? encodedMap = sharedPreferences.getString('map');

      Map<String, dynamic> decodedMap = json.decode(encodedMap!);

      final userrr = User.fromJson(decodedMap['category']);
      _user.add(userrr);
      print("OBJECT USERRRRRR: ${_user.value}");
      print("CATEGORU MAP: ${decodedMap['category']}");

      print("PRINT 2: $decodedMap");

      http.Response tokenVerify = await http.post(
        Uri.parse(
            "https://backend-semear.herokuapp.com/user/api/token/verify/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"token": decodedMap['token']}),
      );

      // if token is expired
      if (tokenVerify.statusCode != 200) {
        print("TOKEN EXPIROU");
        http.Response refreshVerify = await http.post(
          Uri.parse(
              "https://backend-semear.herokuapp.com/user/api/token/verify/"),
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({"token": decodedMap['refresh']}),
        );

        if (refreshVerify.statusCode != 200) {
          print("REFRESH TOKEN EXPIROU");

          //sing in again, with email and password saved in sharedPreferences
          http.Response loginAgain = await http.post(
            Uri.parse("https://backend-semear.herokuapp.com/user/api/token/"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              "email": decodedMap["email"],
              "password": decodedMap["password"]
            }),
          );

          http.Response userData = await http.get(
            Uri.parse(
                "https://backend-semear.herokuapp.com/user/api/${decodedMap['email']}/getUserData/"),
            headers: {"Content-Type": "application/json"},
          );

          decodedMap['category'] = jsonDecode(userData.body)["user"];
          decodedMap["refresh"] = jsonDecode(loginAgain.body)["refresh"];
          decodedMap["access"] = jsonDecode(loginAgain.body)["access"];
        } else {
          print("REFRESH AINDA SERVE");

          // create a loginAgain= await http.post token, with refresh token  saved
          http.Response newToken = await http.post(
            Uri.parse(
                "https://backend-semear.herokuapp.com/user/api/token/refresh/"),
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({"refresh": decodedMap["refresh"]}),
          );
          decodedMap['token'] = jsonDecode(newToken.body)["access"];
        }
        sharedPreferences.setString('map', json.encode(decodedMap));
      } else {
        print("TOKKEN AINDA PRESTA");
      }
      return true;
    } else {
      return false;
    }
  }
}
