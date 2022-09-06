import 'package:flutter/material.dart';
import 'package:semear/pages/home_screen.dart';
import 'package:semear/pages/initial_page.dart';
import 'package:semear/pages/login_page.dart';

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
