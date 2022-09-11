import 'package:flutter/material.dart';
import 'package:semear/pages/initial_page.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      debugShowMaterialGrid: false,
      home: InitialPage(),
      //home: HomeScreen(),
    ),
  );
}
