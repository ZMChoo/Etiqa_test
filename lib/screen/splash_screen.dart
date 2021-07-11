import 'package:etiqa_test/component/router.dart';
import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      initSplashScreen();
    });
  }

  void initSplashScreen() {
    Future.delayed(Duration(milliseconds: 1500), () {
      Navigator.of(context).pushNamedAndRemoveUntil(
          MyRouter.todoListScreenRoute, ModalRoute.withName('/'));
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          alignment: Alignment.center,
          child: Text(
            "Flutter Notes",
            style:
                theme.textTheme.headline5.copyWith(fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
