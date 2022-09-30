// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/publication_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/timeline/Image_source_sheet.dart';
import 'package:semear/validators/publication_validation.dart';
import 'package:semear/widgets/input_login_text.dart';

import 'package:dropdown_plus/dropdown_plus.dart';
import 'package:image_cropper/image_cropper.dart';

class PublicationPage extends StatelessWidget with PublicationValidator {
  ApiForm apiForm = ApiForm();
  final _formkey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  final _imageController = BehaviorSubject<File?>();
  File? imagem;
  final PublicationBloc _pubBloc = BlocProvider.getBloc<PublicationBloc>();

  @override
  void dispose() {
    _imageController.close();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.grey,
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Publicar'),
        backgroundColor: Color(0xffa23673A),
      ),
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height * 0.8,
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(10)),
          margin: EdgeInsets.all(20),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 30),
            child: Form(
              key: _formkey,
              child: Stack(children: [
                Column(
                  mainAxisSize: MainAxisSize.max,
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
                                    _pubBloc.inImage.add(img);
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
                                    : Image.file(
                                        snapshot.data!,
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
                            borderSide:
                                BorderSide(color: Colors.green, width: 2),
                          ),
                          enabledBorder: const UnderlineInputBorder(
                            borderSide:
                                BorderSide(color: Color(0xffa23673a), width: 1),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50),
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
                            savePublication(context);
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
                StreamBuilder<bool>(
                    initialData: false,
                    stream: _pubBloc.outLoading,
                    builder: (context, snapshot) => Visibility(
                        visible: snapshot.data!,
                        child: Container(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          color: Colors.transparent,
                          child: Center(
                            heightFactor: 15,
                            child: CircularProgressIndicator(
                              color: Colors.green,
                            ),
                          ),
                        )))
              ]),
            ),
          ),
        ),
      ),
    );
  }

  void savePublication(context) async {
    if (_formkey.currentState!.validate()) {
      await BlocProvider.getBloc<UserBloc>().verificarToken();

      bool success = await _pubBloc.submit();
      if (success == true) {
        ScaffoldMessenger.of(context).showSnackBar(snackBarSuccess);
        Navigator.of(context).pop();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(snackBarError);
      }
    }
  }

  final snackBarSuccess = SnackBar(
    content: Text(
      'Publicação realizada com sucesso',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.green,
  );

  final snackBarError = SnackBar(
    content: Text(
      'Erro ao publicar',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );
}
