// ignore_for_file: avoid_unnecessary_containers, avoid_print, prefer_const_constructors, must_be_immutable

import 'package:flutter/material.dart';

class Comments extends StatefulWidget {
  Comments({super.key, required this.focus});
  bool focus;

  @override
  State<Comments> createState() => _CommentsState();
}

class _CommentsState extends State<Comments> {
  TextEditingController addComennt = TextEditingController();
  double heigth = 80;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: FractionallySizedBox(
        heightFactor: 0.97,
        child: Scaffold(
          bottomSheet: bottomSheetComments(),
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
                title: const Text('Comentários'),
                leading: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back)),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    if (index.isEven) {
                      return Padding(
                        padding: const EdgeInsets.all(10),
                        child: ListTile(
                          title: const Text(
                            'Amigos do bem',
                            style: TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: const [
                              Text(
                                  'Olá recebi sua oferdddddddddddddddddddddddddddddddddddddta, muito obrigado!'),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                'Há 4h',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.w400),
                                textAlign: TextAlign.start,
                              )
                            ],
                          ),
                          leading: ClipOval(
                            child: Image.asset(
                              'assets/images/amigos.jpeg',
                              alignment: Alignment.bottomLeft,
                            ),
                          ),
                        ),
                      );
                    }
                    return Divider(height: 0, color: Colors.grey);
                  },
                  childCount: 30,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onChanged(String text) {
    setState(() {
      heigth = text.isEmpty ? 80 : 80 + (text.length / 34) * 15;
    });
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
                  hintText: 'Adicionar Comentário',
                  floatingLabelStyle: TextStyle(color: Colors.black),
                  fillColor: Colors.white,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.black),
                    onPressed: () {},
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
}
