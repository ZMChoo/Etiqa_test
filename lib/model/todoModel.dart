import 'package:intl/intl.dart';

class TodoModel {
  String id;
  String title;
  DateTime startDate;
  DateTime estimateEndDate;
  bool isCompleted;


  TodoModel({
    this.id,
    this.title,
    this.startDate,
    this.estimateEndDate,
    this.isCompleted,
  });

  TodoModel.fromJson(Map<String, dynamic> json) {
    try {
      id = json["id"];
      title = json['title'];
      startDate = DateFormat("dd MMM yyyy").parse(json['startDate']);
      estimateEndDate = DateFormat("dd MMM yyyy").parse(json['estimateEndDate']);
      isCompleted = json['isCompleted'];
    } catch (e) {
      print(e);
    }
  }

  String getDate(DateTime date) => DateFormat('dd MMM yyyy').format(date);

  Map<String, dynamic> toJson() {
    final json = {
      "id": id,
      "title": title,
      "startDate": getDate(startDate),
      'estimateEndDate': getDate(estimateEndDate),
      'isCompleted': isCompleted,
    };
    return json;
  }
}