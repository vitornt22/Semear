// ignore_for_file: prefer_const_constructors

import 'dart:convert';
import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/apis/api_settings.dart';
import 'package:semear/blocs/edit_profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/missionary_model..dart';
import 'package:semear/models/project_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:http/http.dart' as http;
import 'package:semear/pages/register/formsFields/forms_field.dart';
import 'package:semear/validators/fields_validations.dart';

class EditProfile extends StatefulWidget {
  EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  TextEditingController nameController = TextEditingController();
  TextEditingController ministeryController = TextEditingController();

  TextEditingController resumeController = TextEditingController();
  TextEditingController whoAreUsController = TextEditingController();
  TextEditingController ourObjectiveController = TextEditingController();
  TextEditingController siteController = TextEditingController();
  //bank
  TextEditingController titularNamecontroller = TextEditingController();
  TextEditingController agencyController = TextEditingController();
  TextEditingController agencyDigitController = TextEditingController();
  TextEditingController accountController = TextEditingController();
  TextEditingController accountDigitController = TextEditingController();
  TextEditingController bankController = TextEditingController();
  TextEditingController codeController = TextEditingController();
  //pix
  // PI
  TextEditingController keyTypeController = TextEditingController();
  TextEditingController keyValueController = TextEditingController();

  //Adress
  TextEditingController zipCodeController = TextEditingController();
  TextEditingController adressController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController stateController = TextEditingController();
  TextEditingController districtController = TextEditingController();

  final editBloc = EditProfileBloc();
  final bool checkedValue = true;
  Validations validations = Validations();

  ApiForm apiForm = ApiForm();
  ApiSettings apiSettings = ApiSettings();
  static List<String> keyTypes = <String>['CNPJ', 'EMAIL', 'CELULAR'];

  String? dropdownValue;

