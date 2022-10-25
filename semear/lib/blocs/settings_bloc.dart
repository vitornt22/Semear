import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';

class SettingBloc extends BlocBase {
  Map<int, bool> followerList = {};
  Map<int, bool> saveList = {};

  final followerController = BehaviorSubject<Map<int, bool>>();
  final saveController = BehaviorSubject<Map<int, bool>>();

  Sink get inFollowerController => followerController.sink;
  Sink get inSaveController => saveController.sink;

  Stream<Map<int, bool>> get outFollowerController => followerController.stream;
  Map<int, bool>? get outFollowerValue => followerController.valueOrNull;

  Stream<Map<int, bool>> get outSavedController => saveController.stream;
  Map<int, bool>? get outSavedValue => saveController.valueOrNull;

  @override
  void dispose() {
    followerController.close();
    saveController.close();
    super.dispose();
  }

  void changeFollower(id, value) {
    followerList[id] = value;
    followerController.add(followerList);
  }

  void changeSavedPublication(id, value) {
    saveList[id] = value;
    saveController.add(saveList);
  }
}
