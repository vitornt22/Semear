import 'dart:async';
import 'dart:convert';

import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/apis/api_publication.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:semear/models/comment_model.dart';
import 'package:semear/models/publication_model.dart';

class PublicationBloc extends BlocBase {
  Map<int, int> likesNumber = {};
  Map<int, int> commentsNumber = {};
  Map<int, String> labels = {};

  ApiPublication api = ApiPublication();

  final _imageControlller = BehaviorSubject<File?>();
  final comments = BehaviorSubject<List<dynamic>>();
  final disableButton = BehaviorSubject<bool>();
  final labelsController = BehaviorSubject<Map<int, String>>();
  final _legendController = BehaviorSubject<String>();
  final _snackBarText = BehaviorSubject<String>();
  final _checkedValue = BehaviorSubject<bool>();
  final _checkedImage = BehaviorSubject<bool>();
  final _loadingController = BehaviorSubject<bool>();
  final _publicationsController = BehaviorSubject<List<dynamic>>();
  final _commentsController = BehaviorSubject<List<Comment>>();

  final userBloc = BlocProvider.getBloc<UserBloc>();
  final _publication = BehaviorSubject<Publication>();
  final _likesPublication = BehaviorSubject<Map<int, int>>();
  final _commentsPublication = BehaviorSubject<Map<int, int>>();

  @override
  void dispose() {
    _imageControlller.close();
    _publication.close();
    _checkedValue.close();
    _imageControlller.close();
    _snackBarText.close();
    _checkedValue.close();
    _loadingController.close();
    _publicationsController.close();
    labelsController.close();
    _likesPublication.close();
    _commentsController.close();
    _commentsPublication.close();
    disableButton.close();
    comments.close();
    _publication.close();
    super.dispose();
  }

  Stream<List<dynamic>> get outPublications => _publicationsController.stream;

  List<dynamic> get outPublicationsValue => _publicationsController.value;
  Stream<Map<int, int>>? get outLikesPublication => _likesPublication.stream;
  Stream<Map<int, int>>? get outCommentsPublication =>
      _commentsPublication.stream;
  Map<int, int>? get outLikesPublicationValue => _likesPublication.value;
  Map<int, int>? get outCommentsPublicationValue =>
      _commentsPublication.valueOrNull;

  Stream<bool>? get outLoading => _loadingController.stream;
  Stream<bool>? get outCheckedValue => _checkedValue.stream;
  Stream<bool>? get outCheckedImage => _checkedImage.stream;
  Stream<bool>? get outDisabled => disableButton.stream;
  Stream<List<dynamic>>? get outComments => comments.stream;
  List<dynamic>? get outCommentsValue => comments.value;

  Stream<String> get outCaption =>
      _legendController.stream.transform(validateCaption);
  Stream<Map<int, String>> get outLabel => labelsController.stream;
  Stream<Publication> get outPublication => _publication.stream;
  Stream<String> get ouSnackBarText => _snackBarText.stream;
  Stream<File?> get outImage => _imageControlller.stream;

  Function(String) get changeCaption => _legendController.sink.add;

  Sink get inChecked => _checkedValue.sink;
  Sink get inPublications => _publicationsController.sink;
  Sink get inLabel => labelsController.sink;
  Sink get inPublication => _publication.sink;
  Sink get inDisabled => disableButton.sink;
  Sink get inComments => comments.sink;

  Sink get inImage => _imageControlller.sink;
  Sink get inChekedImage => _checkedImage.sink;
  Sink get inSnackBarText => _snackBarText.sink;

  void getCommentsPublication(publication) async {
    final c = await api.getComments(publication);
    comments.add(c);
  }

  void toggleNumberLikes(publication) {
    likesNumber[publication.id] = publication.likes!.length;

    _likesPublication.sink.add(likesNumber);
  }

  void toogleNumberComments(publication) {
    commentsNumber[publication.id] = publication.comments.length;
    _commentsPublication.sink.add(commentsNumber);
  }

  void toggleLabel(int id, String label) {
    labels[id] = label;
    labelsController.sink.add(labels);
  }

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
    print("PUBLICATION VALUE AQUI VTIROOOO: ${_publicationsController.value}");
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
      request.fields['user'] = null.toString();
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
