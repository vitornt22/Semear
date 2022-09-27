import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semear/models/bank.dart';
import 'package:semear/models/city.dart';
import 'package:semear/models/uf.dart';

class ApiForm {
  getAllBanks() async {
    http.Response response = await http.get(
      Uri.parse("https://brasilapi.com.br/api/banks/v1"),
    );

    return jsonDecode(response.body);
  }

  Future<Map> getChurch(cnpj) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/church/api/$cnpj/getChurchAddress/"));

    return json.decode(response.body);
  }

  getCep(cep) async {
    cep = cep.replaceAll(RegExp(r'[^\w\s]+'), '');
    http.Response response =
        await http.get(Uri.parse("https://viacep.com.br/ws/$cep/json"));

    return json.decode(response.body);
  }

  Future<bool> checkEmail(email) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/user/api/$email/checkEmail/"));

    Map a = json.decode(response.body);
    return a['check'];
  }

  Future<bool> checkUsername(username) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/user/api/$username/checkUsername/"));

    Map a = json.decode(response.body);
    return a['check'];
  }

  Future<bool> checkCnpj(cnpj) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/church/api/$cnpj/checkCnpj/"));

    Map a = json.decode(response.body);
    return a['check'];
  }

  Future<List<City>> getCities(String? query, String? siglaUF) async {
    http.Response response = await http.get(
        Uri.parse("https://brasilapi.com.br/api/ibge/municipios/v1/$siglaUF"));
    final List cities = json.decode(response.body);
    return cities.map((json) => City.fromJson(json)).where((user) {
      final nameLower = user.name!.toLowerCase();
      final queryLower = query!.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();
  }

  Future<List<UF>> getUfs(String? query) async {
    http.Response response = await http.get(Uri.parse(
        "https://servicodados.ibge.gov.br/api/v1/localidades/estados?orderBy=nome"));

    final List ufs = json.decode(response.body);
    return ufs.map((json) => UF.fromJson(json)).where((user) {
      final nameLower = user.name!.toLowerCase();
      final queryLower = query!.toLowerCase();

      return nameLower.contains(queryLower);
    }).toList();
  }

  Future<List<Bank>> getBanks(String? query) async {
    http.Response response =
        await http.get(Uri.parse("https://brasilapi.com.br/api/banks/v1"));

    final List banks = json.decode(response.body);
    return banks.map((json) => Bank.fromJson(json)).toList();
  }

  Future<Map> verifyCnpj(String? cnpj) async {
    http.Response response =
        await http.get(Uri.parse("https://publica.cnpj.ws/cnpj/$cnpj"));

    return json.decode(response.body);
  }
}
