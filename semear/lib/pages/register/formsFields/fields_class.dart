import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/models/bank.dart';
import 'package:semear/pages/register/validations.dart';
import 'package:semear/pages/register/formsFields/forms_field.dart';

Validations validations = Validations();
ApiForm apiForm = ApiForm();

class FieldClass extends StatefulWidget {
  FieldClass(
      {super.key,
      required this.controller,
      required this.id,
      this.codeBankController,
      this.onChangeTypeHead,
      this.siglaUF,
      this.validator,
      this.label,
      this.onChangedVar,
      this.hint});

  var onChangeTypeHead;
  var onChangedVar;
  String? siglaUF = 'LL';
  TextEditingController controller;
  TextEditingController? codeBankController;
  String? Function(String? value)? validator;
  String id;
  String? label, hint;
  var lista;
  @override
  State<FieldClass> createState() => _FieldClassState();
}

class _FieldClassState extends State<FieldClass> {
  late Map map = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    map = {
      'email': email(),
      'basic': basic(),
      'password': password(),
      'contact': contact(),
      'zipCode': zipCode(),
      'number': basicNumber(),
      'cnpj': cnpj(),
      'bank': bank(),
      'agency': agency(),
      'digit': digit(),
      'church': church(),
    };

    return map[widget.id];
  }

  Widget zipCode() {
    return FormsField(
      label: 'CEP',
      mask: '#####-###',
      sizeBoxHeigth: 10,
      hintText: 'Digite o CEP',
      validator: validations.checkCep,
      keyboard: TextInputType.number,
      controller: widget.controller,
      onChangedVar: widget.onChangedVar ?? () {},
    );
  }

  Widget email() {
    return FormsField(
      autofill: const [AutofillHints.email],
      keyboard: TextInputType.emailAddress,
      controller: widget.controller,
      label: 'Email',
      validator: validations.checkEmail,
      hintText: 'ex: semear@gmail.com',
      sizeBoxHeigth: 10,
      onChangedVar: (String text) {
        if (widget.controller.text == 'email existent') {
          widget.controller.text = '';
        }
      },
    );
  }

  Widget contact() {
    return FormsField(
      mask: '(##)#####-####',
      keyboard: TextInputType.number,
      controller: widget.controller,
      label: 'Contato',
      hintText: 'ex: semear@gmail.com',
      sizeBoxHeigth: 10,
    );
  }

  Widget password() {
    return FormsField(
      validator: widget.validator ?? validations.checkPassword,
      keyboard: TextInputType.text,
      controller: widget.controller,
      mask: '#########',
      label: widget.label ?? 'Senha',
      obscureText: false,
      hintText: '',
      sizeBoxHeigth: 10,
    );
  }

  Widget basic() {
    return FormsField(
      keyboard: TextInputType.text,
      controller: widget.controller,
      label: widget.label,
      validator: validations.checkEmpty,
      hintText: widget.hint,
      sizeBoxHeigth: 10,
    );
  }

  Widget cnpj() {
    return FormsField(
      keyboard: TextInputType.number,
      mask: '##############',
      controller: widget.controller,
      validator: validations.checkCnpjValidation,
      label: 'CNPJ',
      hintText: 'ex: 11.111.111/0001-11',
    );
  }

  Widget church() {
    return FormsField(
      keyboard: TextInputType.number,
      mask: '##############',
      controller: widget.controller,
      validator: validations.checkChurchValidation,
      label: 'CNPJ da Igreja',
      hintText: 'ex: 11.111.111/0001-11',
    );
  }

  Widget basicNumber() {
    return FormsField(
      keyboard: TextInputType.number,
      controller: widget.controller,
      label: widget.label,
      hintText: widget.hint,
      sizeBoxHeigth: 10,
    );
  }

  Widget bank() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Banco',
          textAlign: TextAlign.start,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 10),
        TypeAheadFormField(
          validator: validations.checkEmpty,
          errorBuilder: (context, error) {
            return const ListTile(title: Text('Bancos nao encontrados'));
          },
          noItemsFoundBuilder: (context) => const ListTile(
            title: Text(' Preencha o Estado'),
          ),
          hideOnEmpty: true,
          suggestionsCallback: (pattern) =>
              widget.lista = apiForm.getBanks(widget.controller.text),
          itemBuilder: (context, Bank item) => ListTile(
            title: Text("${item.name}"),
          ),
          textFieldConfiguration: TextFieldConfiguration(
            controller: widget.controller,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 15, horizontal: 8),
              errorBorder: const OutlineInputBorder(
                  borderSide: BorderSide(style: BorderStyle.solid)),
              suffixIcon: IconButton(
                  onPressed: () {
                    widget.controller.text = "";
                  },
                  icon: const Icon(
                    Icons.cancel,
                    size: 15,
                  )),
              border: const OutlineInputBorder(
                // ignore: use_full_hex_values_for_flutter_colors
                borderSide: BorderSide(color: Color(0xffa23673a)),
              ),
              floatingLabelStyle: const TextStyle(color: Colors.green),
              filled: false,
              hintText: "Banco",
              focusedBorder: const OutlineInputBorder(
                gapPadding: 5,
                borderSide: BorderSide(color: Colors.black),
              ),
            ),
            onChanged: (context) {},
          ),
          onSuggestionSelected: (Bank val) {
            widget.controller.text = val.name!;
            widget.codeBankController?.text = val.ispb!;
          },
        ),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget agency() {
    return FormsField(
      keyboard: TextInputType.number,
      controller: widget.controller,
      mask: '#####',
      validator: validations.checkEmpty,
      label: 'Agência (somente numero)',
      hintText: 'Agência',
      sizeBoxHeigth: 10,
    );
  }

  Widget digit() {
    return FormsField(
      keyboard: TextInputType.text,
      controller: widget.controller,
      mask: '#',
      validator: validations.checkEmpty,
      label: 'Dígito',
      sizeBoxHeigth: 10,
    );
  }
}
