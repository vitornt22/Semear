// ignore_for_file: prefer_const_constructors

import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:semear/apis/api_form_validation.dart';
import 'package:semear/apis/api_profile.dart';
import 'package:semear/blocs/profile_bloc.dart';
import 'package:semear/models/user_model.dart';
import 'package:semear/pages/profile/publication_click_page.dart';
import 'package:semear/pages/register/formsFields/city_state_field.dart';
import 'package:semear/pages/register/formsFields/fields_class.dart';
import 'package:transparent_image/transparent_image.dart';

class SavedPublications extends StatefulWidget {
  SavedPublications({super.key, required this.type, required this.user});

  User user;
  String type;

  @override
  State<SavedPublications> createState() => _SavedPublicationsState();
}

class _SavedPublicationsState extends State<SavedPublications> {
  bool checkedValue = true;
  ApiForm apiForm = ApiForm();
  ApiProfile apiProfile = ApiProfile();
  late Future<Map<String, dynamic>> cep;
  final profileBloc = BlocProvider.getBloc<ProfileBloc>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Row(
          children: const [
            Text('Publicações Salvas'),
            SizedBox(width: 5),
            Icon(Icons.edit)
          ],
        ),
      ),
      body: StreamBuilder<Map<int, List<dynamic>>>(
        stream: profileBloc.outSavedPublications,
        initialData: profileBloc.outSavedPublicationValue,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data![widget.user.id] != null) {
              return createPublicationTable(
                  context, snapshot.data![widget.user.id]);
            }
          }
          getSavedPublications();
          return Center(
            child: CircularProgressIndicator(
              color: Colors.green,
            ),
          );
        },
      ),
    );
  }

  Widget createPublicationTable(BuildContext context, snapshot) {
    return Container(
      color: Colors.white,
      child: GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10,
        ),
        itemCount: snapshot.length,
        itemBuilder: (context, index) {
          return GestureDetector(
              child: FadeInImage.memoryNetwork(
                placeholder: kTransparentImage,
                image: snapshot[index].publication.upload!,
                height: 300.0,
                fit: BoxFit.cover,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PublicationClickPage(
                        type: widget.type,
                        publication: snapshot[index].publication),
                  ),
                );
              },
              onLongPress: () {
                //Share.share(snapshot.data["data"][index]["images"]["fixed_height"]
                //["url"]);
              });
        },
      ),
    );
  }

  void getSavedPublications() async {
    apiProfile.getSavedPublications(widget.user.id).then((value) {
      profileBloc.addPublicationSaved(widget.user.id, value);
    });
  }
}
