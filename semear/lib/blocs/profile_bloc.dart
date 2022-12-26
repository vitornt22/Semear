import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/models/project_model.dart';

class ProfileBloc extends BlocBase {
  ApiProfile api = ApiProfile();
  Map<int, List<dynamic>> listPublications = {};
  Map<int, bool> listLoading = {};
  Map<int, List<dynamic>> listValidations = {};
  Map<int, List<dynamic>> listDonations = {};
  Map<int, List<dynamic>> listSenderDonation = {};
  Map<int, List<dynamic>> listSavedPublication = {};
  Map<int, List<dynamic>> listProjectsHelped = {};
  Map<int, List<dynamic>> listProjectsChurch = {};
  Map<int, List<dynamic>> listMissionariesChurch = {};
  Map<int, List<dynamic>> listValidationsChurch = {};
  Map<int, bool> listLoadingAccount = {};
  Map<int, bool> listRecommendation = {};
  Map<int, bool> loadingRecommendation = {};

  Map<int, int> listNumberRecomendation = {};

  final publicationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final projectHelpedController = BehaviorSubject<Map<int, List<dynamic>>>();
  final validationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final donationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final loadingController = BehaviorSubject<Map<int, bool>>();
  final loadingAccountController = BehaviorSubject<Map<int, bool>>();
  final senderDonationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final projectsChurchController = BehaviorSubject<Map<int, List<dynamic>>>();
  final recommendation = BehaviorSubject<Map<int, bool>>();
  final numberRecommendations = BehaviorSubject<Map<int, int>>();
  final loadingRecommendationController = BehaviorSubject<Map<int, bool>>();

  final validationsChurchController =
      BehaviorSubject<Map<int, List<dynamic>>>();
  final projectCreated = BehaviorSubject<Project?>.seeded(null);

  final missionariesChurchController =
      BehaviorSubject<Map<int, List<dynamic>>>();

  final savedPublicationsController =
      BehaviorSubject<Map<int, List<dynamic>>>();

  final gettingLoad = BehaviorSubject<bool>.seeded(false);

  //Streams
  Stream<Project?> get outProjectCreated => projectCreated.stream;
  Stream<Map<int, List<dynamic>>> get outPublications =>
      publicationsController.stream;
  Stream<Map<int, List<dynamic>>> get outProjectsHelped =>
      publicationsController.stream;
  Stream<Map<int, List<dynamic>>> get outSavedPublications =>
      savedPublicationsController.stream;
  Stream<Map<int, List<dynamic>>> get outValidations =>
      validationsController.stream;
  Stream<Map<int, List<dynamic>>> get outDonations =>
      donationsController.stream;
  Stream<Map<int, List<dynamic>>> get outSenderDonations =>
      senderDonationsController.stream;
  Stream<Map<int, List<dynamic>>> get outProjectsChurch =>
      projectsChurchController.stream;
  Stream<Map<int, List<dynamic>>> get outMissionariesChurch =>
      missionariesChurchController.stream;
  Stream<Map<int, List<dynamic>>> get outValidationsChurch =>
      validationsChurchController.stream;
  Stream<Map<int, bool>> get outLoading => loadingController.stream;
  Stream<Map<int, bool>> get outRecommndation => recommendation.stream;
  Stream<Map<int, bool>> get outLoadingRecommendation =>
      loadingRecommendationController.stream;

  Stream<Map<int, int>> get outNumberRecommendations =>
      numberRecommendations.stream;

  Stream<Map<int, bool>> get outLoadingAccount =>
      loadingAccountController.stream;

  Stream<bool> get outGettingLoad => gettingLoad.stream;

  //Values
  Project? get outProjectCreatedValue => projectCreated.valueOrNull;
  Map<int, bool>? get outRecommndationValue => recommendation.valueOrNull;
  Map<int, int>? get outNumberRecommendationValue =>
      numberRecommendations.valueOrNull;
  Map<int, int>? get outNumberRecommendationsValue =>
      numberRecommendations.valueOrNull;

