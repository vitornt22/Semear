import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:semear/models/donation_model.dart';
import 'package:semear/models/numbers_card_model.dart';

class ApiTransaction {
  getAllTransaction(category) async {
    http.Response response;
    response = await http.get(Uri.parse(
        'https://backend-semear.herokuapp.com/transaction/api/$category/'));

    if (response.statusCode == 200) {
      print('ENRRANDO ssss');
      if (response.body.isEmpty) {
        return null;
      }
      final lista = category == 'getAllTransactions'
          ? json
              .decode(response.body)
              .map((value) => Donation.fromJson(value))
              .toList()
          : NumbersCard.fromJson(jsonDecode(response.body));

      print('LISTAAA $lista');
      return lista;
    }
    print('RETORNANDO NULL HERE');

    return null;
  }
}
