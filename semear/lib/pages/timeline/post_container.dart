// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/apis/api_publication.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/publications_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:semear/pages/register/register_type.dart';
import 'package:semear/pages/timeline/my_post_settings.dart';
import 'package:semear/pages/timeline/post_settings.dart';
import 'package:semear/pages/timeline/comments.dart';
import 'package:semear/widgets/button_filled.dart';

// ignore: must_be_immutable
class PostContainer extends StatefulWidget {
  PostContainer({
    super.key,
    required this.publication,
    required this.index,
    required this.type,
  });

  String type;

  int? index;
  Publication publication;
  @override
  State<PostContainer> createState() => _PostContainerState();
}

class _PostContainerState extends State<PostContainer> {
  final pubBloc = BlocProvider.getBloc<PublicationsBloc>();
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  ApiPublication api = ApiPublication();
  ApiProfile apiProfile = ApiProfile();

  int? myId;
  User? myUser;
  var categoryData;

  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    pubBloc.changeCommentsList(
        widget.publication.id, widget.publication.comments);
    print("INITIAL ID PUB${widget.publication.id}");
    print("INITIAL ID PUB${widget.publication.likes!.length}");
    print("INITIAL ID COMMENT${widget.publication.comments!.length}");
    print("MUDANÇAS : ${widget.publication.likes!.length}");
    pubBloc.toggleNumberLikes(widget.publication);
    pubBloc.toogleNumberComments(widget.publication);
    myId = userBloc.outMyIdValue;
    myUser = userBloc.outUserValue![myId];
    categoryData = userBloc.outCategoryValue![myId];

