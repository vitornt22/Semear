// ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_const_constructors, must_be_immutable

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_publication.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/blocs/publications_bloc.dart';
import 'package:semear/blocs/user_bloc.dart';
import 'package:semear/models/publication_model.dart';
import 'package:semear/pages/profile/church/church_profile_page.dart';
import 'package:semear/pages/profile/donor/donor_profile_page.dart';
import 'package:semear/pages/profile/project/project_profile_page.dart';
import 'package:path/path.dart';
import 'package:semear/pages/register/register_type.dart';

class Comments extends StatefulWidget {
  Comments(
      {super.key, required this.focus, this.index, required this.publication});
  bool focus;
  int? index;
  Publication publication;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  final userBloc = BlocProvider.getBloc<UserBloc>();
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  final pubBloc = BlocProvider.getBloc<PublicationsBloc>();
  ApiPublication api = ApiPublication();
  int? myId;

  TextEditingController addComennt = TextEditingController();
  double heigth = 80;

  @override
  void initState() {
    super.initState();
    myId = userBloc.outMyIdValue;
    pubBloc.changeCommentsList(
        widget.publication.id, widget.publication.comments);
    //pubBloc.getCommentsPublication(widget.publication.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.97,
        child: Scaffold(
          bottomSheet: userBloc.outUserValue![myId]!.category == 'anonymous'
              ? Expanded(
                  child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => RegisterType()));
                  },
                  child: Text(
                      'Para comentar nas publica????es, ?? necess??rios se registrar'),
                ))
              : bottomSheetComments(),
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                backgroundColor: Colors.white,
                titleTextStyle: const TextStyle(
                    color: Colors.green,
                    fontSize: 20,
                    fontWeight: FontWeight.w700),
                iconTheme: const IconThemeData(color: Colors.green),
                title: const Text('Coment??rios'),
                actions: [
                  IconButton(
                    onPressed: () async {
                      updateComments();
                    },
                    icon: Icon(Icons.update),
                  )
                ],
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              StreamBuilder<Map<int, dynamic>>(
                  stream: pubBloc.outComments,
                  initialData: pubBloc.outCommentsValue,
                  builder: (context, snapshot) {
                    updateComments();
                    return snapshot.hasData
                        ? SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (BuildContext context, int index) {
                                final data = snapshot
                                    .data![widget.publication.id][index];
                                addCategoryDataUser(data.user, data.userData);

                                print(
                                    "OLHA ${snapshot.data![widget.publication.id].length}");
                                int len = snapshot
                                    .data![widget.publication.id].length;
                                if (index <= len) {
                                  return Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      children: [
                                        ListTile(
                                          title: GestureDetector(
                                            onTap: () {
                                              return onTap(data.user, context);
                                            },
                                            child: Text(
                                              snapshot
                                                  .data![widget.publication.id]
                                                      [index]
                                                  .user
                                                  .username!,
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                  '${snapshot.data![widget.publication.id][index].comment}'),
                                              SizedBox(
                                                height: 4,
                                              ),
                                              Text(
                                                'H?? ${snapshot.data![widget.publication.id][index].createdAt}',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontWeight:
                                                        FontWeight.w400),
                                                textAlign: TextAlign.start,
                                              )
                                            ],
                                          ),
                                          trailing: snapshot
                                                      .data![widget.publication
                                                          .id][index]
                                                      .user
                                                      .id ==
                                                  userBloc
                                                      .outUserValue![myId]!.id
                                              ? IconButton(
                                                  onPressed: () async {
                                                    final id = snapshot
                                                        .data![widget
                                                            .publication
                                                            .id][index]
                                                        .id;
                                                    print(
                                                        'ID DO COMENTARIO: ${snapshot.data![widget.publication.id][index].id}');
                                                    final value =
                                                        await api.deleteComment(
                                                            id,
                                                            widget.publication
                                                                .id);
                                                    if (value != null) {
                                                      updateComments();
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBarCommentDeleteSuccess);
                                                    } else {
                                                      ScaffoldMessenger.of(
                                                              context)
                                                          .showSnackBar(
                                                              snackBarCommentDeleteError);
                                                    }
                                                  },
                                                  icon: Icon(Icons.delete))
                                              : null,
                                          leading: ClipOval(
                                            child: widget
                                                        .publication
                                                        .user!
                                                        .information!
                                                        .photoProfile !=
                                                    null
                                                ? Image(
                                                    image: NetworkImage(widget
                                                        .publication
                                                        .user!
                                                        .information!
                                                        .photoProfile!))
                                                : Image.asset(
                                                    'assets/images/avatar.png'),
                                          ),
                                        ),
                                        Divider()
                                      ],
                                    ),
                                  );
                                }
                              },
                              childCount:
                                  snapshot.data![widget.publication.id].length,
                            ),
                          )
                        : Text('N??o h?? coment??rios nessa postagem');
                  }),
              SliverToBoxAdapter(
                child: Container(height: 80),
              )
            ],
          ),
        ),
      ),
    );
  }

  void updateComments() async {
    final lista = await api.updatePublication(widget.publication.id);
    print("LISRAAAA: $lista");
    if (widget.index != null) {
      pubBloc.changeListPublication(widget.index!, lista);
    }
    pubBloc.changeCommentsList(lista!.id, lista.comments);
    pubBloc.toogleNumberComments(lista);
    print("VALOR DE A TESTE: ${pubBloc.outComments}");
  }

  void onTap(user, context) {
    final category = user.category;
    print("CATEGORY $user");
    String type = userBloc.outMyIdValue == user.id ? 'me' : 'other';

    final mapCategory = {
      'church': ChurchProfilePage(first: false, type: type, user: user),
      'project': ProfileProjectPage(
          myChurch: getMyChurch(user), back: false, type: type, user: user),
      'missionary': ProfileProjectPage(myChurch: false, type: type, user: user),
      'donor': DonorProfilePage(
        user: user,
        type: type,
      )
    };
    Navigator.push(
        context,
        MaterialPageRoute(
            settings: RouteSettings(),
            builder: (context) => Scaffold(body: mapCategory[category])));
    print("MAP CATEGORY ${mapCategory[category]}");
  }

  void onChanged(String text) {
    setState(() {
      heigth = text.isEmpty ? 80 : 80 + (text.length / 34) * 15;
    });
  }

  void addCategoryDataUser(user, data) {
    userBloc.addCategory(user.id, data);
    userBloc.addUser(user);
  }

  bool getMyChurch(data) {
    final id = userBloc.outMyIdValue;

    if (userBloc.outUserValue![id]!.category == 'church') {
      return profileBloc.outProjectsChurchValue![id]!.contains(data.id);
    }
    return false;
  }

  Widget bottomSheetComments() {
    return Container(
      height: addComennt.text.isEmpty
          ? 80
          : 80 + (addComennt.text.length / 34) * 15,
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Center(
          child: SizedBox(
            width: double.maxFinite,
            height: heigth,
            child: IntrinsicHeight(
              child: TextField(
                autofocus: widget.focus,
                onChanged: onChanged,
                expands: true,
                controller: addComennt,
                keyboardType: TextInputType.multiline,
                maxLength: 200,
                maxLines: null,
                textAlign: TextAlign.center,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  hintText: 'Adicionar Coment??rio',
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  suffixIcon: StreamBuilder(
                    stream: pubBloc.outLoadingSend,
                    initialData: false,
                    builder: (context, snapshot) => snapshot.data == true
                        ? SizedBox(
                            height: 2,
                            child: CircularProgressIndicator(
                              strokeWidth: 1,
                              color: Colors.green,
                            ),
                          )
                        : IconButton(
                            icon: Icon(Icons.send, color: Colors.black),
                            onPressed: () async {
                              if (addComennt.text.isNotEmpty) {
                                pubBloc.inLoadingComment.add(true);
                                final publication = await api.submitCommment(
                                    addComennt.text,
                                    userBloc.outUserValue![myId]!.id,
                                    widget.publication.id);
                                if (publication != null) {
                                  pubBloc.changeCommentsList(
                                      publication.id, publication.comments);
                                  pubBloc.toogleNumberComments(publication);
                                  addComennt.text = "";
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarSuccess);
                                } else {
                                  ScaffoldMessenger.of(context)
                                      .showSnackBar(snackBarError);
                                }
                                pubBloc.inLoadingComment.add(false);
                              }
                            },
                          ),
                  ),
                  filled: true,
                  focusedBorder: OutlineInputBorder(
                    gapPadding: 5,
                    borderSide: const BorderSide(color: Colors.black),
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  final snackBarSuccess = SnackBar(
    content: Text(
      'Coment??rio publicado!',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.green,
  );

  final snackBarError = SnackBar(
    content: Text(
      'Erro ao publicar',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );

  final snackBarCommentDeleteSuccess = SnackBar(
    content: Text(
      'Coment??rio exclu??do',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.green,
  );

  final snackBarCommentDeleteError = SnackBar(
    content: Text(
      'Erro ao deletar coment??rio',
      textAlign: TextAlign.center,
    ),
    backgroundColor: Colors.redAccent,
  );
}
