import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PublicationBloc extends BlocBase {
  final _imageControlller = BehaviorSubject<File?>();
  final _legendController = BehaviorSubject<String>();
  final _checkedValue = BehaviorSubject<bool>();
  final _checkedImage = BehaviorSubject<bool>();
  final userBloc = BlocProvider.getBloc<UserBloc>();

  @override
  void dispose() {
    _imageControlller.close();
    _checkedValue.close();
    super.dispose();
  }

  final validateCaption = StreamTransformer<String, String>.fromHandlers(
      handleData: (caption, sink) {
    if (caption.isNotEmpty) {
      sink.add(caption);
    } else {
      sink.addError("Insira uma legenda para publicação válido");
    }
  });

  Stream<bool>? get outCheckedValue => _checkedValue.stream;
  Stream<bool>? get outCheckedImage => _checkedImage.stream;
  Stream<String> get outCaption =>
      _legendController.stream.transform(validateCaption);

  Function(String) get changeCaption => _legendController.sink.add;

  Stream<File?> get outImage => _imageControlller.stream;

  Sink get inChecked => _checkedValue.sink;
  Sink get inImage => _imageControlller.sink;
  Sink get inChekedImage => _checkedImage.sink;

  void changeImage(File? img) {
    _imageControlller.add(img);
  }

  Future<bool> submit(File imagem) async {
    if (kIsWeb) {
      print('kISWEB');
      //var image = await imagem.readAsBytes();
      Uint8List webImage = Uint8List(8);
    } else {
      print("ENTROU NO METODO SUBMIT");
      var request = http.MultipartRequest(
          'POST', Uri.parse("http://127.0.0.1:8000/publication/api"));

      print("USUARIO AQUI : ${userBloc.outUserValue.id}");
      request.fields['user'] = json.encode(userBloc.outUserValue.id);
      request.fields['legend'] = _legendController.valueOrNull ?? " ";
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
      print(res);
    }

    return false;
  }
}
