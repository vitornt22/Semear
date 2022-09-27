import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class PublicationBloc extends BlocBase {
  PublicationBloc({this.user}) {}

  final user;
  final _imageControlller = BehaviorSubject<File?>();
  final _checkedValue = BehaviorSubject<bool>();

  @override
  void dispose() {
    _imageControlller.close();
    _checkedValue.close();
    super.dispose();
  }

  Stream<bool>? get outCheckedValue => _checkedValue.stream;
  Stream<File?> get outImage => _imageControlller.stream;

  Sink get inChecked => _checkedValue.sink;
  Sink get inImage => _imageControlller.sink;

  void changeImage(File? img) {
    _imageControlller.add(img);
  }
}
