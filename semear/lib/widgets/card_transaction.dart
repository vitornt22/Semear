// ignore_for_file: use_full_hex_values_for_flutter_colors, unnecessary_const

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/donation_model.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

class CardTransaction extends StatelessWidget {
  CardTransaction({super.key, required this.origin, required this.donation});
  Donation donation;
  String origin;
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      child: ExpansionTile(
        key: const PageStorageKey('1'),
        initiallyExpanded: false,
        textColor: const Color(0xffa23673A),
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              const SizedBox(),
              Expanded(child: getText()),
            ],
          ),
        ),
        children: [
          const Divider(
            thickness: 1,
            color: Colors.green,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            child: Column(
              children: [
                Row(
                  children: [
                    const Expanded(child: Text('Doador:')),
                    Visibility(
                      visible: donation.donor != null,
                      child: Text(donation.isAnonymous == true
                          ? 'Anônimo'
                          : donation.donor!.username!),
                    ),
                    Visibility(
                      visible: donation.donor == null,
                      child: const Text('Anônimo'),
                    )
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    const Expanded(child: Text('Beneficiário:')),
                    donation.userData != null
                        ? GestureDetector(
                            onTap: () {
                              final navigator = Navigator.of(context);
                              updateUserCategory(
                                  donation.user, donation.userData);
                              navigator.push(MaterialPageRoute(
                                builder: (context) => Scaffold(
                                  body: ProfileProjectPage(
                                    myChurch: getMyChurch(donation.user),
                                    back: false,
                                    user: donation.user!,
                                    type: 'other',
                                  ),
                                ),
                              ));
                            },
                            child: Text(donation.user!.category == 'project'
                                ? donation.userData.name
                                : donation.userData.fullName),
                          )
                        : const Text('Conta Apagada')
                  ],
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: const [
                    Expanded(child: Text('Forma:')),
                    Text('PIX')
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${donation.value}',
                      style: const TextStyle(
                          color: Color(0xffa23673A), fontSize: 30),
                    ),
                    const Icon(
                      Icons.monetization_on,
                      size: 50,
                      color: Color(0xffa23673A),
                    )
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  bool getMyChurch(data) {
    final id = userBloc.outMyIdValue;

    if (userBloc.outUserValue![id]!.category == 'church') {
      return profileBloc.outProjectsChurchValue![id]!.contains(data.id);
    }
    return false;
  }

  Widget getText() {
    String value;
    switch (origin) {
      case 'transactionPage':
        return Text(
            'Doação de R\$ ${donation.value} para ${donation.user!.username!} ');
      case 'profile':
        return Text(
            'Doação de R\$ ${donation.value} feita por ${donation.donor!.username} ');
      case 'donorProfile':
        return Text(
            'Doação de R\$ ${donation.value} para ${donation.user!.username} ');
      case 'receive':
        return Text(
            'Doação de R\$ ${donation.value} recebida de  ${donation.user!.username} ');
      default:
        return const Text('');
    }
  }

  updateUserCategory(user, category) {
    userBloc.addUser(user);
    userBloc.addCategory(user.id, category);
  }
}
