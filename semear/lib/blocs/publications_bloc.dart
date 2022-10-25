import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_publication.dart';
import 'package:semear/models/publication_model.dart';

class PublicationsBloc extends BlocBase {
  ApiPublication api = ApiPublication();
  Map<int, int> likesNumber = {};
  Map<int, int> commentsNumber = {};
  Map<int, String> labels = {};
  List<dynamic> listPublication = [];
  Map<int, dynamic> commentMap = {};

  final comments = BehaviorSubject<Map<int, dynamic>>();
  final textSnackBar = BehaviorSubject<String>();
  final colorSnackBar = BehaviorSubject<Color>();

  final loadingComment = BehaviorSubject<bool>();
  final _likesPublication = BehaviorSubject<Map<int, int>>();
  final _commentsPublication = BehaviorSubject<Map<int, int>>();
  final _labelsController = BehaviorSubject<Map<int, String>>();

  final disableButton = BehaviorSubject<bool>();
  final _publicationsListController = BehaviorSubject<List<dynamic>>();

  Stream<Map<int, int>>? get outLikesPublication => _likesPublication.stream;
  Stream<Map<int, int>>? get outCommentsPublication =>
      _commentsPublication.stream;
  Stream<Map<int, String>> get outLabel => _labelsController.stream;

  Map<int, int>? get outLikesPublicationValue => _likesPublication.value;
  Map<int, int>? get outCommentsPublicationValue =>
      _commentsPublication.valueOrNull;

  final _publicationNumbersController =
      BehaviorSubject<Map<int, Map<String, dynamic>>>();

  PublicationsBloc() {
    listPublications();
  }

  @override
  void dispose() {
    _publicationsListController.close();
    _publicationNumbersController.close();
    _likesPublication.close();
    loadingComment.close();
    _commentsPublication.close();
    disableButton.close();
    comments.close();
    super.dispose();
  }

  Stream<List<dynamic>> get outPublications =>
      _publicationsListController.stream;

  Stream<String> get outTextSnacbar => textSnackBar.stream;
  Color get outColorSnackBar => colorSnackBar.value;

  List<dynamic>? get outPublicationsValue =>
      _publicationsListController.valueOrNull;

  Map<int, Map<String, dynamic>>? get ouPublicationNumberMapValue =>
      _publicationNumbersController.valueOrNull;

  Stream<Map<int, Map<String, dynamic>>>? get ouPublicationNumberMap =>
      _publicationNumbersController;
  Stream<bool>? get outLoadingSend => loadingComment.stream;
  Stream<bool>? get outDisabled => disableButton.stream;
  Stream<Map<int, dynamic>>? get outComments => comments.stream;
  Map<int, dynamic>? get outCommentsValue => comments.value;

  Sink get inPublications => _publicationsListController.sink;
  Sink get inDisabled => disableButton.sink;
  Sink get inComments => comments.sink;
  Sink get inTextSnackBar => textSnackBar.sink;
  Sink get inColorSnackBar => colorSnackBar.sink;

  Sink get inLoadingComment => loadingComment.sink;

  void changeListPublication(index, publication) {
    listPublication[index] = publication;
    _publicationsListController.add(listPublication);
  }

  void changeCommentsList(id, c) {
    commentMap[id] = c;
    comments.add(commentMap);
  }

  void getCommentsPublication(publication) async {
    final commentsList = await api.getComments(publication);
    comments.add(commentsList);
    print("CIMENTS ${comments.value}");
  }

  void toggleNumberLikes(publication) {
    likesNumber[publication.id] = publication.likes.length;
    _likesPublication.sink.add(likesNumber);
  }

  void toogleNumberComments(publication) {
    commentsNumber[publication.id] = publication.comments.length;
    _commentsPublication.sink.add(commentsNumber);
  }

  void toggleLabel(int id, String label) {
    labels[id] = label;
    _labelsController.sink.add(labels);
  }

  Future<void> listPublications() async {
    http.Response response = await http.get(
      Uri.parse("https://backend-semear.herokuapp.com/publication/api/"),
    );

    //print('JSON RESPONSE ${jsonDecode(response.body)['results'][0]}');
    print("ENTRANDO AQUi na ListPublications");
    listPublication = json.decode(response.body)["results"].map((map) {
      final a = Publication.fromJson(map);
      print('AAAA: ${a.id}');
      return a;
    }).toList();

    _publicationsListController.add(listPublication);
    print("TRHIS IS MY LIST: $listPublication");
  }
}
