// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/timeline/Image_source_sheet.dart';
import 'package:semear/validators/publication_validation.dart';
import 'package:semear/widgets/input_login_text.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class PublicationPage extends StatelessWidget with PublicationValidator {
  ApiForm apiForm = ApiForm();
  final _formkey = GlobalKey<FormState>();

  final _imageController = BehaviorSubject<File?>();
  File? imagem;
  final PublicationBloc _pubBloc = PublicationBloc();

  @override
  void dispose() {
    _imageController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Publicar'),
        backgroundColor: Color(0xffa23673A),
      ),
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
            child: Form(
              key: _formkey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 30),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          context: context,
                          builder: (context) {
                            return SingleChildScrollView(
                              child: ImageSourceSheet(
                                onImageSelected: (img) {
                                  // _pubBloc.changeImage(img);
                                  _pubBloc.inImage.add(img);
                                  print(
                                      "THIS IS VALUE IMAGE: ${_imageController.value}");
                                },
                              ),
                            );
                          });
                    },
                    child: Container(
                      height: 250,
                      width: 250,
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
                  StreamBuilder<File?>(
                    stream: _pubBloc.outImage,
                    builder: (context, snapshot) => Text(
                      snapshot.data == null
                          ? 'Adicionar foto'
                          : 'Foto Adicionada!',
                      textAlign: TextAlign.start,
                    ),
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
                            validator: (value) {
                              if (value == null) {
                                return "Valor deve ser preenchido";
                              }
                            },
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
                  StreamBuilder<String>(
                    stream: _pubBloc.outCaption,
                    builder: (context, snapshot) => TextFormField(
                      obscureText: false,
                      onChanged: _pubBloc.changeCaption,
                      maxLines: 6,
                      minLines: 1,
                      decoration: InputDecoration(
                        hintText: 'Adicionar Legenda',
                        focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.green, width: 2),
                        ),
                        enabledBorder: const UnderlineInputBorder(
                          borderSide:
                              BorderSide(color: Color(0xffa23673a), width: 1),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: StreamBuilder<File?>(
                      stream: _pubBloc.outImage,
                      builder: (context, snapshot) => ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          minimumSize: Size(double.infinity, 60),
                          shape: const StadiumBorder(),
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () async {
                          if (_formkey.currentState!.validate()) {
                            await BlocProvider.getBloc<UserBloc>()
                                .verificarToken();
                            _pubBloc.submit(snapshot.data!);
                          }
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: const [
                            Text(
                              'Publicar',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w900),
                            ),
                            SizedBox(width: 5),
                            Icon(Icons.save)
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
