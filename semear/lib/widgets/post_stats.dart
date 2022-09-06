import 'package:flutter/material.dart';

class PostStats extends StatefulWidget {
  const PostStats({super.key});

  @override
  State<PostStats> createState() => _PostStatsState();
}

class _PostStatsState extends State<PostStats> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: const [
            Icon(Icons.favorite),
            SizedBox(
              width: 100,
            ),
            Text(
              "345 curtidas",
              style: TextStyle(color: Colors.grey),
            ),
            Text(
              "100 comentários",
              style: TextStyle(color: Colors.grey),
            ),
            SizedBox(width: 8.0),
            Text(
              "15 indicações",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        const Divider(),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _PostButton(
              icon: Icon(
                Icons.favorite,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Curtir',
              onTap: () {},
            ),
            _PostButton(
              icon: Icon(
                Icons.comment,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Comentar',
              onTap: () {},
            ),
            _PostButton(
              icon: Icon(
                Icons.share,
                color: Colors.grey[600],
                size: 25.0,
              ),
              label: 'Indicar',
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

class _PostButton extends StatelessWidget {
  const _PostButton(
      {required this.icon, required this.label, required this.onTap});
  final Icon icon;
  final String label;
  final Function onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: Colors.green,
      highlightColor: Colors.black,
      focusColor: Colors.green,
      splashColor: Colors.pink,
      onTap: onTap(),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        height: 50,
        child: Row(
          children: [
            icon,
            const SizedBox(
              width: 4.0,
            ),
            Text(
              label,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
