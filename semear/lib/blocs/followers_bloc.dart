import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/models/follower_model.dart';

class FollowersBloc extends BlocBase {
  ApiSettings settings = ApiSettings();

  Map<int, List<dynamic>> listFollower = {};
  Map<int, List<dynamic>> listFollowing = {};
  Map<int, bool> listDisabledButton = {};
  Map<int, Map<int, bool>> listLabelButton = {};
  Map<int, int> listNumberFollowers = {};
  Map<int, int> listNumberFollowing = {};

  final followersController = BehaviorSubject<Map<int, List<dynamic>>>();
  final followingController = BehaviorSubject<Map<int, List<dynamic>>>();
  final searchController = BehaviorSubject<String>.seeded('');
  final labelController = BehaviorSubject<Map<int, Map<int, bool>>>();
  final loadingUnfollow = BehaviorSubject<bool>();
  final disableButton = BehaviorSubject<Map<int, bool>>.seeded({});
  final numberFollowersController = BehaviorSubject<Map<int, int>>();
  final numberFollowingController = BehaviorSubject<Map<int, int>>();

  Sink get inFollowers => followersController.sink;
  Sink get inFollowing => followingController.sink;
  Sink get inLoading => loadingUnfollow.sink;
  Sink get inSearch => searchController.sink;
  Sink get inDisabled => disableButton.sink;

  Stream<Map<int, List<dynamic>>> get outFollowers =>
      followersController.stream;
  Stream<Map<int, List<dynamic>>> get outFollowing =>
      followingController.stream;
  Stream<Map<int, Map<int, bool>>> get outLabel => labelController.stream;
  Stream<bool> get outLoading => loadingUnfollow.stream;
  Stream<String>? get outSearch => searchController.stream;
  Map<int, List<dynamic>>? get outlistTempory => listFollowing;
  Stream<Map<int, bool>>? get outDisabledButtons => disableButton.stream;
  Stream<Map<int, int>> get outNumberFollowers =>
      numberFollowersController.stream;
  Stream<Map<int, int>> get outNumberFollowing =>
      numberFollowingController.stream;

  Map<int, List<dynamic>>? get outFollowersValue =>
      followersController.valueOrNull;
  Map<int, List<dynamic>>? get outFollowingValue =>
      followersController.valueOrNull;
  Map<int, Map<int, bool>>? get outLabelValue => labelController.valueOrNull;
  String? get outSearchValue => searchController.valueOrNull;
  Map<int, List<dynamic>> get outListFollowingValue => listFollowing;
  Map<int, List<dynamic>> get outListFollowersValue => listFollower;
  Map<int, int>? get outnumberFollowersValue =>
      numberFollowersController.valueOrNull;
  Map<int, int>? get outNumberFollowingValue =>
      numberFollowingController.valueOrNull;
  Map<int, bool>? get outDisabledButtonsValue => disableButton.valueOrNull;

  void addDisable(id, value) {
    listDisabledButton[id] = value;
    disableButton.add(listDisabledButton);
  }

  void disableButtonReset() {
    listDisabledButton = {};
    disableButton.add(listDisabledButton);
  }

  void addFollowing(id, list) {
    if (list != null) {
      listFollowing[id] = list;
      listNumberFollowing[id] = list.length;
    } else {
      listFollowing[id] = [];
      listNumberFollowing[id] = 0;
    }
    followingController.add(listFollowing);
  }

  void addFollowers(id, list) {
    if (list != null) {
      listFollower[id] = list;
      listNumberFollowers[id] = list.length;
    } else {
      listFollower[id] = [];
      listNumberFollowers[id] = 0;
    }
    numberFollowersController.add(listNumberFollowers);
    followersController.add(listFollower);
  }

  void addSearchedFollowing(id, list) {
    final listTempory = listFollowing;
    if (searchController.value == '') {
      followingController.add(listFollowing);
      print("ENTRANDO valor vazio");
    } else {
      listTempory[id] = list;
      followingController.add(listTempory);
    }
  }

  void addSearchedFollowers(id, list) {
    final listTempory = listFollower;
    if (searchController.value == '') {
      followersController.add(listFollower);
      print("ENTRANDO valor vazio");
    } else {
      listTempory[id] = list;
      followersController.add(listTempory);
    }
  }

  void addLabelButton(id, following) {
    settings.getLabelFollower(id, following).then((value) {
      if (listLabelButton[id] == null) {
        listLabelButton[id] = {};
      }
      listLabelButton[id]![following] = value;
      labelController.add(listLabelButton);
    });
  }

  @override
  void dispose() {
    followersController.close();
    followingController.close();
    super.dispose();
  }
}
