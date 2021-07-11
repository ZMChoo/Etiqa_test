import 'package:etiqa_test/viewModel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'component/router.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider<TodoViewModel>.value(value: TodoViewModel())
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Notes',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: MyRouter.initialRoute,
      onGenerateRoute: MyRouter.generateRoute,
      debugShowCheckedModeBanner: false,
    );
  }
}
