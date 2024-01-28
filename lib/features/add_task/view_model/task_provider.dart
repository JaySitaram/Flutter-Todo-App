import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

final taskProvider = ChangeNotifierProvider<TaskProvider>((ref) {
  return TaskProvider();
});

class TaskProvider extends ChangeNotifier {
  TaskModel? taskModel;
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  List<String> categoryItems = ['Design', 'Development', 'Research', 'Resources', 'Supports'];
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String selectedCat = '';
  TimeOfDay? selectedTime;
  DateTime selectedDate = DateTime.now();
  late List<TaskModel> taskModelList;

  void selectCategory(String? value) {
    selectedCat = value!;
    notifyListeners();
  }

  Future<void> loadTasks() async {
    final tasksBox = await Hive.openBox('tasks');
    List taskList = tasksBox.values.toList();
    taskModelList = taskList.map((e) => TaskModel.fromJson(e)).toList();
    notifyListeners();
  }

  void selectTime(BuildContext context, Function(dynamic) callback) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      selectedTime = picked;
      callback(picked.format(context));
      notifyListeners();
    }
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      dateController.text = picked.toString();
      notifyListeners();
    }
  }

  void createOrUpdateTask(BuildContext context) {
    TaskModel task = TaskModel(
      id: Uuid().v4(),
      title: taskTitleController.text,
      description: taskDescController.text,
      category: selectedCat,
      date: dateController.text,
      startTime: startTimeController.text,
      endTime: endTimeController.text,
    );

    final tasksBox = Hive.box('tasks');
    tasksBox.put(Uuid().v4(), task.toMap());
    Navigator.of(context).pop();
  }

  void assignTaskItem(TaskModel task) {
    dateController.text=task.date;
    startTimeController.text=task.startTime;
    endTimeController.text=task.endTime;
    taskDescController.text=task.description;
    selectedCat=task.category;
    taskTitleController.text=task.title;
    notifyListeners();
  }
}