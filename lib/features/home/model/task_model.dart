import 'package:hive/hive.dart';

part 'task_model.g.dart';

@HiveType(typeId: 0)
class TaskModel {
  @HiveField(0)
  int? id;
  @HiveField(1)
  String title;
  @HiveField(2)
  String description;
  @HiveField(3)
  String category;
  @HiveField(4)
  String date;
  @HiveField(5)
  String startTime;
  @HiveField(6)
  String endTime;

  TaskModel(
      {this.id,
      required this.title,
      required this.description,
      required this.category,
      required this.date,
      required this.startTime,
      required this.endTime});

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
}