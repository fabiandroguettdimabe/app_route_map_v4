import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';

class AppBarWidget extends StatelessWidget {
  final String message;

  const AppBarWidget({Key? key, required this.message}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GFAppBar(
      title: GFListTile(
        title: AutoSizeText(message),
      ),
    );
  }
}
