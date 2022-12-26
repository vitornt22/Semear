// ignore_for_file: unnecessary_const, use_full_hex_values_for_flutter_colors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_transaction.dart';
import 'package:semear/blocs/donation_bloc.dart';
import 'package:semear/models/numbers_card_model.dart';
import 'package:semear/widgets/card_transaction.dart';
import 'package:semear/widgets/card_transaction_count.dart';

class TransactionPage extends StatefulWidget {
  const TransactionPage({super.key});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  final donationsBloc = BlocProvider.getBloc<DonationBloc>();
  ApiTransaction api = ApiTransaction();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getAllTransactions();
  }

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
              child: StreamBuilder<NumbersCard?>(
                  stream: donationsBloc.outNumbersCard,
                  initialData: donationsBloc.outNumbersCardValue,
                  builder: (context, snapshot) {
                    final value = snapshot.data;
                    getNumberCard();
                    if (snapshot.hasData) {
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          TopCard(
                              number: value!.donations,
                              text: "Doações",
                              icon: Icons.favorite),
                          TopCard(
                              number: value.projects,
                              text: "Projetos",
                              icon: Icons.folder),
                          TopCard(
                              number: value.missionaries!,
                              text: "Missionários",
                              icon: Icons.person),
                        ],
                      );
                    } else {
                      donationsBloc.addNumberCard(null);
                      return const SizedBox(
                        width: double.infinity,
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: Center(
                              child: CircularProgressIndicator(
                            color: Colors.green,
                          )),
                        ),
                      );
                    }
                  }),
            ),
          ),
          StreamBuilder<List<dynamic>>(
              stream: donationsBloc.outAllTransactions,
              initialData: donationsBloc.outAllTransactionsValue,
              builder: (context, snapshot) {
                getAllTransactions();
                if (snapshot.hasData) {
                  return snapshot.data!.isEmpty
                      ? SliverToBoxAdapter(child: noText('transações'))
                      : SliverList(
                          delegate: SliverChildBuilderDelegate(
                            (BuildContext context, int index) {
                              return CardTransaction(
                                origin: 'transactionPage',
                                donation: snapshot.data![index],
                              );
                            },
                            childCount:
                                snapshot.data!.length, // 1000 list items
                          ),
                        );
                }

                return const SliverToBoxAdapter(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.green,
                    ),
                  ),
                );
              }),
        ],
      ),
    );
  }

  getAllTransactions() async {
    await api
        .getAllTransaction('getAllTransactions')
        .then((value) => donationsBloc.updateAllTransactions(value));
  }

  getNumberCard() async {
    await api
        .getAllTransaction('getNumberCards')
        .then((value) => donationsBloc.addNumberCard(value));
  }

  Widget noText(text) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Text(
        'Não há $text',
        style: const TextStyle(color: Color.fromRGBO(17, 114, 20, 1)),
        textAlign: TextAlign.center,
      ),
    );
  }
}
