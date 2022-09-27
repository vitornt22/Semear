// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/pages/timeline/Image_source_sheet.dart';
import 'package:semear/widgets/input_login_text.dart';
import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class PublicationPage extends StatelessWidget {
  Stream<Map<String, dynamic>> user;

  ApiForm apiForm = ApiForm();

  final _imageController = BehaviorSubject<File?>();
  File? imagem;
  final PublicationBloc _pubBloc;

  PublicationPage({super.key, required this.user})
      : _pubBloc = PublicationBloc(user: user);

  StreamController<String> legendController = StreamController<String>();

  @override
  void dispose() {
    _imageController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Publicar'),
        backgroundColor: Color(0xffa23673A),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 30),
              GestureDetector(
                onTap: () {
                  showModalBottomSheet(
                      context: context,
                      builder: (context) {
                        return ImageSourceSheet(
                          onImageSelected: (img) {
                            // _pubBloc.changeImage(img);
                            _pubBloc.inImage.add(img);
                            print(
                                "THIS IS VALUE IMAGE: ${_imageController.value}");
                          },
                        );
                      });
                },
                child: Container(
                  height: 300,
                  width: 300,
                  color: Color.fromRGBO(158, 158, 158, 1),
                  child: StreamBuilder<File?>(
                      stream: _pubBloc.outImage,
                      builder: (context, snapshot) {
                        print("SNAPSHOT.DATA ${snapshot.data}");
                        return Center(
                          child: snapshot.data == null
                              ? Icon(Icons.camera_enhance,
                                  size: 30, color: Colors.white)
                              : Image.network(
                                  snapshot.data!.path,
                                  fit: BoxFit.cover,
                                ),
                        );
                      }),
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Adicionar foto',
                textAlign: TextAlign.start,
              ),
              const SizedBox(
                height: 30,
              ),
              StreamBuilder<bool>(
                stream: _pubBloc.outCheckedValue,
                initialData: false,
                builder: (context, snapshot) => Column(
                  children: [
                    CheckboxListTile(
                      activeColor: Colors.green,
                      title: const Text(
                          "Marcar publicação  como prestação de contas"),
                      contentPadding: const EdgeInsets.all(2),
                      value: snapshot.data,
                      onChanged: (newValue) {
                        _pubBloc.inChecked.add(newValue);
                      },
                      controlAffinity: ListTileControlAffinity
                          .leading, //  <-- leading Checkbox
                    ),
                    SizedBox(height: 5),
                    Visibility(
                      visible: snapshot.data!,
                      child: TextDropdownFormField(
                        options: const ["Male", "Female"],
                        decoration: InputDecoration(
                            border: OutlineInputBorder(),
                            suffixIcon: Icon(Icons.arrow_drop_down),
                            labelText: "Gender"),
                        dropdownHeight: 120,
                      ),
                    ),
                  ],
                ),
              ),
              InputLoginField(
                maxLines: 20,
                text: '',
                hint: 'Legenda',
                stream: legendController.stream,
              ),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 60),
                    shape: const StadiumBorder(),
                    backgroundColor: Colors.green,
                  ),
                  onPressed: () {},
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        'Publicar',
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.w900),
                      ),
                      SizedBox(width: 5),
                      Icon(Icons.save)
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
