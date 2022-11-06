import 'dart:io';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:http/http.dart' as http;

class EditProfileBloc extends BlocBase {
  final photoProfile = BehaviorSubject<String?>();
  final image1 = BehaviorSubject<String?>();
  final image2 = BehaviorSubject<String?>();
  final _errorImageController = BehaviorSubject<bool>.seeded(false);
  final statusController = BehaviorSubject<bool>.seeded(false);
  final checkEmail = BehaviorSubject<bool?>();
  final checkUsername = BehaviorSubject<bool?>();

  final _loadingController = BehaviorSubject<bool>.seeded(false);

  Sink get inImage1 => image1.sink;
  Sink get inStatus => statusController.sink;
  Sink get inImage2 => image2.sink;
  Sink get inPhotoProfile => photoProfile.sink;
  Sink get inLoading => _loadingController.sink;
  Sink get inCheckEmail => checkEmail.sink;
  Sink get inCheckUsername => checkUsername.sink;

  Sink get inImageError => _errorImageController.sink;

  Stream<bool> get outLoadingController => _loadingController.stream;
  Stream<bool> get outStatusController => statusController.stream;
  Stream<bool?> get outCheckEmail => checkEmail.stream;
  Stream<bool?> get outCheckUsername => checkUsername.stream;

  Stream<String?> get outImage1 => image1.stream;
  Stream<String?> get outImage2 => image2.stream;
  Stream<String?> get outPhotoProfile => photoProfile.stream;

  bool get outStatusControllerValue => statusController.value;
  bool get outLoadingControllerValue => _loadingController.value;
  bool? get outCheckEmailValue => checkEmail.valueOrNull;
  bool? get outCheckUsernameValue => checkUsername.valueOrNull;

  String? get outImage1Value => image1.valueOrNull;
  String? get outImage2Value => image2.valueOrNull;
  String? get outPhotoProfileValue => photoProfile.valueOrNull;
}
