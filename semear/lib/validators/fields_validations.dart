import 'dart:convert';

import 'package:email_validator/email_validator.dart';
import 'package:http/http.dart' as http;
import 'package:semear/pages/register/church_register.dart';

//API LAYER
const String keyApiEmail = "SQNRUTB7oWqfRRWZXlN0E3XEYzaJrUYI";
//ABSTRACT API
const String keyApiEmailAbstract = "08d732c66fa54fbd8fea0483328195ea";

getCep(String cep) async {
  http.Response response =
      await http.get(Uri.parse("https://brasilapi.com.br/api/cep/v2/$cep"));

  return json.decode(response.body);
}

class Validations {
  String? checkPassword(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Preencha.';
    } else if (fieldContent.length < 8) {
      return 'Senha deve conter 8 caracteres';
    } else if (fieldContent.indexOf(' ') > 0) {
      return 'Senha não deve conter espaços';
    }

    return null;
  }

  String? checkConfirmPassword(String confirma, String senha) {
    if (senha.length != confirma.length) {
      return "Nao corresponde a senha";
    }
    if (senha != confirma) {
      return "senhas diferentes";
    }

    return null;
  }

  String? checkUF(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Preencha.';
    }

    return null;
  }

  String? checkCep(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (fieldContent.length < 9) {
      return "Preencha o CEP completo";
    }

    return null;
  }

  String? checkCnpjValidation(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (fieldContent.length < 14) {
    } else if (fieldContent == '                 ') {
      return 'CNPJ Existente';
    }
    return null;
  }

  String? checkUsernameValidation(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (fieldContent.indexOf(' ') > 0) {
      return 'Senha não deve conter espaços';
    } else if (fieldContent.length > 15) {
      return 'Nome de usuário deve ser menor';
    } else if (fieldContent == '  Nome de usuário já existe') {
      return 'username já existe';
    }
    return null;
  }

  String? checkValueFloatValidation(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (double.parse(fieldContent) <= 0) {
      return 'Valor deve ser maior que zero';
    }
    return null;
  }

  String? checkChurchValidation(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (fieldContent.length < 14) {
      return 'CNPJ menor do que o esperado';
    } else if (fieldContent == '  Igreja não existe!') {
      return 'Igreja  não  existe';
    }
    return null;
  }

  String? checkEmpty(String? fieldContent) {
    if (fieldContent == null || fieldContent.isEmpty) {
      return 'Campo obrigatório.';
    }

    return null;
  }

  String? checkEmail(String? email) {
    if (email!.isEmpty) {
      return "Email não pode ser  vazio";
    } else if (EmailValidator.validate(email) == false &&
        email != 'email existente') {
      return "Email inválido";
    } else if (email == 'email existente') {
      return 'Email Existente';
    }

    return null;
  }

  String? checkContact(String? value) {
    if (value!.isEmpty) {
      return "Campo obrigatório";
    } else if (value.length < 14) {
      "Preencha o campo inteiro";
    }
    return null;
  }
}
