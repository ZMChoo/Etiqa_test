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
    List<Map<String, dynamic>> data = storage.getItem('todoListKey');
    if (data != null) {
      try {
        List<TodoModel> todoList = data
            .asMap()
            .map((index, x) {
              return MapEntry(index, TodoModel.fromJson(x));
            })
            .values
            .toList();

        todoListNotifier.value = todoList;
      } catch (e) {
        print(e);
      }
    }
  }
}
