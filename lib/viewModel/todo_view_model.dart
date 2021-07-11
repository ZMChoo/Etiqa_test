import 'package:etiqa_test/model/todoModel.dart';
import 'package:flutter/cupertino.dart';
import 'package:localstorage/localstorage.dart';

class TodoViewModel extends ChangeNotifier {
  ValueNotifier<bool> isLoadingNotifier = ValueNotifier(false);
  ValueNotifier<List<TodoModel>> todoListNotifier = ValueNotifier([]);
  LocalStorage storage = LocalStorage('myStorage');

  Future<void> init() async {
    await getMyTodoList();
  }

  Future<void> getMyTodoList() async {
    await storage.ready;
    List<dynamic> data = storage.getItem('todoListKey');
    if (data != null) {
      List<TodoModel> todoList = data
          .asMap()
          .map((index, x) {
            return MapEntry(index, TodoModel.fromJson(x));
          })
          .values
          .toList();

      todoListNotifier.value = todoList;
    }
  }

  Future<void> insertTodoList(
    String title,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      TodoModel newTodo = TodoModel(
        id: "$title-${startDate.toIso8601String()}",
        title: title,
        startDate: startDate,
        estimateEndDate: endDate,
        isCompleted: false,
      );

      isLoadingNotifier.value = true;
      isLoadingNotifier.notifyListeners();

      todoListNotifier.value.add(newTodo);

      await storage.ready;
      await storage.setItem(
          "todoListKey",
          todoListNotifier.value
              .asMap()
              .map((key, value) => MapEntry(key, value.toJson()))
              .values
              .toList());

      todoListNotifier.notifyListeners();
      isLoadingNotifier.value = false;
      isLoadingNotifier.notifyListeners();
    } catch (e) {
      print(e);
      isLoadingNotifier.value = false;
      isLoadingNotifier.notifyListeners();
    }
  }

  Future<void> updateTodoList(String id, String title, DateTime startDate,
      DateTime endDate, bool isComplete) async {
    try {
      TodoModel newTodo = TodoModel(
        id: id,
        title: title,
        startDate: startDate,
        estimateEndDate: endDate,
        isCompleted: isComplete,
      );

      isLoadingNotifier.value = true;
      isLoadingNotifier.notifyListeners();

      int index =
          todoListNotifier.value.indexWhere((element) => element.id == id);
      todoListNotifier.value[index] = newTodo;

      await storage.ready;
      await storage.setItem(
          "todoListKey",
          todoListNotifier.value
              .asMap()
              .map((key, value) => MapEntry(key, value.toJson()))
              .values
              .toList());

      todoListNotifier.notifyListeners();
      isLoadingNotifier.value = false;
      isLoadingNotifier.notifyListeners();
    } catch (e) {
      print(e);
      isLoadingNotifier.value = false;
      isLoadingNotifier.notifyListeners();
    }
  }

  void updateTodoStatus(String id, bool status) {
    int index =
        todoListNotifier.value.indexWhere((element) => element.id == id);
    todoListNotifier.value[index].isCompleted = status;
    todoListNotifier.notifyListeners();
  }
}
