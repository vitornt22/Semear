// ignore_for_file: use_full_hex_values_for_flutter_colors, must_be_immutable

import 'package:flutter/material.dart';

class TopCard extends StatefulWidget {
  TopCard({
    super.key,
    required this.number,
    required this.text,
    required this.icon,
  });

  int? number;
  String text;
  IconData icon;

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, right: 5),
        child: Card(
          color: const Color(0xffa23673A),
          child: SizedBox(
            height: 120,
            child: widget.number == null
                ? Center(
                    child: CircularProgressIndicator(
                    color: Colors.green,
                  ))
                : Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 3),
                        child: Text('${widget.number}',
                            style: const TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.w700)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8.0),
                        child: Text(
                          widget.text,
                          style: const TextStyle(
                              fontSize: 20,
                              color: Colors.white,
                              fontWeight: FontWeight.w200),
                        ),
                      ),
                      Icon(
                        widget.icon,
                        size: 40,
                        color: Colors.white,
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
