import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/models/city.dart';
import 'package:semear/models/uf.dart';
import 'dart:async';
import 'package:semear/pages/register/validations.dart';

ApiForm apiForm = ApiForm();
Validations validations = Validations();

class CityState extends StatefulWidget {
  CityState({
    super.key,
    required this.cityController,
    required this.stateController,
  });

  TextEditingController cityController;
  TextEditingController stateController;

  @override
  State<CityState> createState() => _CityStateState();
}

class _CityStateState extends State<CityState> {
  String siglaUF = "LL";
  int ufCode = 0;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Cidade',
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
                  return const ListTile(title: Text('Cidades nao achadas'));
                },
                noItemsFoundBuilder: (context) => const ListTile(
                  title: Text(' Preencha o Estado'),
                ),
                hideOnEmpty: true,
                suggestionsCallback: (pattern) =>
                    apiForm.getCities(widget.cityController.text, siglaUF),
                itemBuilder: (context, City item) => ListTile(
                  title: Text("${item.name}"),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                    controller: widget.cityController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            widget.cityController.text = "";
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 15,
                          )),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa23673a)),
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.green),
                      filled: false,
                      hintText: "Cidade",
                      focusedBorder: const OutlineInputBorder(
                        gapPadding: 5,
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (context) {
                      if (widget.stateController.text.isEmpty) {
                        setState(() {
                          siglaUF = "LL";
                        });
                      }
                    }),
                onSuggestionSelected: (City val) {
                  widget.cityController.text = val.name!;
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
        const SizedBox(width: 5),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'UF',
                textAlign: TextAlign.start,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 10),
              TypeAheadFormField(
                validator: validations.checkUF,
                hideOnEmpty: true,
                hideKeyboard: true,
                suggestionsCallback: (pattern) =>
                    apiForm.getUfs(widget.stateController.text),
                itemBuilder: (context, UF item) => ListTile(
                  title: Text("${item.sigla}"),
                ),
                textFieldConfiguration: TextFieldConfiguration(
                    controller: widget.stateController,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 8),
                      errorBorder: const OutlineInputBorder(
                          borderSide: BorderSide(style: BorderStyle.solid)),
                      suffixIcon: IconButton(
                          onPressed: () {
                            widget.stateController.text = "";
                            setState(() {
                              siglaUF = "LL";
                            });
                          },
                          icon: const Icon(
                            Icons.cancel,
                            size: 15,
                          )),
                      border: const OutlineInputBorder(
                        borderSide: BorderSide(color: Color(0xffa23673a)),
                      ),
                      floatingLabelStyle: const TextStyle(color: Colors.green),
                      filled: false,
                      hintText: "UF",
                      focusedBorder: const OutlineInputBorder(
                        gapPadding: 5,
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    ),
                    onChanged: (context) {
                      if (widget.stateController.text.isEmpty) {
                        setState(() {
                          siglaUF = "LL";
                        });
                      }
                    }),
                onSuggestionSelected: (UF val) {
                  widget.stateController.text = val.sigla!;
                  setState(() {
                    ufCode = val.id!;
                    siglaUF = val.sigla!;
                  });
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ],
    );
  }
}
