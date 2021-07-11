import 'dart:async';

import 'package:etiqa_test/component/router.dart';
import 'package:etiqa_test/model/todoModel.dart';
import 'package:etiqa_test/viewModel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TodoCard extends StatefulWidget {
  const TodoCard({Key key, @required this.myTodo}) : super(key: key);

  final TodoModel myTodo;

  @override
  _TodoCardState createState() => _TodoCardState();
}

class _TodoCardState extends State<TodoCard> {
  ValueNotifier<int> timeLeftNotifier = ValueNotifier(0);
  Timer _timer;

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    if (now.isBefore(widget.myTodo.estimateEndDate)) {
      int differenceInSeconds =
          widget.myTodo.estimateEndDate.difference(now).inMinutes;

      timeLeftNotifier.value = differenceInSeconds;

      startTimer();
    } else {
      timeLeftNotifier.value = 0;
    }
  }

  void startTimer() {
    _timer = Timer.periodic(Duration(minutes: 1), (timer) {
      if (timeLeftNotifier.value >= 1) {
        timeLeftNotifier.value = timeLeftNotifier.value - 1;
      } else {
        timeLeftNotifier.value = 0;
        _timer.cancel();
      }
    });
  }

  Widget _buildDateTime(
    ThemeData theme,
    String label,
    String value, {
    bool isOverTime = false,
    bool isCompleted = false,
  }) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: theme.textTheme.bodyText1.copyWith(color: Colors.grey),
            textScaleFactor: 0.9,
          ),
          SizedBox(height: 10),
          Text(
            isCompleted
                ? "Completed"
                : isOverTime
                    ? "Overtime"
                    : value,
            style: theme.textTheme.bodyText1.copyWith(
                color: isCompleted
                    ? Colors.green
                    : isOverTime
                        ? Colors.red
                        : Colors.grey),
            textScaleFactor: 0.9,
          ),
        ],
      ),
    );
  }

  String getDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  String getTimeLeft(int minutesLeft) {
    int hour = (minutesLeft / 60).truncate();
    int minutes = minutesLeft - (hour * 60);
    return "$hour hrs $minutes min";
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    TodoViewModel viewModel = Provider.of(context, listen: false);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          Navigator.of(context)
              .pushNamed(MyRouter.todoListDetailScreenRoute, arguments: {
            "todoDetail": widget.myTodo,
            "showDetail": true,
          });
        },
        child: Container(
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.all(Radius.circular(10)),
              boxShadow: [
                BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 3,
                    blurRadius: 10,
                    offset: Offset(0, 3))
              ]),
          child: Column(
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.myTodo.title,
                      style: theme.textTheme.headline6,
                    ),
                    SizedBox(height: 15),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        _buildDateTime(
                          theme,
                          "Start Date",
                          getDate(widget.myTodo.startDate),
                        ),
                        _buildDateTime(
                          theme,
                          "End Date",
                          getDate(widget.myTodo.estimateEndDate),
                        ),
                        ValueListenableBuilder(
                            valueListenable: timeLeftNotifier,
                            builder: (context, int timeLeftInMinutes, child) {
                              return _buildDateTime(
                                theme,
                                "Time Left",
                                getTimeLeft(timeLeftInMinutes),
                                isOverTime: DateTime.now()
                                    .isAfter(widget.myTodo.estimateEndDate),
                                isCompleted: widget.myTodo.isCompleted,
                              );
                            }),
                      ],
                    )
                  ],
                ),
              ),
              Container(
                height: 35,
                padding: EdgeInsets.only(left: 10),
                decoration: BoxDecoration(
                    color: Color(0xffe8e2b7),
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Status",
                          style: theme.textTheme.bodyText1
                              .copyWith(color: Colors.grey),
                          textScaleFactor: 0.9,
                        ),
                        SizedBox(width: 10),
                        Text(
                          widget.myTodo.isCompleted
                              ? "Completed"
                              : "Incomplete",
                          style: theme.textTheme.bodyText1,
                          textScaleFactor: 0.9,
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        viewModel.updateTodoStatus(
                            widget.myTodo.id, !widget.myTodo.isCompleted);
                      },
                      child: Row(
                        children: [
                          Text(
                            widget.myTodo.isCompleted
                                ? "Undo"
                                : "Tick if completed",
                            style: theme.textTheme.bodyText1
                                .copyWith(color: Colors.grey),
                            textScaleFactor: 0.9,
                          ),
                          Transform.scale(
                            scale: 0.85,
                            child: Checkbox(
                                fillColor:
                                    MaterialStateProperty.all(Colors.black),
                                value: widget.myTodo.isCompleted,
                                onChanged: (bool value) {
                                  viewModel.updateTodoStatus(
                                      widget.myTodo.id, value);
                                }),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
