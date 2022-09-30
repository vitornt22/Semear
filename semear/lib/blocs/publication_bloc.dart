import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:semear/models/publication_model.dart';

class PublicationBloc extends BlocBase {
  final _imageControlller = BehaviorSubject<File?>();
  final _legendController = BehaviorSubject<String>();
  final _snackBarText = BehaviorSubject<String>();
  final _checkedValue = BehaviorSubject<bool>();
  final _checkedImage = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();
  final _publicationsController = BehaviorSubject<List<Publication>>();

  final userBloc = BlocProvider.getBloc<UserBloc>();

  PublicationBloc() {
    print("Constructor PUB: ");
    listPublications();
  }

  @override
  void dispose() {
    _imageControlller.close();
    _checkedValue.close();
    _imageControlller.close();
    _snackBarText.close();
    _checkedValue.close();
    _loadingController.close();
    _publicationsController.close();
    super.dispose();
  }

  Stream<List<Publication>> get outPublications =>
      _publicationsController.stream;
  Stream<bool>? get outLoading => _loadingController.stream;
  Stream<bool>? get outCheckedValue => _checkedValue.stream;
  Stream<bool>? get outCheckedImage => _checkedImage.stream;
  Stream<String> get outCaption =>
      _legendController.stream.transform(validateCaption);
  Stream<String> get ouSnackBarText => _snackBarText.stream;
  Stream<File?> get outImage => _imageControlller.stream;

  Function(String) get changeCaption => _legendController.sink.add;

  Sink get inChecked => _checkedValue.sink;
  Sink get inPublications => _publicationsController.sink;

  Sink get inImage => _imageControlller.sink;
  Sink get inChekedImage => _checkedImage.sink;
  Sink get inSnackBarText => _snackBarText.sink;

  void changeImage(File? img) {
    _imageControlller.add(img);
  }

  final validateCaption = StreamTransformer<String, String>.fromHandlers(
      handleData: (caption, sink) {
    if (caption.isNotEmpty) {
      sink.add(caption);
    } else {
      sink.addError("Insira uma legenda para publicação válido");
    }
  });

  listPublications() async {
    http.Response response = await http.get(
        Uri.parse("https://backend-semear.herokuapp.com/publication/api/"));

    print('JSON RESPONSE ${jsonDecode(response.body)['results'][1]}');

    final lista = await json.decode(response.body)["results"].map((map) {
      final a = Publication.fromJson(map);
      print('AAAA: ${a.id}');
      return a;
    }).toList();

    _publicationsController.add(lista);
  }

  Future<bool> submit() async {
    //var image = await imagem.readAsBytes();
    _loadingController.add(true);
    var imagem = _imageControlller.value;
    if (imagem != null) {
      print("ENTROU NO METODO SUBMIT");
      var request = http.MultipartRequest('POST',
          Uri.parse("https://backend-semear.herokuapp.com/publication/api/"));

      print("USUARIO AQUI : ${userBloc.outUserValue.id}");
      request.fields['id_user'] = userBloc.outUserValue.id.toString();
      request.fields['legend'] = _legendController.valueOrNull ?? " ";
      request.fields['project'] = null.toString();
      request.fields['likes'] = [].toString();
      request.fields['comments'] = [].toString();

      print("OLA");
      request.fields['is_accountability'] = false.toString();
      request.files.add(
        http.MultipartFile.fromBytes(
          'upload',
          File(imagem.path).readAsBytesSync(),
          filename: "ola",
        ),
      );
      var res = await request.send();
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
