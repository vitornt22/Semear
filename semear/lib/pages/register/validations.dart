import 'package:email_validator/email_validator.dart';

//API LAYER
const String keyApiEmail = "SQNRUTB7oWqfRRWZXlN0E3XEYzaJrUYI";
//ABSTRACT API
const String keyApiEmailAbstract = "08d732c66fa54fbd8fea0483328195ea";

class Validations {
  String? checkCnpjValidation(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    } else if (fieldContent.length < 14) {
      return "Preencha o CNPJ completo";
    }
    return null;
  }

  String? checkEmpty(String? fieldContent) {
    if (fieldContent!.isEmpty) {
      return 'Campo obrigatório.';
    }
    if (fieldContent.length < 3) {
      return 'Poucos Caracteres';
    }
    return null;
  }

  String? checkEmail(String? email) {
    if (email!.isEmpty) {
      return "Email não pode ser  vazio";
    } else if (EmailValidator.validate(email) == false) {
      return "Email inválido";
    }

    return null;
  }
}
