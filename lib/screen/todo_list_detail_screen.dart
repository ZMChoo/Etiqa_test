import 'package:etiqa_test/component/custom_button.dart';
import 'package:etiqa_test/component/my_appbar.dart';
import 'package:etiqa_test/model/todoModel.dart';
import 'package:etiqa_test/viewModel/todo_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
  DateTime startDate, endDate;
  ValueNotifier<bool> showErrorNotifier = ValueNotifier(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    if (widget.todoDetail != null) {
      labelController.text = widget.todoDetail.title;
      startDate = widget.todoDetail.startDate;
      endDate = widget.todoDetail.estimateEndDate;
    }
  }

  Widget _buildField(
    ThemeData theme,
    String title, {
    DateTime selectedDate,
    Function onSelectDate,
    bool showError = false,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: theme.textTheme.bodyText1
                .copyWith(color: Colors.grey, fontWeight: FontWeight.w600),
            textScaleFactor: 1.1,
          ),
          SizedBox(height: 10),
          onSelectDate != null
              ? _buildDatePicker(theme, selectedDate, onSelectDate,
                  showError: showError)
              : TextFormField(
                  controller: labelController,
                  maxLines: 8,
                  scrollPhysics: BouncingScrollPhysics(),
                  style: theme.textTheme.bodyText1.copyWith(fontSize: 15),
                  textAlign: TextAlign.left,
                  decoration: InputDecoration(
                      hintText: "Please key in your To-Do title here",
                      hintStyle: theme.textTheme.bodyText1.copyWith(
                          color: Colors.grey.withOpacity(0.6),
                          fontSize: 15,
                          fontWeight: FontWeight.normal),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.zero,
                          borderSide: BorderSide(color: Colors.red)),
                      errorStyle: TextStyle(color: Colors.red, fontSize: 12),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey))),
                  validator: (String value) {
                    return value.isEmpty ? 'This field cannot be empty' : null;
                  },
                )
        ],
      ),
    );
  }

  String getDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Widget _buildDatePicker(
    ThemeData theme,
    DateTime selectedDate,
    Function onSelectDate, {
    bool showError,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
            onTap: onSelectDate,
            child: Container(
              padding: EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  border:
                      Border.all(color: showError ? Colors.red : Colors.grey)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      selectedDate != null
                          ? getDate(selectedDate)
                          : "Select a date",
                      style: theme.textTheme.bodyText1.copyWith(
                          color: selectedDate != null
                              ? Colors.black
                              : Colors.grey.withOpacity(0.6),
                          fontSize: 15,
                          fontWeight: selectedDate != null
                              ? FontWeight.w600
                              : FontWeight.normal),
                    ),
                  ),
                  SizedBox(
                    width: 35,
                    child: Icon(Icons.keyboard_arrow_down_outlined),
                  )
                ],
              ),
            ),
          ),
        ),
        SizedBox(height: 5),
        showError
            ? Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "This field cannot be empty",
                  style: theme.textTheme.bodyText1.copyWith(
                      color: Colors.red,
                      fontWeight: FontWeight.normal,
                      fontSize: 12),
                ),
              )
            : Container()
      ],
    );
  }

  Future<void> onSelectDate(bool isStartDate, {DateTime dateFrom}) async {
    FocusScope.of(context).unfocus();
    DateTime dateTime = await showDatePicker(
        context: context,
        initialDate: isStartDate
            ? startDate ?? DateTime.now()
            : endDate != null
                ? DateTime(endDate.year, endDate.month, endDate.day + 1)
                : startDate != null
                    ? DateTime(
                        startDate.year, startDate.month, startDate.day + 1)
                    : DateTime.now(),
        firstDate: dateFrom != null
            ? DateTime(dateFrom.year, dateFrom.month, dateFrom.day + 1)
            : DateTime.now(),
        lastDate: DateTime(2121),
        builder: (BuildContext context, Widget child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme:
                  ColorScheme.light().copyWith(primary: Colors.yellow[700]),
            ),
            child: child,
          );
        });
    if (dateTime != null) {
      if (isStartDate) {
        setState(() {
          startDate = dateTime;
        });
        if (startDate.compareTo(endDate) >= 0) {
          setState(() {
            endDate = null;
          });
        }
      } else {
        setState(() {
          endDate = dateTime;
        });
      }
    }
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
              child: ValueListenableBuilder(
                  valueListenable: viewModel.isLoadingNotifier,
                  builder: (context, bool isLoading, child) {
                    return Stack(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          width: constraints.maxWidth,
                          height: constraints.maxHeight,
                          child: SingleChildScrollView(
                            physics: BouncingScrollPhysics(),
                            child: Form(
                              key: _formKey,
                              child: ValueListenableBuilder(
                                  valueListenable: showErrorNotifier,
                                  builder: (context, bool showError, child) {
                                    return Column(
                                      children: [
                                        SizedBox(height: 50),
                                        _buildField(theme, "To-Do Title"),
                                        _buildField(
                                          theme,
                                          "Start Date",
                                          selectedDate: startDate,
                                          onSelectDate: () =>
                                              onSelectDate(true),
                                          showError:
                                              showError && startDate == null,
                                        ),
                                        _buildField(
                                          theme,
                                          "Estimated End Date",
                                          selectedDate: endDate,
                                          onSelectDate: () => onSelectDate(
                                              false,
                                              dateFrom: startDate),
                                          showError:
                                              showError && endDate == null,
                                        ),
                                        SizedBox(height: 70),
                                      ],
                                    );
                                  }),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CustomButton(
                            buttonText:
                                widget.showDetail ? "Update" : "Create Now",
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                if (startDate != null && endDate != null) {
                                  if (widget.showDetail) {
                                    await viewModel
                                        .updateTodoList(
                                          widget.todoDetail.id,
                                          labelController.text,
                                          startDate,
                                          endDate,
                                          widget.todoDetail.isCompleted,
                                        )
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                  } else {
                                    await viewModel
                                        .insertTodoList(
                                          labelController.text,
                                          startDate,
                                          endDate,
                                        )
                                        .then((value) =>
                                            Navigator.of(context).pop());
                                  }
                                } else {
                                  showErrorNotifier.value = true;
                                }
                              } else {
                                showErrorNotifier.value = true;
                              }
                            },
                          ),
                        ),
                        isLoading
                            ? Container(
                                height: constraints.maxHeight,
                                width: constraints.maxWidth,
                                color: Colors.grey.withOpacity(0.5),
                                alignment: Alignment.center,
                                child: CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.black),
                                  strokeWidth: 3,
                                ),
                              )
                            : Container()
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }
}
