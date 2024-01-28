import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

final taskProvider = ChangeNotifierProvider<TaskProvider>((ref) {
  return TaskProvider();
});

class TaskProvider extends ChangeNotifier {
  TaskModel? taskModel;
  TextEditingController taskTitleController = TextEditingController();
  TextEditingController taskDescController = TextEditingController();
  List<String> categoryItems = [
    'Design',
    'Development',
    'Research',
    'Resources',
    'Supports'
  ];
  TextEditingController startTimeController = TextEditingController();
  TextEditingController endTimeController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  String selectedCat = '';
  TimeOfDay? selectedTime;
  DateTime selectedDate = DateTime.now();
  List<TaskModel> todayTaskList = [];
  bool isUpdate = false;
  List<TaskModel> tomorrowTaskList = [];
  List<TaskModel> upcomingTaskList = [];

  void selectCategory(String? value) {
    selectedCat = value!;
    notifyListeners();
  }

  Future<void> loadTasks(String section) async {
    final tasksBox = await Hive.openBox('tasks');
    List taskList = tasksBox.values.toList();
    todayTaskList.clear();
    tomorrowTaskList.clear();
    upcomingTaskList.clear();
    for (var item in taskList) {
      print('this is >> ${item['date']} ${item}');
      TaskModel taskItem = TaskModel.fromJson(item);
      if (taskItem.date == DateFormat('d MMM yyyy').format(DateTime.now())) {
         todayTaskList.add(taskItem);
      }
      else if (taskItem.date ==
          DateFormat('d MMM yyyy')
              .format(DateTime.now().add(Duration(days: 1)))) {
        if (!tomorrowTaskList.contains(taskItem)) {
          tomorrowTaskList.add(taskItem);
        }
      } else {
        if (!upcomingTaskList.contains(taskItem)) {
          upcomingTaskList.add(taskItem);
        }
      }
    }
    print('this is >> ${todayTaskList} ${tomorrowTaskList}');
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      selectedDate = picked;
      DateTime dateOnly = DateTime(picked.year, picked.month, picked.day);

      dateController.text =
          DateFormat('d MMM yyyy').format(dateOnly).toString();
      notifyListeners();
    }
  }

  void createOrUpdateTask(BuildContext context) {
    if (taskModel?.id!=null) {
      final tasksBox = Hive.box('tasks');
      taskModel?.title = taskTitleController.text;
      taskModel?.description = taskDescController.text;
      taskModel?.category = selectedCat;
      taskModel?.date = dateController.text;
      taskModel?.startTime = startTimeController.text;
      taskModel?.endTime = endTimeController.text;
      List itemList=tasksBox.values.toList();
      for(int i=0;i<itemList.length;i++){
        if(itemList[i]['id']==taskModel?.id){
          tasksBox.putAt(i, taskModel?.toMap());
        }
      }
      Navigator.of(context).pop();
    } else {
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
  }

  void assignTaskItem(TaskModel task) {
    dateController.text = task.date ?? '';
    startTimeController.text = task.startTime ?? '';
    endTimeController.text = task.endTime ?? '';
    taskDescController.text = task.description ?? '';
    selectedCat = task.category ?? '';
    taskModel = task;
    taskTitleController.text = task.title ?? '';
    notifyListeners();
  }
}
