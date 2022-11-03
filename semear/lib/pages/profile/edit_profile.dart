// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/edit_profile_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key, required this.categoryData, required this.user});

  User user;
  final categoryData;

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController resumeController = TextEditingController();
  TextEditingController whoAreUsController = TextEditingController();
  TextEditingController ourObjectiveController = TextEditingController();
  TextEditingController siteController = TextEditingController();

  //Adress
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  final editBloc = EditProfileBloc();

  bool checkedValue = true;
  ApiForm apiForm = ApiForm();
  late Future<Map<String, dynamic>> cep;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    nameController.text = widget.categoryData.name;
    resumeController.text = widget.user.information!.resume!;
    //siteController.text = widget.user.information!.site!;
    whoAreUsController.text = widget.user.information!.whoAreUs!;
    ourObjectiveController.text = widget.user.information!.ourObjective!;
    zipCodeController.text = widget.categoryData.adress.zipCode;
    adressController.text = widget.categoryData.adress.adress;
    numberController.text = widget.categoryData.adress.number;
    stateController.text = widget.categoryData.adress.uf;
    districtController.text = widget.categoryData.adress.district;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: IconButton(
                tooltip: 'Salvar alterações',
                onPressed: () {},
                icon: Icon(Icons.check),
              ),
            )
          ],
          backgroundColor: Colors.green,
          title: Row(
            children: const [
              Text('Editar Perfil'),
              SizedBox(width: 5),
              Icon(Icons.edit)
            ],
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    addImage(editBloc.inPhotoProfile, context);
                  },
                  child: Padding(
                    padding:
                        const EdgeInsets.only(right: 20, left: 10, top: 10),
                    child: Stack(children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(
                            widget.user.information!.photoProfile!),
                        radius: 60,
                      ),
                      Positioned(
                        bottom: -1,
                        left: 75,
                        child: CircleAvatar(
                          backgroundColor: Colors.grey,
                          child: Icon(
                            Icons.add_a_photo,
                            color: Colors.black,
                          ),
                        ),
                      )
                    ]),
                  ),
                ),
                field('Nome', nameController),
                field('Resumo', resumeController),
                field('Site', siteController),
                isMissionaryOrProjet()
                    ? field('Sobre o projeto', whoAreUsController)
                    : SizedBox(),
                isMissionaryOrProjet()
                    ? field('Objetivo', ourObjectiveController)
                    : SizedBox(),
                isMissionaryOrProjet()
                    ? Padding(
                        padding: EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            photoButton(context, 'Foto1', editBloc.inImage1),
                            SizedBox(width: 5),
                            photoButton(context, 'Foto2', editBloc.inImage2),
                          ],
                        ),
                      )
                    : SizedBox(),
                widget.categoryData.idAdress > 0
                    ? Padding(
                        padding: EdgeInsets.all(20),
                        child: ExpansionTile(
                          title: Text('Endereço'),
                          children: [adressForm()],
                        ))
                    : SizedBox(),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10, left: 8),
                      child: TextButton(
                        onPressed: () {},
                        child: Text(
                          'Configurações Avançadas',
                          style: TextStyle(
                              color: Color.fromARGB(255, 17, 130, 20)),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ));
  }

  bool isMissionaryOrProjet() {
    if (widget.user.category == 'missionary' ||
        widget.user.category == 'project') {
      return true;
    }
    return false;
  }

  Widget photoButton(context, text, streamAdd) {
    return Expanded(
      child: ElevatedButton(
        onPressed: () async {
          addImage(context, streamAdd);
        },
        style: ButtonStyle(
          foregroundColor: MaterialStateProperty.all(Colors.black),
          backgroundColor:
              MaterialStateProperty.all(Color.fromARGB(255, 233, 233, 233)),
        ),
        child: Text(text),
      ),
    );
  }

  Widget field(text, controller) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Wrap(children: [
        Text(
          text,
          style: TextStyle(color: Colors.green),
        ),
        TextFormField(
          controller: controller,
          minLines: 1,
          maxLines: 10,
          decoration: InputDecoration(),
        ),
      ]),
    );
  }

  void addImage(context, streamAdd) async {
    XFile? image = (await ImagePicker().pickImage(source: ImageSource.gallery));
    if (image != null) {
      File? newImage = File(image.path);
      imageSelected(newImage, context, streamAdd);
    }
  }

  Widget adressForm() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: FieldClass(
            controller: zipCodeController,
            id: 'zipCode',
            onChangedVar: (String text) {
              cep = apiForm.getCep(zipCodeController.text).then((map) {
                String? erro = map['erro'];

                print('ERRO RECEIVE $erro');
                if (erro != "true") {
                  print("ENTROU NA 1 $map");
                  cityController.text = map["localidade"];
                  stateController.text = map["uf"];
                  districtController.text = map['bairro'];
                  adressController.text = map['logradouro'];
                } else {
                  print("ENTRANDO AQUI: $map");
                  setState(() {
                    cityController.clear();
                    stateController.text = "";
                    districtController.text = "";
                    adressController.clear;
                  });
                }
              });
            },
          ),
        ),
        CityState(
            cityController: cityController, stateController: stateController),
        Row(
          children: [
            Expanded(
              flex: 4,
              child: FieldClass(
                id: 'basic',
                controller: districtController,
                hint: 'Bela Vista',
                label: 'Bairro',
              ),
            ),
            SizedBox(width: 5),
            Expanded(
              child: FieldClass(
                controller: numberController,
                id: 'number',
                label: 'Nº',
              ),
            ),
          ],
        ),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: FieldClass(
                id: 'basic',
                controller: adressController,
                label: 'Logradouro',
                hint: 'R. Odomirio Ribeiro',
              ),
            ),
          ],
        ),
      ],
    );
  }

  void imageSelected(File image, BuildContext context, streamAdd) async {
    if (image != null) {
      final navigator = Navigator.of(context);
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

      navigator.pop();
      streamAdd.add(newImage);
    }
  }

  Future<bool> submit() async {
    //var image = await imagem.readAsBytes();
    var imagem = _imageControlller.value;
    if (imagem != null) {
      print("ENTROU NO METODO SUBMIT");
      var request = http.MultipartRequest('POST',
          Uri.parse("https://backend-semear.herokuapp.com/publication/api/"));

      print("USUARIO AQUI : ${userBloc.outUserValue.id}");
      request.fields['id_user'] = userBloc.outUserValue.id.toString();
      request.fields['legend'] = _legendController.valueOrNull ?? " ";
      request.fields['user'] = null.toString();
      request.fields['likes'] = [].toString();
      request.fields['comments'] = [].toString();

      print("OLA");
      request.fields['is_accountability'] = false.toString();
      request.files.add(
        http.MultipartFile.fromBytes(
          'upload',
          File(imagem.path).readAsBytesSync(),
          filename: "ola",
        ),
      );
      var res = await request.send();
      if (res.statusCode == 200) {
        _loadingController.add(false);
        return true;
      } else {
        _loadingController.add(false);
        return false;
      }
    }
    _loadingController.add(false);
    return false;
  }
}
