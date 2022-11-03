import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/widgets/card_transaction.dart';

class MyDonations extends StatefulWidget {
  MyDonations({super.key, required this.getDonations, required this.user});

  User user;
  Function getDonations;

  @override
  State<MyDonations> createState() => _MyDonationsState();
}

class _MyDonationsState extends State<MyDonations>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.animateTo(0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Text(
              'Minhas Doações',
              style: TextStyle(color: Colors.white),
            ),
            SizedBox(width: 10),
          ],
        ),
        // ignore: prefer_const_constructors
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
        bottom: TabBar(
          indicatorColor: Colors.white,
          controller: _tabController,
          labelStyle: const TextStyle(color: Colors.white),
          labelColor: Colors.white,
          tabs: const [
            Tab(text: 'Recebidas'),
            Tab(text: 'Feitas'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          list('receive', true),
          list('donorProfile', false),
        ],
      ),
    );
  }

  Widget list(origin, category) {
    return StreamBuilder<Map<int, List<dynamic>>>(
        stream: category
            ? profileBloc.outDonations
            : profileBloc.outSenderDonations,
        initialData: category
            ? profileBloc.outDonationsValue
            : profileBloc.outSenderDonationsValue,
        builder: (context, snapshot) {
          widget.getDonations();
          if (snapshot.hasData && snapshot.data![widget.user.id] != null) {
            return snapshot.data![widget.user.id]!.isEmpty
                ? text(category)
                : ListView.builder(
                    itemCount: snapshot.data![widget.user.id]!.length,
                    itemBuilder: (BuildContext context, int index) {
                      return CardTransaction(
                          origin: origin,
                          donation: snapshot.data![widget.user.id]![index]);
                    });
          }
          return const Center(
            child: SizedBox(
              child: CircularProgressIndicator(color: Colors.green),
            ),
          );
        });
  }

  Widget text(category) {
    String text = category ? "recebidas" : "feitas";
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Text(
        'Não há doações $text ',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.green),
      ),
    );
  }
}
