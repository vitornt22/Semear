import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:semear/models/donation_model.dart';
import 'package:photo_view/photo_view.dart';

class ValidationScreen extends StatelessWidget {
  ValidationScreen({super.key, required this.validate, required this.donation});
  Donation donation;
  void Function()? validate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: const [
            Text('Validar Doação'),
            SizedBox(width: 5),
            Icon(Icons.monetization_on)
          ],
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'Verifique o comprovante',
            style: TextStyle(fontSize: 15),
          ),
          const SizedBox(height: 30),
          Container(
            height: 500,
            child: PhotoView(
              imageProvider: NetworkImage(donation.voucher!),
            ),
          ),
          const SizedBox(height: 30),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.redAccent),
                ),
                onPressed: () {},
                child: Row(
                  children: const [
                    Text('Recusar'),
                    SizedBox(width: 3),
                    Icon(
                      Icons.cancel,
                      size: 15,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 30),
              ElevatedButton(
                onPressed: validate,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                ),
                child: Row(children: const [
                  Text('Validar'),
                  SizedBox(width: 3),
                  Icon(
                    Icons.check,
                    size: 15,
                  ),
                ]),
              ),
            ],
          )
        ],
      ),
    );
  }
}
