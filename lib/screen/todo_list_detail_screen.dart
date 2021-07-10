import 'package:etiqa_test/component/custom_button.dart';
import 'package:etiqa_test/component/my_appbar.dart';
import 'package:etiqa_test/component/router.dart';
import 'package:etiqa_test/model/todoModel.dart';
import 'package:etiqa_test/viewModel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TodoListDetailScreen extends StatefulWidget {
  TodoListDetailScreen({
    Key key,
    this.todoDetail,
    this.showDetail = false,
  })  : assert(showDetail ? todoDetail != null : todoDetail == null,
            "todoDetail cannot be null"),
        super(key: key);

  final bool showDetail;
  final TodoModel todoDetail;

  @override
  _TodoListDetailScreenState createState() => _TodoListDetailScreenState();
}

class _TodoListDetailScreenState extends State<TodoListDetailScreen> {
  TextEditingController labelController = TextEditingController();

  Widget _buildTitleTextInputField(){
    return Column(
      children: [
        Text("Label"),
        TextFormField()
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TodoViewModel viewModel = Provider.of(context, listen: false);

    return SafeArea(
      child: Scaffold(
        appBar: MyAppbar(
          title:
              widget.showDetail ? "To-Do List Details" : "Add New To-Do List",
          showBack: true,
        ),
        body: LayoutBuilder(
          builder: (context, constraints) => ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: constraints.maxHeight,
              minWidth: constraints.maxWidth,
            ),
            child: IntrinsicHeight(
              child: Stack(
                children: [
                  Container(
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

                        return Column(
                          children: [
                            _buildTitleTextInputField(),
                          ],
                        );
                      },
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: CustomButton(
                      buttonText: widget.showDetail ? "Update" : "Create Now",
                      onPressed: () {
                        print("add new");
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
