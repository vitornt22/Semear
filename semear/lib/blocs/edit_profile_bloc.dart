import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/src/streams/value_stream.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class EditProfileBloc extends BlocBase {
  final photoProfile = BehaviorSubject<File?>();
  final image1 = BehaviorSubject<File?>();
  final image2 = BehaviorSubject<File?>();
  final _errorImageController = BehaviorSubject<bool>.seeded(false);

  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Sink get inImage1 => image1.sink;
  Sink get inImage2 => image2.sink;
  Sink get inPhotoProfile => photoProfile.sink;

  Sink get inImageError => _errorImageController.sink;

  Stream<bool> get outLoadingController => _loadingController.stream;
  ValueStream<File?> get outImage1 => image1.stream;
  ValueStream<File?> get outImage2 => image2.stream;
  ValueStream<File?> get outPhotoProfile => photoProfile.stream;

  File? get outImage1Value => image1.valueOrNull;
  File? get outImage2Value => image2.valueOrNull;
  File? get outPhotoProfileValue => photoProfile.valueOrNull;
}
