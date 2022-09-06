// ignore_for_file: unnecessary_const, use_full_hex_values_for_flutter_colors

import 'package:flutter/material.dart';
import 'package:semear/widgets/card_transaction.dart';
import 'package:semear/widgets/card_transaction_count.dart';

class TransactionPage extends StatelessWidget {
  const TransactionPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: SizedBox(
                width: double.infinity,
                height: 60,
                child: Card(
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "Transações",
                        style: TextStyle(
                            color: const Color(0xffa23673A),
                            fontSize: 30,
                            fontWeight: FontWeight.w800),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TopCard(
                      number: "1500", text: "Doações", icon: Icons.favorite),
                  TopCard(number: "200", text: "Projetos", icon: Icons.folder),
                  TopCard(number: "100", text: "Doações", icon: Icons.person),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return CardTransaction();
              },
              childCount: 100, // 1000 list items
            ),
          ),
        ],
      ),
    );
  }
}
