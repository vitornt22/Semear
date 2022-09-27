import 'dart:async';

import 'package:flutter/cupertino.dart';

class LoginValidators {
  final validateEmail =
      StreamTransformer<String, String>.fromHandlers(handleData: (email, sink) {
    if (email.contains("@")) {
      sink.add(email);
    } else {
      sink.addError("Insira um email válido");
    }
  });

  final validatePassword = StreamTransformer<String, String>.fromHandlers(
      handleData: (password, sink) {
    if (password.length > 4 && password.length < 15) {
      sink.add(password);
    } else {
      sink.addError('Senha deve ter no minimo 4 e no máximo 15 caracterese ');
    }
  });

  final changeBoolValue = StreamTransformer<bool, bool>.fromHandlers(
      handleData: (visibility, sink) {
    if (visibility == true) {
      sink.add(false);
    } else {
      sink.add(true);
    }
  });
}
