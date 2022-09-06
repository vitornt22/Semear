import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semear/widgets/sugestion_avatar.dart';

class Sugestions extends StatefulWidget {
  const Sugestions({super.key});

  @override
  State<Sugestions> createState() => _SugestionsState();
}

class _SugestionsState extends State<Sugestions> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0),
      height: 70,
      color: Colors.white,
      child: Row(
        children: [
          Expanded(
            child: ScrollConfiguration(
              behavior: ScrollConfiguration.of(context).copyWith(dragDevices: {
                PointerDeviceKind.mouse,
                PointerDeviceKind.touch,
              }),
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10),
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: 100,
                itemBuilder: (context, index) {
                  return const Sugestion_Avatar();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
