import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class DonationBloc extends BlocBase {
  final anonymousCheckController = BehaviorSubject<bool>.seeded(false);
  final _imageControlller = BehaviorSubject<File?>();
  final _loadingController = BehaviorSubject<bool>.seeded(false);
  final _errorImageController = BehaviorSubject<bool>.seeded(false);

  Sink get inAnonymousController => anonymousCheckController.sink;
  Stream<bool> get outAnonymousController => anonymousCheckController.stream;
  bool get outAnonymousControllerValue => anonymousCheckController.value;
  Sink get inImage => _imageControlller.sink;
  Stream<File?> get outImage => _imageControlller.stream;
  File? get outImageValue => _imageControlller.valueOrNull;
  Stream<bool> get outLoadingController => _loadingController.stream;
  Stream<bool> get outErrorImage => _errorImageController.stream;
  Sink get inErrorImage => _errorImageController.sink;
  Sink get inLoadingController => _loadingController.sink;

  void reset() {
    _loadingController.add(false);
    anonymousCheckController.add(false);
    _imageControlller.add(null);
    _errorImageController.add(false);
  }

  Future<bool> submit(value, payment, user, donor) async {
    //var image = await imagem.readAsBytes();

    _loadingController.add(true);
    var imagem = _imageControlller.valueOrNull;
    print("IMAGEM : ${_imageControlller.valueOrNull!.path}");
    if (imagem != null) {
      print("ENTROU NO METODO SUBMIT");
      var request = http.MultipartRequest('POST',
          Uri.parse("https://backend-semear.herokuapp.com/transaction/api/"));

      request.fields['user'] = user.toString();
      request.fields['donor'] = donor.toString();
      request.fields['value'] = value.toString();
      request.fields['is_anonymous'] =
          anonymousCheckController.value.toString();
      request.fields['payment_form'] = payment.toString();
      request.fields['valid'] = false.toString();

      print("OLA");
      request.files.add(
        http.MultipartFile.fromBytes(
          'voucher',
          File(imagem.path).readAsBytesSync(),
          filename: "voucher",
        ),
      );
      var res = await request.send();
      print("STATUS CODE: ${res.statusCode}");
      if (res.statusCode == 200) {
        _loadingController.add(false);
        return true;
      } else {
        _loadingController.add(false);
        return false;
      }
    }
    _loadingController.add(false);
    return false;
  }
}