    print("MYID $myId");
    // widget.publication.likes!.any((element) => element.user== userBloc.outUserValue![myId]!.id)? pubBloc.toggleLabel(widget.publication.id!,  label)
  }

  @override
  Widget build(BuildContext context) {
    api.updatePublication(widget.publication.id).then((value) {
      widget.publication = value!;
      print("WIDGET CHANGES: ${widget.publication.likes!.length}");
      pubBloc.toggleNumberLikes(value);
      pubBloc.toogleNumberComments(widget.publication);
      api
          .getLabel(userBloc.outUserValue![myId]!.id, widget.publication.id)
          .then((value) => pubBloc.toggleLabel(widget.publication.id!, value));
    });
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Divider(),
          headPost(),
          const Divider(),
          const SizedBox(
            height: 4.0,
          ),
          Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              widget.publication.legend!,
            ),
          ),
          const SizedBox(
            height: 4.0,
          ),

          AspectRatio(
            aspectRatio: 1.0 / 1.0,
            child: Image.network(
              widget.publication.upload!,
              fit: BoxFit.cover,
            ),
          ),
          Column(
            children: [
              Container(
                height: 50,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.favorite),
                      SizedBox(width: 5),
                      GestureDetector(
                          child: Row(
                        children: [
                          StreamBuilder<Map<int, int>>(
                              stream: pubBloc.outLikesPublication,
                              initialData: pubBloc.outLikesPublicationValue,
                              builder: (context, snapshot) => snapshot.hasData
                                  ? Text(
                                      '${snapshot.data![widget.publication.id] ?? '0'}')
                                  : CircularProgressIndicator(
                                      color: Colors.green)),
                        ],
                      )),
                      SizedBox(width: 5),
                      Expanded(child: Text('Curtidas')),
                      SizedBox(width: 2),
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            builder: (context) {
                              return Comments(
                                index: widget.index,
                                focus: false,
                                publication: widget.publication,
                              );
                            },
                            routeSettings: RouteSettings(arguments: true),
                            isScrollControlled: true,
                          );
                        },
                        child: Row(
                          children: [
                            StreamBuilder<Map<int, int>>(
                              stream: pubBloc.outCommentsPublication,
                              initialData: pubBloc.outCommentsPublicationValue,
                              builder: (context, snapshot) => snapshot.hasData
                                  ? Text(
                                      '${snapshot.data![widget.publication.id]}')
                                  : CircularProgressIndicator(
                                      color: Colors.green),
                            ),
                            SizedBox(width: 5),
                            Text('Comentários'),
                          ],
                        ),
                      ),
                      SizedBox(width: 20),
                      Row(
                        children: [
                          StreamBuilder<Map<int, int>>(
                              stream: profileBloc.outNumberRecommendations,
                              initialData:
                                  profileBloc.outNumberRecommendationValue,
                              builder: (context, snapshot) {
                                getNumberRecommendation();

                                if (snapshot.hasData) {
                                  if (snapshot
                                          .data![widget.publication.user!.id] !=
                                      null) {
                                    return Text(
                                        '${snapshot.data![widget.publication.user!.id]}');
                                  }
                                }

                                return SizedBox(
                                  width: 10,
                                  height: 10,
                                  child: CircularProgressIndicator(
                                      color: Colors.green),
                                );
                              }),
                          SizedBox(width: 2),
                          Text('indicações'),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Divider(),
              Container(
                height: 70,
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      StreamBuilder<List<dynamic>>(
                        stream: pubBloc.outPublications,
                        initialData: pubBloc.outPublicationsValue,
                        builder: (context, snapshot) => StreamBuilder<bool>(
                          stream: pubBloc.outDisabled,
                          initialData: false,
                          builder: (c, s) => TextButton.icon(
                            onPressed:
                                s.data! || myUser!.category == 'anonymous'
                                    ? null
                                    : () async {
                                        pubBloc.inDisabled.add(true);
                                        final value;
                                        String label = await api.getLabel(
                                            userBloc.outUserValue![myId]!.id,
                                            widget.publication.id);
                                        pubBloc.toggleLabel(
                                            userBloc.outUserValue![myId]!.id!,
                                            label);
                                        //If current user are inside list of like followers
                                        if (label == "Curtir") {
                                          value = await api.setLike(
                                              userBloc.outUserValue![myId]!.id,
                                              widget.publication.id);

                                          label = 'Descurtir';
                                        } else {
                                          print("ENTROU EM TRUE");
                                          value = await api.deleteLike(
                                              userBloc.outUserValue![myId]!.id,
                                              widget.publication.id);
                                          label = 'Curtir';
                                        }
                                        if (value != null) {
                                          print("NEW LISTA ${value.id}");

                                          pubBloc.toggleNumberLikes(value);
                                          pubBloc.toggleLabel(
                                              widget.publication.id!, label);
                                          pubBloc.inDisabled.add(false);

                                          pubBloc.changeListPublication(
                                              widget.index!, value);
                                        }
                                        pubBloc.inDisabled.add(false);
                                      },
                            label: myUser!.category == 'anonymous'
                                ? Text('Curtir')
                                : StreamBuilder<Map<int, String>>(
                                    stream: pubBloc.outLabel,
                                    builder: (context, s) => s.hasData
                                        ? Text(
                                            '${s.data![widget.publication.id]}',
                                            // ignore: use_full_hex_values_for_flutter_colors
                                            style: TextStyle(
                                                color: Color(0xffb23673a)),
                                          )
                                        : CircularProgressIndicator(
                                            color: Colors.green,
                                          ),
                                  ),
                            icon: const Icon(
                              Icons.favorite,
                              // ignore: use_full_hex_values_for_flutter_colors
                              color: Color(0xffb23673a),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {
                            myUser!.category == 'anonymous'
                                ? modalRegister(context)
                                : showModalBottomSheet(
                                    context: context,
                                    builder: (context) {
                                      return Comments(
                                        index: widget.index,
                                        focus: true,
                                        publication: widget.publication,
                                      );
                                    },
                                    isScrollControlled: true,
                                  );
                          },
                          label: const Text(
                            'Comentar',
                            // ignore: use_full_hex_values_for_flutter_colors
                            style: TextStyle(color: Color(0xffb23673a)),
                          ),
                          icon: const Icon(
                            Icons.comment,
                            // ignore: use_full_hex_values_for_flutter_colors
                            color: Color(0xffb23673a),
                          ),
                        ),
                      ),
                      StreamBuilder<Map<int, bool>>(
                        stream: profileBloc.outRecommndation,
                        initialData: profileBloc.outRecommndationValue,
                        builder: (context, snapshot) {
                          checkRecommendation();

                          if (snapshot.hasData) {
                            final idhere = widget.publication.user!.id;
                            final data =
                                snapshot.data![widget.publication.user!.id];

                            if (data == true) {
                              return textButton('Indicado', Icons.check, () {});
                            } else if (data == false) {
                              return textButton(
                                  'Indicar', Icons.recommend, setRecommend);
                            }
                          }

                          return circular();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          Divider()
          //PostStats(),
        ],
      ),
    );
  }

  modalRegister(context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Para ter acesso ao chat é necessárip se registrar'),
        content: Text('Deseja se Registrar?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Não'),
          ),
          TextButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => RegisterType()));
            },
            child: Text('Quero me registrar'),
          )
        ],
      ),
    );
  }

  Widget circular() {
    return SizedBox(
      width: 10,
      height: 10,
      child: CircularProgressIndicator(
        color: Colors.green,
      ),
    );
  }

  setRecommend() async {
    profileBloc.addLoadingRecommendation(widget.publication.user!.id, true);
    await apiProfile
        .setRecommend(myId, widget.publication.user!.id)
        .then((value) {
      profileBloc.addRecommendation(widget.publication.user!.id, value);
      if (value == true) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Projeto indicado'),
          backgroundColor: Colors.green,
        ));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Erro ao indicar indicado'),
          backgroundColor: Colors.redAccent,
        ));
      }
    });
    profileBloc.addLoadingRecommendation(widget.publication.user!.id, false);
  }

  Widget textButton(label, icon, onPressed) {
    profileBloc.addLoadingRecommendation(widget.publication.user!.id, false);
    return StreamBuilder<Map<int, bool>>(
        stream: profileBloc.outLoadingRecommendation,
        initialData: profileBloc.outLoadingRecommendationValue,
        builder: (context, snapshot) {
          return snapshot.data![widget.publication.user!.id] == true
              ? circular()
              : TextButton.icon(
                  onPressed: onPressed,
                  label: Text(label,
                      // ignore: use_full_hex_values_for_flutter_colors
                      style: TextStyle(color: Color(0xffb23673a))),
                  icon: Icon(
                    icon,
                    // ignore: use_full_hex_values_for_flutter_colors
                    color: Color(0xffb23673a),
                  ),
                );
        });
  }

  Widget headPost() {
    return Row(
      children: [
        Padding(
          padding: EdgeInsets.all(10),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: CircleAvatar(
                maxRadius: 30,
                child: getImage(widget.publication.user!.information)),
          ),
        ),
        const SizedBox(
          width: 16,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  GestureDetector(
                    onTap: () async {
                      late final myChurch;
                      await getMyChurch(widget.publication.user)
                          .then((value) => myChurch = value);

                      final navigator = Navigator.of(context);
                      if (myUser!.category == 'church' &&
                          profileBloc.outProjectsChurchValue == null) {
                      } else {
                        addCategoryAndUser(
                            widget.publication.user!.id,
                            widget.publication.user!.category == 'project'
                                ? widget.publication.project
                                : widget.publication.missionary,
                            widget.publication.user);
                        navigator.push(
                          MaterialPageRoute(
                            settings: RouteSettings(),
                            builder: (context) => Scaffold(
                              body: Scaffold(
                                  bottomSheet: Container(
                                    color: Colors.white,
                                    width: double.infinity,
                                    height: 80,
                                    child: ButtonFilled(
                                      text: "Voltar ao  inicio",
                                      onClick: () {
                                        Navigator.of(context).popUntil(
                                            (route) => route.isFirst == true);
                                      },
                                    ),
                                  ),
                                  body: ProfileProjectPage(
                                      myChurch: myChurch,
                                      user: widget.publication.user!,
                                      type: widget.publication.user!.id ==
                                              userBloc.outUserValue![myId]!.id
                                          ? 'me'
                                          : 'other')),
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      widget.publication.user!.username!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                children: [
                  const Icon(
                    Icons.folder,
                    size: 20,
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Expanded(
                    child: Text(
                      widget.publication.createdAt!,
                      maxLines: 10,
                      style: TextStyle(
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
                widget.publication.user!.id == userBloc.outUserValue![myId]!.id
                    ? MyPostSettings(publication: widget.publication)
                    : PostSettings(publication: widget.publication)),
      ],
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

  getImage(information) {
    if (information != null) {
      if (information.photoProfile != null) {
        return Image.network(
          information.photoProfile ??
              'https://cdn-icons-png.flaticon.com/512/149/149071.png',
          fit: BoxFit.fill,
        );
      }
    }

    return Image.asset('assets/images/avatar.png');
  }

  addCategoryAndUser(id, data, user) {
    userBloc.addCategory(id, data);
    userBloc.addUser(user);
  }

  getNumberRecommendation() async {
    final thisId = widget.publication.user!.id;
    await apiProfile
        .getNumberRecommendation(thisId)
        .then((value) => profileBloc.addNumberRecommendations(thisId, value));
  }

  checkRecommendation() async {
    final thisId = widget.publication.user!.id;
    apiProfile
        .checkRecommendation(myId, thisId)
        .then((value) => profileBloc.addRecommendation(thisId, value));
  }
}
