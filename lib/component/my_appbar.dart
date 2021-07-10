import 'package:flutter/material.dart';

class MyAppbar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppbar({
    Key key,
    @required this.title,
    this.showBack = false,
  }) : super(key: key);

  final String title;
  final bool showBack;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AppBar(
      backgroundColor: Colors.yellow[700],
      leading: showBack ? CustomBack() : null,
      centerTitle: false,
      titleSpacing: showBack ? 0 : 15,
      leadingWidth: 38,
      elevation: 0,
      title: Text(
        title,
        style: theme.textTheme.headline6.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class CustomBack extends StatelessWidget {
  const CustomBack({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context).pop();
        },
        child: Padding(
          padding: EdgeInsets.only(right: 10, left: 10),
          child: Icon(
            Icons.chevron_left,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
