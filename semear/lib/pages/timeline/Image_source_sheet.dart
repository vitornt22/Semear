import 'dart:io';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

class ImageSourceSheet extends StatelessWidget {
  final Function(File)? onImageSelected;

  const ImageSourceSheet({super.key, this.onImageSelected});

  void imageSelected(File image, BuildContext context) async {
    if (image != null) {
      CroppedFile? croppedImage = (await ImageCropper().cropImage(
        sourcePath: image.path,
        aspectRatio: const CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
        uiSettings: [
          /// this settings is required for Web
          WebUiSettings(
            context: context,
            presentStyle: CropperPresentStyle.dialog,
            boundary: const CroppieBoundary(
              width: 400,
              height: 400,
            ),
            viewPort: const CroppieViewPort(
              width: 400,
              height: 400,
              type: 'rectangle',
            ),
            enableExif: true,
            enableZoom: true,
            showZoomer: true,
          )
        ],
      ));

      File? newImage = File(croppedImage!.path);

      Navigator.of(context).pop();
      onImageSelected!(newImage);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BottomSheet(
      onClosing: () {},
      builder: (context) => Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              XFile? image =
                  (await ImagePicker().pickImage(source: ImageSource.camera));
              imageSelected(File(image!.path), context);
            },
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Câmera',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.camera_enhance)
                ],
              ),
            ),
          ),
          TextButton(
            onPressed: () async {
              XFile? image =
                  (await ImagePicker().pickImage(source: ImageSource.gallery));
              imageSelected(File(image!.path), context);
            },
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    'Galeria',
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(width: 10),
                  Icon(Icons.photo_album)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
