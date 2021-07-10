import 'package:etiqa_test/component/my_appbar.dart';
import 'package:etiqa_test/component/router.dart';
import 'package:etiqa_test/model/todoModel.dart';
import 'package:etiqa_test/viewModel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoListScreen extends StatefulWidget {
  const TodoListScreen({Key key}) : super(key: key);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState extends State<TodoListScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      TodoViewModel todoViewModel = Provider.of(context, listen: false);
      todoViewModel.init();
    });
  }

  Future<void> getMyTodoList() async {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(
          title: "To-Do List",
        ),
        body: Consumer<TodoViewModel>(
            builder: (context, TodoViewModel viewModel, child) {
          return LayoutBuilder(
            builder: (context, constraints) => ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: IntrinsicHeight(
                child: Container(
                  width: constraints.maxWidth,
                  height: constraints.maxHeight,
                  child: ValueListenableBuilder(
                    valueListenable: viewModel.isLoadingNotifier,
                    builder: (context, bool isLoading, child) {
                      if (isLoading) {
                        return Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.black),
                            strokeWidth: 3,
                          ),
                        );
                      }

                      return ValueListenableBuilder(
                          valueListenable: viewModel.todoListNotifier,
                          builder: (context, List<TodoModel> todoList, child) {
                            if (todoList.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.article_outlined,
                                      size: 50,
                                      color: Colors.grey.withOpacity(0.7),
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      "Your To-Do List is empty",
                                      style: theme.textTheme.headline6
                                          .copyWith(color: Colors.grey),
                                      textScaleFactor: 0.9,
                                    ),
                                  ],
                                ),
                              );
                            }

                            return Container();
                          });
                    },
                  ),
                ),
              ),
            ),
          );
        }),
        floatingActionButton: Align(
          alignment: Alignment(0, 0.95),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              onTap: () {
                Navigator.of(context)
                    .pushNamed(MyRouter.todoListDetailScreenRoute, arguments: {
                  "showDetail": false,
                });
              },
              child: Container(
                margin: EdgeInsets.only(left: 30),
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(50)),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.grey.withOpacity(1), blurRadius: 15)
                    ],
                    color: Colors.orange[800]),
                child: Icon(
                  Icons.add,
                  size: 28,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
