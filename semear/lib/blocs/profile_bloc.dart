import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class ProfileBloc extends BlocBase {
  Map<int, List<dynamic>> listPublications = {};

  final publicationsController = BehaviorSubject<Map<int, List<dynamic>>>();

  Stream<Map<int, List<dynamic>>> get outPublications =>
      publicationsController.stream;

  void addPublications(id, list) {
    listPublications[id] = list;
    publicationsController.add(listPublications);
  }
}
