import 'package:flutter/material.dart';
import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/donations_projects.dart';

import '../widgets/card_transaction.dart';

class DonationsDonor extends StatelessWidget {
  const DonationsDonor({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: CardTransaction(),
                );
              },
              // 40 list items
              childCount: 40,
            ),
          ),
        ],
      ),
    );
  }
}
