import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semear/models/donation_model.dart';
import 'package:semear/models/follower_model.dart';
import 'package:semear/models/publication_model.dart';

class ApiProfile {
  Future<List<dynamic>?> getFollowing(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/follower/api/$id/getFollowing/"));

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => Follower.fromJson(value))
          .toList();
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }

  Future<List<dynamic>?> getFollowers(id) async {
    http.Response response = await http.get(Uri.parse(
        "https://backend-semear.herokuapp.com/follower/api/$id/getFollowers/"));

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => Follower.fromJson(value))
          .toList();
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }

  Future<List<dynamic>?> getPublications(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/publication/api/$id/getMyPublications/'));

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => Publication.fromJson(value))
          .toList();
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }

  Future<List<dynamic>?> getDonations(id, category) async {
    http.Response response;
    response = await http.get(
      Uri.parse(category == 'sender'
          ? 'https://backend-semear.herokuapp.com/transaction/api/$id/getSenderDonations/'
          : 'https://backend-semear.herokuapp.com/transaction/api/$id/getDonations/'),
    );

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => Donation.fromJson(value))
          .toList();
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }

  Future<List<dynamic>?> getTransactionValidations(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/transaction/api/$id/getTransactionValidations/'));

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => Donation.fromJson(value))
          .toList();
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }

  Future<bool> setValidation(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/transaction/api/$id/setValidation/'));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> recuseDonation(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/transaction/api/$id/recuseDonation/'));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> deleteDonations(id) async {
    //Procurar doações recusadas a mais de 5 dias e deletar...
    return true;
  }
}
