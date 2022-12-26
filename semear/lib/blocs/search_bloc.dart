import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class SearchBloc extends BlocBase {
  final topProjects = BehaviorSubject<List<dynamic>>();
  final topMissionaries = BehaviorSubject<List<dynamic>>();
  final projects = BehaviorSubject<List<dynamic>>();
  final missionaries = BehaviorSubject<List<dynamic>>();
  final donors = BehaviorSubject<List<dynamic>>();
  final churchs = BehaviorSubject<List<dynamic>>();
  final suggestions = BehaviorSubject<List<dynamic>>();
  final loading = BehaviorSubject<bool>.seeded(false);
  final query = BehaviorSubject<String?>.seeded('');

  Sink get inTopProjects => topProjects.sink;
  Sink get inTopMissionaries => topMissionaries.sink;
  Sink get inProjects => projects.sink;
  Sink get inMissionaries => missionaries.sink;
  Sink get inDonors => donors.sink;
  Sink get inChurchs => churchs.sink;
  Sink get inSuggestions => suggestions.sink;
  Sink get inLoading => loading.sink;
  Sink get inQuery => query.sink;

  Stream<List<dynamic>> get outTopProjects => topProjects.stream;
  Stream<List<dynamic>> get outTopMissionaries => topMissionaries.stream;
  Stream<List<dynamic>> get outProjects => projects.stream;
  Stream<List<dynamic>> get outChurchs => churchs.stream;
  Stream<List<dynamic>> get outMissionaries => missionaries.stream;
  Stream<List<dynamic>> get outDonors => donors.stream;
  Stream<List<dynamic>> get outSuggestions => suggestions.stream;
  Stream<bool> get outLoading => loading.stream;
  Stream<String?> get outQuery => query.stream;

  List<dynamic>? get outTopProjectsValue => topProjects.valueOrNull;
  List<dynamic>? get outTopMissionariesValue => topMissionaries.valueOrNull;
  List<dynamic>? get outProjectsValue => projects.valueOrNull;
  List<dynamic>? get outChurchsValue => churchs.valueOrNull;
  List<dynamic>? get outMissionariesValue => missionaries.valueOrNull;
  List<dynamic>? get outDonorsValue => donors.valueOrNull;
  List<dynamic>? get outSuggestionsValue => suggestions.valueOrNull;
  String? get outQueryValue => query.valueOrNull;

  bool? get outLoadingValue => loading.value;
}
