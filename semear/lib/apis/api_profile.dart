import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semear/models/church_model.dart';
import 'package:semear/models/donation_model.dart';
import 'package:semear/models/follower_model.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/models/saved_publication.dart';

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

  Future<List<dynamic>?> getSavedPublications(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/publication/api/$id/getMyPublicationsSaved/'));

    if (response.statusCode == 200) {
      print('ENRRANDO HERE');
      if (response.body == '{}') {
        return null;
      }
      final lista = json
          .decode(response.body)
          .map((value) => SavedPublication.fromJson(value))
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

  Future<List<dynamic>?> getProjectsHelped(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/transaction/api/$id/getSenderDonations/'));

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

  getDataChurch(id, category) async {
    late final link;
    switch (category) {
      case 'validations':
        link = 'getValidationsChurch/';
        break;
      case 'projects':
        link = 'getProjectsChurch/';
        break;
      case 'missionaries':
        link = 'getMissionariesChurch/';
        break;
      case 'information':
        link = '';
        break;
      default:
        break;
    }
    print(
        'THE LINK : https://backend-semear.herokuapp.com/church/api/$id/$link');
    http.Response response;
    response = await http.get(
        Uri.parse('https://backend-semear.herokuapp.com/church/api/$id/$link'));

    if (response.statusCode == 200) {
      print('ENRRANDO ssss');
      if (response.body.isEmpty) {
        return null;
      }
      final lista = category == 'information'
          ? Church.fromJson(jsonDecode(response.body))
          : json.decode(response.body).map((value) {
              print(value["user"]["category"]);
              if (value["user"]["category"] == 'project') {
                return Project.fromJson(value);
              }
              return Missionary.fromJson(value);
            }).toList();
      print(lista);
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

  Future<bool> deleteAccount(id) async {
    http.Response response;
    response = await http.delete(
        Uri.parse('https://backend-semear.herokuapp.com/user/api/$id/'));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool> setAccountValidation(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/church/api/$id/setActiveAccount/'));

    if (response.statusCode == 200) {
      return true;
    }
    return false;
  }

  Future<bool?> setRecommend(user1, user2) async {
    http.Response response;
    response = await http.post(
        Uri.parse('https://backend-semear.herokuapp.com/recommendation/api/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user1": user1, "user2": user2}));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<bool?> deleteRecommend(user1, user2) async {
    http.Response response;
    response = await http.delete(
        Uri.parse('https://backend-semear.herokuapp.com/recommendation/api/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"user1": user1, "user2": user2}));

    if (response.statusCode == 200) {
      return true;
    }

    return false;
  }

  Future<int?> getNumberRecommendation(id) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/recommendation/api/1/getNumberIndication/'));

    print(json.decode(response.body));

    return json.decode(response.body)['number'].toInt();
  }

  Future<bool?> checkRecommendation(pk1, pk2) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/recommendation/api/$pk1/checkRecommendation/$pk2/'));

    return json.decode(response.body)['check'];
  }
}
