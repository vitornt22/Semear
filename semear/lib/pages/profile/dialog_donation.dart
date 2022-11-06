import 'dart:io';

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/blocs/donation_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:semear/validators/fields_validations.dart';
import 'package:semear/widgets/button_filled.dart';

class DonationDialog extends StatefulWidget {
  const DonationDialog({super.key, required this.user, required this.donor});
  final user, donor;

  @override
  State<DonationDialog> createState() => _DonationDialogState();
}

class _DonationDialogState extends State<DonationDialog> {
  ApiForm api = ApiForm();
  String? dropdownValue;
  final validation = Validations();
  TextEditingController keyTypeController = TextEditingController();

  TextEditingController valueController = TextEditingController();
  bool checkedValue = false;
  static List<String> keyTypes = <String>['PIX', 'Transferência Bancária'];
  GlobalKey<FormState> keyForm = GlobalKey<FormState>();
  final donationBloc = DonationBloc();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final church = userBloc.outCategoryValue![widget.user.id].church;

    return AlertDialog(
        title: const Text(
          'Preencher Campos para doação',
          textAlign: TextAlign.start,
        ),
        content: Stack(
          children: [
            SizedBox(
                height: 500,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      ExpansionTile(
                        title: const Text(
                          'Ver informações para doação',
                          textAlign: TextAlign.center,
                        ),
                        childrenPadding: const EdgeInsets.all(10),
                        children: [
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text('Conta Bancária'),
                                  const SizedBox(height: 20),
                                  Text(
                                    "Titular: ${church.bankData.holder}",
                                    textAlign: TextAlign.start,
                                  ),
                                  Text("Banco: ${church.bankData.bankName}"),
                                  Text("CNPJ: ${church.bankData.cnpj}"),
                                  Text(
                                      "Agência: ${church.bankData.agency}-${church.bankData.digitAgency}"),
                                  Text(
                                      "Conta: ${church.bankData.account}-${church.bankData.digitAccount}"),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          Row(
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 10),
                                  const Text('PIX'),
                                  const SizedBox(height: 20),
                                  Text('Tipo de Chave: ${church.pix.typeKey}'),
                                  Text('Chave: ${church.pix.valueKey}'),
                                  const SizedBox(height: 10),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(height: 20),
                          const Divider(),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    SizedBox(height: 10),
                                    Text(
                                      maxLines: 10,
                                      'OBS: Faça a doação para qualquer um dos campos acima, e logo em seguida preencha os dados para cadastrar a doação e contribuir para a divulgação dos projetos e missionários',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Form(
                        key: keyForm,
                        child: form(),
                      ),
                      const SizedBox(height: 50),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(double.infinity, 40),
                              shape: const StadiumBorder(),
                              backgroundColor: Color(0xffa23673a),
                            ),
                            onPressed: () async {
                              _submitDonation();
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  'Publicar Doação',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600),
                                ),
                                SizedBox(width: 5),
                                Icon(Icons.monetization_on)
                              ],
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                )),
            StreamBuilder<bool>(
              stream: donationBloc.outLoadingController,
              initialData: false,
              builder: (context, snapshot) => Visibility(
                visible: snapshot.data!,
                child: Container(
                  height: double.maxFinite,
                  width: double.maxFinite,
                  color: Colors.transparent,
                  child: const Center(
                    heightFactor: 15,
                    child: CircularProgressIndicator(color: Colors.green),
                  ),
                ),
              ),
            )
          ],
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'Recusar'),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('Doar'),
          ),
        ]);
  }

  void _submitDonation() async {
    if (keyForm.currentState!.validate() &&
        donationBloc.outImageValue != null) {
      bool result = await donationBloc.submit(valueController.text,
          keyTypeController.text, widget.user.id, widget.donor);

      if (result == true) {
        print("RESULTP==TRUE");
        donationBloc.reset();
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Doação realizada com sucesso'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(context);
      } else {
        print("Nao ENTROU");
      }
    } else {
      donationBloc.inErrorImage.add(true);
    }
  }

  Widget form() {
    return Column(
      children: [
        FieldClass(controller: valueController, id: 'valueFloat'),
        InputDecorator(
          decoration: const InputDecoration(border: OutlineInputBorder()),
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
                items: keyTypes.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList()),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        StreamBuilder<bool>(
          stream: donationBloc.outAnonymousController,
          initialData: false,
          builder: (context, snapshot) => CheckboxListTile(
            activeColor: Colors.green,
            title: const Text("Doar de forma Anônima"),
            contentPadding: const EdgeInsets.all(2),
            value: snapshot.data,
            onChanged: (newValue) {
              donationBloc.inAnonymousController.add(newValue);
            },
            controlAffinity:
                ListTileControlAffinity.leading, //  <-- leading Checkbox
          ),
        ),
        Row(
          children: [
            ElevatedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                    const Color.fromARGB(255, 222, 220, 220)),
              ),
              onPressed: () async {
                XFile? image = (await ImagePicker()
                    .pickImage(source: ImageSource.gallery));
                if (image != null) {
                  File? newImage = File(image.path);
                  donationBloc.inImage.add(newImage);
                  donationBloc.inErrorImage.add(false);
                }
              },
              child: StreamBuilder<File?>(
                stream: donationBloc.outImage,
                initialData: null,
                builder: (context, snapshot) => Text(
                  snapshot.data != null
                      ? 'comprovante selecionado'
                      : 'Selecionar comprovante',
                  style: const TextStyle(color: Colors.black),
                ),
              ),
            ),
          ],
        ),
        StreamBuilder<bool>(
          stream: donationBloc.outErrorImage,
          initialData: false,
          builder: (context, snapshot) => Visibility(
            visible: snapshot.data!,
            child: Column(
              children: [
                SizedBox(height: 20),
                Row(
                  children: const [
                    Text(
                      'Selecione o comprovante',
                      textAlign: TextAlign.start,
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}
