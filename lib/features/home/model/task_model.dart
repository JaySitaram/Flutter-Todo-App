import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  String? id;
  @HiveField(1)
  String? title;
  @HiveField(2)
  String? description;
  @HiveField(3)
  String? category;
  @HiveField(4)
  String? date;
  @HiveField(5)
  String? startTime;
  @HiveField(6)
  String? endTime;

  TaskModel(
      {this.id,
      this.title,
      this.description,
      this.category,
      this.date,
      this.startTime,
      this.endTime});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'category': category,
      'date': date,
      'startTime': startTime,
      'endTime': endTime
    };
  }

  factory TaskModel.fromJson(Map<dynamic, dynamic> map) {
    return TaskModel(
        id: map['id'],
        title: map['title'],
        description: map['description'],
        category: map['category'],
        date: map['date'],
        startTime: map['startTime'],
        endTime: map['endTime']);
  }
}
