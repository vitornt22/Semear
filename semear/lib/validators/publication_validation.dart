import 'dart:io';

class PublicationValidator {
  String? validateImage(File image) {
    if (image == null) {
      return "Adicione uma imagem";
    }
    return null;
  }

  String? validateCaption(String? caption) {
    if (caption!.isEmpty) {
      return "Adicione uma legenda para publicação";
    }
    return null;
  }

  String? validateDonation(String? donation) {
    if (donation!.isEmpty) {
      return "Adicione uma doação para publicação";
    }
    return null;
  }
}
