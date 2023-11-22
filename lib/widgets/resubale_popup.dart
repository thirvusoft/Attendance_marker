import 'package:flutter/material.dart';

class PopupWidget extends StatefulWidget {
  final Widget child;
  final String title;
  final String content;

  const PopupWidget({
    Key? key,
    required this.child,
    required this.title,
    required this.content,
  }) : super(key: key);

  @override
  State<PopupWidget> createState() => _PopupWidgetState();
}

class _PopupWidgetState extends State<PopupWidget> {
  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      return Center(
        child: SingleChildScrollView(
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            title: Text(widget.title),
            content: Text(
              widget.content,
              textAlign: TextAlign.left,
            ),
            actions: [widget.child],
          ),
        ),
      );
    });
  }
}
