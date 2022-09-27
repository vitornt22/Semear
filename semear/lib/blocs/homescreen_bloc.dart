import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';

class HomeScreenBloc extends BlocBase {
  final _userController = BehaviorSubject<Map<String, dynamic>>();

  @override
  void dispose() {
    _userController.close();
    super.dispose();
  }

  Stream<Map<String, dynamic>> get outUser => _userController.stream;
  Function(Map<String, dynamic>) get changeUser => _userController.sink.add;
}