  late Future<Map<String, dynamic>> cep;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  late final categoryData = userBloc.outCategoryValue![userBloc.outMyIdValue];
  late final user = userBloc.outUserValue![userBloc.outMyIdValue];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print('INFORMATIOJNS ${user!.information!}');
    if (isMissionaryOrProjet()) {
      editBloc.inPhotoProfile.add(user!.information!.photoProfile ??
          'https://cdn-icons-png.flaticon.com/512/149/149071.png');
      editBloc.inImage1.add(user!.information!.photo1);
      editBloc.inImage2.add(user!.information!.photo2);

      nameController.text =
          isProject() ? categoryData.name ?? '' : categoryData.fullname ?? '';
      resumeController.text = user!.information!.resume ?? '';
      siteController.text = user!.information!.site ?? '';

      whoAreUsController.text = user!.information!.whoAreUs ?? '';
      ourObjectiveController.text = user!.information!.ourObjective ?? '';
      zipCodeController.text = categoryData.adress.zipCode ?? '';
      adressController.text = categoryData.adress.adress ?? '';
      numberController.text = categoryData.adress.number ?? '';
      stateController.text = categoryData.adress.uf ?? '';
      districtController.text = categoryData.adress.district ?? '';
    }
    //Bank
    if (isChurch()) {
      final bankData = categoryData.bankData;
      final pix = categoryData.pix;
      titularNamecontroller.text = bankData.holder ?? '';
      agencyController.text = bankData.agency ?? '';
      agencyDigitController.text = bankData.digitAgency ?? '';
      accountController.text = bankData.account ?? '';
      accountDigitController.text = bankData.digitAccount ?? '';
      bankController.text = bankData.bankName ?? '';
      codeController.text = bankData.bank ?? '';
      nameController.text = categoryData.name ?? '';
      // PI
      keyTypeController.text = pix.typeKey ?? '';
      keyValueController.text = pix.valuekey ?? '';
      ministeryController.text = categoryData.ministery ?? '';
    }
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
                onPressed: () async {
                  editBloc.inLoading.add(true);
                  print(user!.information!.id);
                  await updateCategoryData();
                  await CreateOrUpdateInformation(
                      user!.information!.id == null ? 'POST' : 'PATCH');
                  if ((isMissionaryOrProjet() && categoryData.idAdress == 0) ||
                      isChurch()) {
                    await updateAdress();
                  }
                  if (isChurch()) {
                    await updateBankInformation();
                    await updatePix();
                  }
                  editBloc.inLoading.add(false);
                },
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
        body: StreamBuilder<bool>(
            stream: editBloc.outLoadingController,
            initialData: false,
            builder: (context, s) {
              return s.data == true
                  ? Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    )
                  : SingleChildScrollView(
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
                                padding: const EdgeInsets.only(
                                    right: 20, left: 10, top: 10),
                                child: Stack(children: [
                                  StreamBuilder<String?>(
                                      stream: editBloc.outPhotoProfile,
                                      initialData:
                                          editBloc.outPhotoProfileValue,
                                      builder: (context, snapshot) {
                                        return snapshot.hasData &&
                                                snapshot.data != null
                                            ? CircleAvatar(
                                                backgroundColor: Colors.green,
                                                backgroundImage: NetworkImage(
                                                    snapshot.data!),
                                                radius: 60,
                                              )
                                            : CircleAvatar(
                                                backgroundColor: Colors.green,
                                                radius: 60,
                                              );
                                      }),
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
                            field(isProject() ? 'Nome' : 'Nome Completo',
                                nameController),
                            Visibility(
                              visible: isChurch(),
                              child: field('Denomination', nameController),
                            ),
                            Visibility(
                              visible: isChurch(),
                              child: field('Ministério', ministeryController),
                            ),
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
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15),
                                    child: Column(
                                      children: [
                                        photoButton(context, 'Foto1',
                                            editBloc.inImage1),
                                        SizedBox(height: 5),
                                        photoButton(context, 'Foto2',
                                            editBloc.inImage2),
                                      ],
                                    ),
                                  )
                                : SizedBox(),
                            Visibility(
                              visible: (isMissionaryOrProjet() &&
                                      categoryData.idAdress == 0) ||
                                  isChurch(),
                              child: ExpansionTile(
                                initiallyExpanded: true,
                                title: Text('Endereço'),
                                children: [adressForm()],
                              ),
                            ),
                            Visibility(
                                visible: isChurch(),
                                child: ExpansionTile(
                                  title: Text('Informações Bancárias'),
                                  children: [],
                                )),
                            Row(
                              children: [
                                Padding(
                                  padding:
                                      const EdgeInsets.only(top: 10, left: 8),
                                  child: TextButton(
                                    onPressed: () {},
                                    child: Text(
                                      'Configurações Avançadas',
                                      style: TextStyle(
                                          color:
                                              Color.fromARGB(255, 17, 130, 20)),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
            }));
  }

  bool isMissionaryOrProjet() {
    return user!.category == 'missionary' || user!.category == 'project';
  }

  bool isProject() {
    return user!.category == 'project';
  }

  bool isChurch() {
    return user!.category == 'church';
  }

  Widget photoButton(context, text, streamAdd) {
    final stream = text == 'Foto1' ? editBloc.outImage1 : editBloc.outImage2;
    final value =
        text == 'Foto1' ? editBloc.outImage1Value : editBloc.outImage2Value;
    return Column(
      children: [
        StreamBuilder<String?>(
            stream: stream,
            initialData: value,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: () async {
                  addImage(context, streamAdd);
                },
                child: ClipRRect(
                  child: snapshot.data != null
                      ? Image(
                          image: NetworkImage(snapshot.data!),
                          width: double.infinity,
                          height: 200,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          color: Color.fromARGB(255, 199, 197, 197),
                          height: 200,
                          width: double.infinity,
                          child: Center(
                            child: Icon(
                              Icons.add_a_photo,
                              size: 40,
                            ),
                          )),
                ),
              );
            }),
        SizedBox(height: 10),
        StreamBuilder<String?>(
            stream: stream,
            initialData: value,
            builder: (context, snapshot) {
              return Text(snapshot.data == null
                  ? '$text: foto para capa de informações'
                  : 'Selecionado');
            }),
        SizedBox(height: 10),
      ],
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
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          FieldClass(
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
      ),
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
      streamAdd.add(newImage.path);
      navigator.pop();
    }
  }

  Widget dataChurchForms() {
    return Column(
      children: [
        Card(
          elevation: 10,
          color: Colors.white,
          child: ExpansionTile(
              initiallyExpanded: true,
              textColor: const Color(0xffa23673A),
              title: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: const [
                    SizedBox(),
                    Expanded(
                      child: Text(
                        'Conta Bancária',
                      ),
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      const Divider(
                        thickness: 1,
                        color: Colors.green,
                      ),
                      FieldClass(
                        controller: titularNamecontroller,
                        id: 'basic',
                        label: 'Nome do Titular',
                      ),
                      // FieldClass(controller: cnpjController, id: 'cnpj'),
                      FieldClass(
                        controller: bankController,
                        id: 'bank',
                        codeBankController: codeController,
                      ),
                      Row(
                        children: [
                          Expanded(
                              flex: 3,
                              child: FieldClass(
                                id: 'agency',
                                controller: agencyController,
                              )),
                          const SizedBox(width: 5),
                          Expanded(
                            child: FieldClass(
                              id: 'digit',
                              controller: agencyDigitController,
                              label: 'Digito',
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 4,
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: accountController,
                              label: 'Conta',
                            ),
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: FormsField(
                              keyboard: TextInputType.text,
                              controller: accountDigitController,
                              label: 'Digito',
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )
              ]),
        ),
        const SizedBox(height: 10),
        Card(
          elevation: 10,
          color: Colors.white,
          child: ExpansionTile(
            initiallyExpanded: true,
            textColor: const Color(0xffa23673A),
            title: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: const [
                  SizedBox(),
                  Expanded(
                    child: Text(
                      'PIX',
                    ),
                  ),
                ],
              ),
            ),
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: Column(
                  children: [
                    const Divider(
                      thickness: 1,
                      color: Colors.green,
                    ),
                    InputDecorator(
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                            validator: validations.checkEmpty,
                            isExpanded: true,
                            hint: const Text('Tipo de chave'),
                            value: dropdownValue,
                            alignment: Alignment.center,
                            onChanged: (String? selectedValue) {
                              setState(() {
                                dropdownValue = selectedValue;
                                keyTypeController.text = selectedValue!;
                              });
                            },
                            items: keyTypes
                                .map<DropdownMenuItem<String>>((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList()),
                      ),
                    ),
                    FormsField(
                      keyboard: TextInputType.text,
                      controller: keyValueController,
                      label: 'Valor da Chave',
                      sizeBoxHeigth: 10,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ],
    );
  }

  getObject(data) {
    final category = user!.category;
    switch (category) {
      case 'project':
        return Project.fromJson(data);
      case 'missionary':
        return Missionary.fromJson(data);
      case 'church':
        return Project.fromJson(data);
      default:
        break;
    }
  }

  getCategoryData() async {
    final response = await http.get(
      Uri.parse(
          "https://backend-semear.herokuapp.com/${user!.category}/api/${user!.id}/get${user!.category}Data/"),
    );
    return getObject(jsonDecode(response.body));
  }

  updateAdress() async {
    print("ID ${categoryData.adress.id}");

    final response = await http.patch(
      Uri.parse(
          "http://backend-semear.herokuapp.com/adress/api/${categoryData.adress.id}/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "zip_code": zipCodeController.text,
        "adress": adressController.text,
        "number": numberController.text,
        "city": cityController.text,
        "uf": stateController.text,
        "district": districtController.text
      }),
    );
    print("RESPONSE BODY ${jsonDecode(response.body)}");
    print(response.statusCode);

    if (response.statusCode == 200) {
      await updateUserCategory();
    }
  }

  updateCategoryData() async {
    final json = {};

    if (isChurch() || isProject()) {
      if (isChurch()) {
        json['ministery'] = ministeryController.text;
      }
      json['name'] = nameController.text.toString();
    } else {
      json['fullName'] = nameController.text.toString();
    }
    print('JSON ${jsonEncode(json)}');
    final category = getCategory();
    print(categoryData);
    final response = await http.patch(
      Uri.parse(
          "http://backend-semear.herokuapp.com/$category/api/${categoryData.id}/"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode(json),
    );
    //print("RESPONSE BODY ${response.body}");
    print(response.statusCode);

    if (response.statusCode == 200) {
      await updateUserCategory();
    }
  }

  updateBankInformation() async {
    final response = await http.patch(
      Uri.parse(
          "http://backend-semear.herokuapp.com/banKData/api/${categoryData.banKData.id}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "holder": titularNamecontroller.text,
        "bankName": bankController.text,
        "bank": codeController.text,
        "agency": agencyController.text,
        "digitAgency": agencyDigitController.text,
        "account": accountController.text,
        "digitAccount": accountDigitController.text
      }),
    );
    print("RESPONSE BODY ${response.body}");

    if (response.statusCode == 200) {
      await updateUserCategory();
    }
  }

  updatePix() async {
    final response = await http.patch(
      Uri.parse(
          "http://backend-semear.herokuapp.com/pix/api/${categoryData.pix.id}"),
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        "typeKey": keyTypeController.text,
        "valueKey": keyValueController.text,
      }),
    );
    print("RESPONSE BODY ${response.body}");

    if (response.statusCode == 200) {
      await updateUserCategory();
    }
  }

  CreateOrUpdateInformation(text) async {
    final map = {
      'PATCH':
          "https://backend-semear.herokuapp.com/information/api/${user!.information!.id}/",
      'POST': "https://backend-semear.herokuapp.com/information/api/"
    };

    var request = http.MultipartRequest(
      text,
      Uri.parse(map[text]!),
    );

    if (isMissionaryOrProjet()) {
      request.fields['id'] = user!.id.toString();
      request.fields['resume'] = resumeController.text.toString();
      request.fields['site'] = siteController.text.toString();
      request.fields['whoAreUs'] = whoAreUsController.text.toString();
      request.fields['ourObjective'] = ourObjectiveController.text.toString();

      if (editBloc.outPhotoProfileValue != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo_profile',
            File(editBloc.outPhotoProfileValue!).readAsBytesSync(),
            filename: "ola",
          ),
        );
      }

      if (editBloc.outImage2Value != null) {
        request.files.add(
          http.MultipartFile.fromBytes(
            'photo2',
            File(editBloc.outImage2Value!).readAsBytesSync(),
            filename: "ola",
          ),
        );
      }
    }
    //photo is all users
    if (editBloc.outImage1Value != null) {
      request.files.add(
        http.MultipartFile.fromBytes(
          'photo1',
          File(editBloc.outImage1Value!).readAsBytesSync(),
          filename: "ola",
        ),
      );
    }

    var res = await request.send();
    print("RES $res");
    print('Eai ${res.statusCode}');

    if (res.statusCode == 200) {
      await updateUserCategory();
    }
  }

  updateUserCategory() async {
    final response = await apiSettings.getUser(user!.id);
    final categoryData = await getCategoryData();
    userBloc.addUser(response);
    userBloc.addCategory(user!.id, categoryData);
  }

  getCategory() {
    if (isProject()) {
      return 'project';
    } else if (isChurch()) {
      return 'church';
    } else {
      return 'missionary';
    }
  }
}
