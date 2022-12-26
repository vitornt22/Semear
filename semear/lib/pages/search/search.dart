import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:semear/apis/api_search.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/search_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';

class DataSearch extends SearchDelegate<String?> {
  @override
  String get searchFieldLabel => 'Pesquisar';
  final api = ApiSearch();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  User? myUser;
  int? myId;

  final searchBloc = BlocProvider.getBloc<SearchBloc>();

  DataSearch() {
    myId = userBloc.outMyIdValue;
    myUser = userBloc.outUserValue![myId];
    api.getPageRankProjects('getTopProjects', '');
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
        onPressed: () {
          query = "";
          searchBloc.inQuery.add(query);
        },
        icon: const Icon(Icons.clear),
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return IconButton(
      onPressed: () {
        close(context, null);
      },
      icon: AnimatedIcon(
        progress: transitionAnimation,
        icon: AnimatedIcons.menu_arrow,
      ),
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    print("MY QUERY $query");
    api.getPageRankProjects('getCategoriesSearch', query);
    Future.delayed(Duration.zero).then((_) => close(context, query));
    return Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    getSuggestions(query);
    searchBloc.inQuery.add(query);

    return query.isEmpty
        ? Container()
        : StreamBuilder<List<dynamic>>(
            stream: searchBloc.outSuggestions,
            initialData: searchBloc.outSuggestionsValue,
            builder: (context, snapshot) {
              if (snapshot.hasData &&
                  snapshot.data != null &&
                  searchBloc.outLoadingValue == false) {
                return snapshot.data!.length == 0
                    ? noSuggestions()
                    : Padding(
                        padding: const EdgeInsets.all(20),
                        child: ListView.separated(
                          separatorBuilder: (context, index) => Divider(),
                          itemCount: snapshot.data!.length,
                          itemBuilder: (context, index) {
                            final info = snapshot.data![index].user!;
                            return GestureDetector(
                              onTap: () async {
                                late final myChurch;
                                myChurch = await getMyChurch(
                                    snapshot.data![index].user);

                                final navigator = Navigator.of(context);
                                if (myUser!.category == 'church' &&
                                    profileBloc.outProjectsChurchValue ==
                                        null) {
                                } else {
                                  final u = snapshot.data![index].user;
                                  navigator.push(
                                    MaterialPageRoute(
                                      builder: (context) => Scaffold(
                                        body: u.category == 'project' ||
                                                u.category == 'missionary'
                                            ? ProfileProjectPage(
                                                myChurch: myChurch,
                                                user: u,
                                                type: getType(snapshot
                                                    .data![index].user.id),
                                              )
                                            : getNextPage(u.category, u),
                                      ),
                                    ),
                                  );
                                }
                              },
                              child: ListTile(
                                leading: getLeadingList(info),
                                title: Text(
                                    snapshot.data![index].user.username ?? ''),
                                subtitle: Text(getCategory(
                                    snapshot.data![index].user.category)),
                              ),
                            );
                          },
                        ),
                      );
              }

              return const Center(
                child: CircularProgressIndicator(color: Colors.green),
              );
            },
          );
  }

  getNextPage(category, user) {
    switch (category) {
      case 'donor':
        return DonorProfilePage(user: user, type: getType(user.id));
      case 'church':
        return ChurchProfilePage(
            user: user, type: getType(user.id), first: false);
    }
  }

  Widget getLeadingList(user) {
    if (user.category == 'donor') {
      return const CircleAvatar(
        backgroundColor: Color.fromARGB(255, 212, 211, 211),
        backgroundImage: AssetImage('assets/images/anonimo.png'),
      );
    } else {
      return user!.information!.photoProfile != null
          ? CircleAvatar(
              child: Image.network(user!.information.photoProfile),
            )
          : const CircleAvatar(
              backgroundImage: AssetImage('assets/images/avatar.png'),
            );
    }
  }

  Widget noSuggestions() {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Text(
            'Não há sugestões para a pequisa',
            style: TextStyle(color: Colors.green),
          ),
        ],
      ),
    );
  }

  Future<bool> getMyChurch(data) async {
    final id = userBloc.outMyIdValue;

    if (userBloc.outUserValue![id]!.category == 'church') {
      final categoryData = profileBloc.outProjectsChurchValue![id]!;
      return categoryData != null && categoryData.contains(data.id);
    }
    return false;
  }

  getType(id) {
    return id == myId ? 'me' : 'other';
  }

  getCategory(category) {
    switch (category) {
      case 'project':
        return 'Projeto';
      case 'missionary':
        return 'Missionário';
      case 'church':
        return 'Igreja';
      case 'donor':
        return 'Doador';
      default:
    }
  }

  getSuggestions(String search) {
    print(search);
    api.getPageRankProjects('getSuggestions', search);
  }
}
