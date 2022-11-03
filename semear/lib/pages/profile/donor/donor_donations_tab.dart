import 'package:flutter/material.dart';
import 'package:semear/models/donation_model.dart';
import 'package:semear/widgets/card_transaction.dart';

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
                  child: CardTransaction(
                    origin: 'donorProfile',
                    donation: Donation(),
                  ),
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
