import 'package:etiqa_test/screen/splash_screen.dart';
import 'package:etiqa_test/screen/todo_list_detail_screen.dart';
import 'package:flutter/material.dart';
import 'package:etiqa_test/screen/todo_list_screen.dart';

class MyRouter extends PageRouteBuilder {
  static const String initialRoute = '/';
  static const String todoListScreenRoute = '/todoListScreen';
  static const String todoListDetailScreenRoute = '/todoListDetailScreen';
  static const String splashScreenRoute = '/splashScreen';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    dynamic args = settings.arguments ?? {};
    switch (settings.name) {
      case initialRoute:
      case splashScreenRoute:
        return FadeAnimationRoute(
          SplashScreen(),
        );
        break;
      case todoListScreenRoute:
        return FadeAnimationRoute(
          TodoListScreen(),
        );
        break;
      case todoListDetailScreenRoute:
        return SlideFadeAnimationRoute(
          TodoListDetailScreen(
              showDetail: args['showDetail'],
              todoDetail: args['todoDetail'],
              ),
          direction: SlideDirection.RightToLeft,
        );
        break;
      default:
        return FadeAnimationRoute(
          TodoListScreen(),
        );
    }
  }
}

enum SlideDirection {
  RightToLeft,
  BottomToTop,
}

class FadeAnimationRoute extends PageRouteBuilder {
  final Widget page;

  FadeAnimationRoute(this.page)
      : super(
            pageBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
            ) =>
                page,
            transitionsBuilder: (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child,
            ) {
              return FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: child,
              );
            });
}

class SlideFadeAnimationRoute extends PageRouteBuilder {
  final Widget page;
  final SlideDirection direction;

  SlideFadeAnimationRoute(
    this.page, {
    this.direction,
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            return SlideTransition(
              position: Tween<Offset>(
                      begin: direction == SlideDirection.RightToLeft
                          ? Offset(1.0, 0.0)
                          : Offset(0.0, 1.0),
                      end: Offset.zero)
                  .animate(animation),
              child: FadeTransition(
                opacity: Tween<double>(begin: 0.0, end: 1.0).animate(animation),
                child: FadeTransition(
                  opacity: Tween<double>(begin: 1.0, end: 0.0)
                      .animate(secondaryAnimation),
                  child: child,
                ),
              ),
            );
          },
        );
}
