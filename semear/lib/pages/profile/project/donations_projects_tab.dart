// ignore_for_file: prefer_const_constructors, sized_box_for_whitespace

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/dialog_donation.dart';
import 'package:semear/pages/profile/project/my_donations.dart';
import 'package:semear/pages/profile/project/validation_screen.dart';
import 'dart:math' as math;

import 'package:semear/widgets/button_filled.dart';
import 'package:semear/widgets/card_transaction.dart';

class DonationsProject extends StatelessWidget {
  DonationsProject({super.key, required this.user, required this.type});
  String type;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  User user;
  ApiProfile api = ApiProfile();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: CustomScrollView(
        slivers: [
          SliverPersistentHeader(
            pinned: true,
            delegate: SliverAppBarDelegate(
              minHeight: 60.0,
              maxHeight: 60.0,
              child: StreamBuilder<bool>(
                  stream: profileBloc.gettingLoad,
                  initialData: profileBloc.outGettingLoadValue,
                  builder: (context, snapshot) {
                    return snapshot.data == null || snapshot.data == false
                        ? Expanded(child: SizedBox.shrink())
                        : Visibility(
                            visible: user.category != 'donor',
                            child: Container(
                              color: Theme.of(context).scaffoldBackgroundColor,
                              child: ButtonFilled(
                                  text: type == 'me'
                                      ? 'Visualizar minhas doações'
                                      : 'Fazer a minha doação',
                                  onClick: () {
                                    type == 'me'
                                        ? myDonatiosn(context)
                                        : donation(context);
                                  }),
                            ),
                          );
                  }),
            ),
          ),
          SliverToBoxAdapter(child: SizedBox(height: 10)),
          type == 'me' && user.category != 'donor'
              ? validations()
              : donations(),
        ],
      ),
    );
  }

  Widget donations() {
    return StreamBuilder<Map<int, List<dynamic>>>(
        stream: profileBloc.outDonations,
        initialData: profileBloc.outDonationsValue,
        builder: (context, snapshot) {
          getDonations();
          if (snapshot.hasData) {
            if (snapshot.data![user.id] != null) {
              profileBloc.inGettingLoading.add(true);
              return snapshot.data![user.id]!.isEmpty
                  ? noDonation()
                  : SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: CardTransaction(
                              origin: 'profile',
                              donation: snapshot.data![user.id]![index],
                            ),
                          );
                        },
                        // 40 list items
                        childCount: snapshot.data![user.id]!.length,
                      ),
                    );
            }
          }
          return circular();
        });
  }

  void myDonatiosn(context) {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                MyDonations(getDonations: getDonations, user: user)));
  }

  Widget validations() {
    return StreamBuilder<Map<int, List<dynamic>>>(
      stream: profileBloc.outValidations,
      initialData: profileBloc.outValidationsValue,
      builder: (context, snapshot) {
        getValidations();
        if (snapshot.hasData) {
          if (snapshot.data![user.id] != null) {
            profileBloc.inGettingLoading.add(true);
            return snapshot.data![user.id]!.isEmpty
                ? noDonation()
                : SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (BuildContext context, int index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 3),
                          child: listTileValidation(
                              snapshot.data![user.id]![index], context),
                        );
                      },
                      // 40 list items
                      childCount: snapshot.data![user.id]!.length,
                    ),
                  );
          }
        }
        return circular();
      },
    );
  }

  String? getCategory(category) {
    final map = {
      'project': 'Projeto',
      'missionary': 'Missionário',
      'donor': 'Doador',
      'church': 'Igreja',
    };
    return map[category];
  }

  Widget listTileValidation(donation, context) {
    void validate() async {
      final scaffold = ScaffoldMessenger.of(context);
      profileBloc.addLoading(donation.id, true);
      bool value = await api.setValidation(donation.id);
      if (value == true) {
        getValidations();
        scaffold.showSnackBar(snackBar(true, true));
      } else {
        scaffold.showSnackBar(snackBar(true, false));
      }
      profileBloc.addLoading(donation.id, false);
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ValidationScreen(validate: validate, donation: donation),
          ),
        );
      },
      child: Container(
        color: Colors.white,
        child: ListTile(
          title: Text(
              'Doação de R\$ ${donation.value} de ${donation.donor.username}'),
          subtitle: Padding(
              padding: EdgeInsets.symmetric(vertical: 5),
              child: Text('${getCategory(donation.donor.category)}')),
          trailing: StreamBuilder<Map<int, bool>>(
              stream: profileBloc.loadingController,
              initialData: profileBloc.outLoadingValue,
              builder: (context, snapshot) {
                if (snapshot.hasData == false) {
                  profileBloc.addLoading(donation.id, false);
                  return CircularProgressIndicator(color: Colors.green);
                } else {
                  return snapshot.data![donation.id] == null ||
                          snapshot.data![donation.id] == true
                      ? CircularProgressIndicator(color: Colors.green)
                      : SizedBox(
                          child: Wrap(children: [
                            IconButton(
                              tooltip: 'Validar',
                              onPressed: validate,
                              icon: Icon(
                                Icons.check,
                                color: Colors.green,
                              ),
                            ),
                            SizedBox(width: 10),
                            IconButton(
                                tooltip: 'Recusar',
                                onPressed: () async {
                                  final scaffold =
                                      ScaffoldMessenger.of(context);
                                  profileBloc.addLoading(donation.id, true);
                                  bool value =
                                      await api.recuseDonation(donation.id);
                                  if (value == true) {
                                    getValidations();
                                    scaffold
                                        .showSnackBar(snackBar(false, true));
                                  } else {
                                    scaffold
                                        .showSnackBar(snackBar(false, false));
                                  }
                                  profileBloc.addLoading(donation.id, false);
                                },
                                icon: Icon(
                                  Icons.cancel,
                                  color: Colors.red,
                                )),
                          ]),
                        );
                }
              }),
        ),
      ),
    );
  }

  snackBar(validate, type) {
    final error =
        Text(validate ? 'Erro na validação' : 'Erro ao tentar recusar');
    final success =
        Text(validate ? 'Sucesso na validação' : 'Validação recusada');
    final snack = SnackBar(
      content: type ? success : error,
      backgroundColor: type ? Colors.green : Colors.redAccent,
    );

    return snack;
  }

  Widget noDonation() {
    return SliverToBoxAdapter(
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 15),
        child: Text(
          type == 'me'
              ? 'Não há doações para validar'
              : 'Não foram feitas doações',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 25, 101, 27),
            fontSize: 15,
          ),
        ),
      ),
    );
  }

  Widget circular() {
    profileBloc.inGettingLoading.add(false);
    return SliverToBoxAdapter(
      child: Center(
        heightFactor: 5,
        child: CircularProgressIndicator(
          color: Colors.green,
        ),
      ),
    );
  }

  void donation(context) {
    showDialog(
        context: context,
        barrierDismissible: true,
        builder: (context) => DonationDialog(
            user: user, donor: userBloc.outUserValue![user.id]!.id));
  }

  void getDonations() async {
    api.getDonations(user.id, 'receive').then((value) {
      profileBloc.addDonations(user.id, value);
    });
    api.getDonations(user.id, 'sender').then((value) {
      profileBloc.addSenderDonations(user.id, value);
    });
  }

  void getValidations() async {
    api.getTransactionValidations(user.id).then((value) {
      profileBloc.addValidations(user.id, value);
    });
  }
}

class SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  SliverAppBarDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });
  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;
  @override
  double get maxExtent => math.max(maxHeight, minHeight);
  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(child: child);
  }

  @override
  bool shouldRebuild(SliverAppBarDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
