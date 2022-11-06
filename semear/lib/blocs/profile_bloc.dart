import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/subjects.dart';
import 'package:semear/apis/api_profile.dart';

class ProfileBloc extends BlocBase {
  ApiProfile api = ApiProfile();
  Map<int, List<dynamic>> listPublications = {};
  Map<int, bool> listLoading = {};
  Map<int, List<dynamic>> listValidations = {};
  Map<int, List<dynamic>> listDonations = {};
  Map<int, List<dynamic>> listSenderDonation = {};
  Map<int, List<dynamic>> listSavedPublication = {};

  final publicationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final validationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final donationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final loadingController = BehaviorSubject<Map<int, bool>>();
  final senderDonationsController = BehaviorSubject<Map<int, List<dynamic>>>();
  final savedPublicationsController =
      BehaviorSubject<Map<int, List<dynamic>>>();

  final gettingLoad = BehaviorSubject<bool>.seeded(false);

  //Streams
  Stream<Map<int, List<dynamic>>> get outPublications =>
      publicationsController.stream;
  Stream<Map<int, List<dynamic>>> get outSavedPublications =>
      savedPublicationsController.stream;
  Stream<Map<int, List<dynamic>>> get outValidations =>
      validationsController.stream;
  Stream<Map<int, List<dynamic>>> get outDonations =>
      donationsController.stream;
  Stream<Map<int, List<dynamic>>> get outSenderDonations =>
      senderDonationsController.stream;
  Stream<Map<int, bool>> get outLoading => loadingController.stream;
  Stream<bool> get outGettingLoad => gettingLoad.stream;

  //Values
  Map<int, List<dynamic>>? get outDonationsValue =>
      donationsController.valueOrNull;
  Map<int, List<dynamic>>? get outSavedPublicationValue =>
      savedPublicationsController.valueOrNull;
  Map<int, List<dynamic>>? get outSenderDonationsValue =>
      senderDonationsController.valueOrNull;
  Map<int, List<dynamic>>? get outValidationsValue =>
      validationsController.valueOrNull;
  Map<int, bool>? get outLoadingValue => loadingController.valueOrNull;
  bool? get outGettingLoadValue => gettingLoad.valueOrNull;

  Sink get inGettingLoading => gettingLoad.sink;

  void addPublicationSaved(id, list) {
    list = list ?? [];
    listSavedPublication[id] = list;
    savedPublicationsController.add(listSavedPublication);
  }

  void addPublications(id, list) {
    list = list ?? [];
    listPublications[id] = list;
    publicationsController.add(listPublications);
  }

  void addValidations(id, list) {
    list = list ?? [];
    listValidations[id] = list;
    validationsController.add(listValidations);
  }

  void addDonations(id, list) {
    list = list ?? [];
    listDonations[id] = list;
    donationsController.add(listDonations);
  }

  void addSenderDonations(id, list) {
    list = list ?? [];
    listSenderDonation[id] = list;
    senderDonationsController.add(listSenderDonation);
  }

  void addLoading(id, value) {
    listLoading[id] = value;
    loadingController.add(listLoading);
  }
}