  Map<int, List<dynamic>>? get outValidationsChurchValue =>
      validationsChurchController.valueOrNull;
  Map<int, List<dynamic>>? get outDonationsValue =>
      donationsController.valueOrNull;
  Map<int, List<dynamic>>? get outProjectsChurchValue =>
      projectsChurchController.valueOrNull;
  Map<int, List<dynamic>>? get outMissionariesChurchValue =>
      missionariesChurchController.valueOrNull;
  Map<int, List<dynamic>> get outProjectsHelpedValue =>
      projectHelpedController.value;
  Map<int, List<dynamic>>? get outSavedPublicationValue =>
      savedPublicationsController.valueOrNull;
  Map<int, List<dynamic>>? get outSenderDonationsValue =>
      senderDonationsController.valueOrNull;
  Map<int, List<dynamic>>? get outValidationsValue =>
      validationsController.valueOrNull;
  Map<int, bool>? get outLoadingValue => loadingController.valueOrNull;
  Map<int, bool>? get outLoadingAccountValue =>
      loadingAccountController.valueOrNull;
  Map<int, bool>? get outLoadingRecommendationValue =>
      loadingRecommendationController.valueOrNull;

  bool? get outGettingLoadValue => gettingLoad.valueOrNull;

  Sink get inGettingLoading => gettingLoad.sink;
  Sink get inProjectCreated => projectCreated.sink;

  void addPublicationSaved(id, list) {
    list = list ?? [];
    if (listSavedPublication[id] != list) {
      listSavedPublication[id] = list;
      savedPublicationsController.add(listSavedPublication);
    }
  }

  void addPublications(id, list) {
    list = list ?? [];
    if (listPublications[id] != list) {
      listPublications[id] = list;
      publicationsController.add(listPublications);
    }
  }

  void addValidations(id, list) {
    list = list ?? [];
    if (listValidations[id] != list) {
      listValidations[id] = list;
      validationsController.add(listValidations);
    }
  }

  void addDonations(id, list) {
    list = list ?? [];
    if (listDonations != list) {
      listDonations[id] = list;
      donationsController.add(listDonations);
    }
  }

  void addSenderDonations(id, list) {
    list = list ?? [];
    if (listSenderDonation[id] != list) {
      listSenderDonation[id] = list;
      senderDonationsController.add(listSenderDonation);
    }
  }

  void addProjectsChurch(id, list) {
    list = list ?? [];
    if (listProjectsChurch[id] != list) {
      listProjectsChurch[id] = list;
      projectsChurchController.add(listProjectsChurch);
    }
  }

  void addMissionariesChurch(id, list) {
    list = list ?? [];
    if (listMissionariesChurch[id] != list) {
      listMissionariesChurch[id] = list;
      missionariesChurchController.add(listMissionariesChurch);
    }
  }

  void addValidationsChurch(id, list) {
    list = list ?? [];
    if (listValidationsChurch[id] != list) {
      listValidationsChurch[id] = list;
      validationsChurchController.add(listValidationsChurch);
    }
  }

  void addLoading(id, value) {
    value = value ?? [];
    if (listLoading != value) {
      listLoading[id] = value;
      loadingController.add(listLoading);
    }
  }

  void addLoadingAccount(id, value) {
    value = value ?? [];
    if (listLoadingAccount != value) {
      listLoadingAccount[id] = value;
      loadingAccountController.add(listLoadingAccount);
    }
  }

  void addRecommendation(id, value) {
    if (listRecommendation[id] != value) {
      listRecommendation[id] = value;
      recommendation.add(listRecommendation);
    }
  }

  void addNumberRecommendations(id, value) {
    if (listNumberRecomendation[id] != value) {
      listNumberRecomendation[id] = value;
      numberRecommendations.add(listNumberRecomendation);
    }
  }

  void addLoadingRecommendation(id, value) {
    if (loadingRecommendation[id] != value) {
      loadingRecommendation[id] = value;
      loadingRecommendationController.add(loadingRecommendation);
    }
  }
}
