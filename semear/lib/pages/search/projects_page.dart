import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_search.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/search_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:semear/pages/search/search.dart';
import 'package:semear/pages/search/top_projects.dart';

class ProjectsPage extends StatefulWidget {
  ProjectsPage({super.key, required this.controller});

  PageController controller;
  @override
  State<ProjectsPage> createState() => _ProjectsPageState();
}

class _ProjectsPageState extends State<ProjectsPage>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final api = ApiSearch();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();
  User? myUser;
  int? myId;

  final searchhBloc = BlocProvider.getBloc<SearchBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.animateTo(0);
    myId = userBloc.outMyIdValue;
    myUser = userBloc.outUserValue![myId];
    api.getPageRankProjects('getCategoriesSearch', searchhBloc.outQueryValue);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await api.getPageRankProjects(
              'getCategoriesSearch', searchhBloc.outQueryValue);
          await api.getPageRankProjects('getTopProjects', '');
        },
        edgeOffset: 100,
        child: ScrollConfiguration(
          behavior: ScrollConfiguration.of(context).copyWith(
            dragDevices: {
              PointerDeviceKind.touch,
              PointerDeviceKind.mouse,
            },
          ),
          child: Scaffold(
            backgroundColor: const Color.fromARGB(255, 224, 211, 211),
            appBar: AppBar(
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20),
                  child: IconButton(
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch());
                    },
                    icon: const Icon(Icons.search),
                  ),
                )
              ],
              leadingWidth: 230,
              leading: Image.asset(
                'assets/images/logo.png',
              ),
              backgroundColor: const Color(0xffa23673A),
              centerTitle: true,
              //title: textField(),
              bottom: TabBar(
                indicatorColor: Colors.white,
                controller: _tabController,
                labelStyle: const TextStyle(fontSize: 11),
                tabs: const [
                  Tab(text: 'Top', icon: Icon(Icons.trending_up_outlined)),
                  Tab(text: 'Projetos', icon: Icon(Icons.folder, size: 15)),
                  Tab(text: 'Missionários', icon: Icon(Icons.person, size: 15)),
                  Tab(text: 'Igrejas', icon: Icon(Icons.church, size: 15)),
                  Tab(
                      text: 'Doadores',
                      icon: Icon(Icons.monetization_on, size: 15)),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                TopProjects(controller: widget.controller),
                gridSearch(searchhBloc.outProjects,
                    searchhBloc.outProjectsValue, 'project'),
                gridSearch(searchhBloc.outMissionaries,
                    searchhBloc.outMissionariesValue, 'missionary'),
                gridSearch(searchhBloc.outChurchs, searchhBloc.outChurchsValue,
                    'church'),
                gridSearch(
                    searchhBloc.outDonors, searchhBloc.outDonorsValue, 'donor'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget gridSearch(stream, value, category) {
    return RefreshIndicator(
      onRefresh: () async {
        await api.getPageRankProjects(
            'getCategoriesSearch', searchhBloc.outQueryValue);
        await api.getPageRankProjects('getTopProjects', '');
      },
      edgeOffset: 100,
      child: ScrollConfiguration(
        behavior: ScrollConfiguration.of(context).copyWith(
          dragDevices: {
            PointerDeviceKind.touch,
            PointerDeviceKind.mouse,
          },
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              StreamBuilder<List<dynamic>>(
                  stream: stream,
                  initialData: value,
                  builder: (context, snapshot) {
                    if (snapshot.hasData &&
                        searchhBloc.outLoadingValue == false) {
                      if (searchhBloc.outQueryValue != '' &&
                          snapshot.data!.isEmpty) {
                        api.getPageRankProjects('getCategoriesSearch', '');
                        searchhBloc.inQuery.add('');
                      }
                      return snapshot.data!.isEmpty
                          ? noResults(category)
                          : GridView.builder(
                              shrinkWrap: true,
                              padding: const EdgeInsets.all(10.0),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount:
                                    (MediaQuery.of(context).size.width * 0.5) ~/
                                        100,
                                crossAxisSpacing: 5.0,
                                mainAxisSpacing: 5,
                              ),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                return gridCard(snapshot.data![index]);
                              },
                            );
                    }

                    return const Center(
                      child: CircularProgressIndicator(color: Colors.green),
                    );
                  }),
            ],
          ),
        ),
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

  Widget gridCard(data) {
    return GestureDetector(
      onTap: () async {
        final myChurch;
        myChurch = await getMyChurch(data.user);

        final navigator = Navigator.of(context);
        if (myUser!.category == 'church' &&
            profileBloc.outProjectsChurchValue == null) {
        } else {
          final c = data.user.category;
          navigator.push(
            MaterialPageRoute(
              builder: (context) => Scaffold(
                body: c == 'project' || c == 'missionary'
                    ? ProfileProjectPage(
                        myChurch: myChurch,
                        user: data.user,
                        type: getType(data.user.id),
                      )
                    : getNextPage(c, data.user),
              ),
            ),
          );
        }
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.user.username,
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ClipOval(
                    child: Image.asset(
                      'assets/images/projeto.jpg',
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const Divider(
                  thickness: 2,
                ),
                Text(
                  '${getDataName(data.user.category, data)}',
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w700),
                ),
              ]),
        ),
      ),
    );
  }

  getDataName(category, data) {
    switch (category) {
      case 'project':
        return data.name;
      case 'missionary':
        return data.fullName;
      case 'donor':
        return data.fullName;
      case 'church':
        return data.name;
    }
  }

  getType(id) {
    return id == myId ? 'me' : 'other';
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

  Widget noResults(category) {
    return Padding(
      padding: const EdgeInsets.only(top: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            searchhBloc.outQueryValue!.isEmpty
                ? '${getCategory(category)}'
                : 'Não há resultados',
            style: const TextStyle(color: Color.fromARGB(255, 14, 76, 16)),
          ),
        ],
      ),
    );
  }

  getCategory(category) {
    switch (category) {
      case 'project':
        return 'Não há projetos';
      case 'missionary':
        return 'Não há missionários';
      case 'donor':
        return 'Não há doadores';
      case 'church':
        return 'Não há igrejas';
    }
  }
}
