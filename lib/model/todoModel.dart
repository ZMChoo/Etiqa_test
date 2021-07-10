class TodoModel {
  String title;
  String startDate;
  String estimateEndDate;
  bool isCompleted;


  TodoModel({
    this.title,
    this.startDate,
    this.estimateEndDate,
    this.isCompleted,
  });

  TodoModel.fromJson(Map<String, dynamic> json) {
    try {
      title = json['title'];
      startDate = json['startDate'];
      estimateEndDate = json['estimateEndDate'];
      isCompleted = json['isCompleted'];
    } catch (e) {
      print(e);
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "title": title,
      "startDate": startDate,
      'estimateEndDate': estimateEndDate,
      'isCompleted': isCompleted,
    };
  }
}