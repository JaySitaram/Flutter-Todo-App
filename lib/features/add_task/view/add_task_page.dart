import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';

class AddOrEditTaskPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskProviderData = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task', style: TextStyle(fontFamily: "SemiBold")),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 20,
              ),
              getTextFieldItem('Task Name', 'Enter Task Title',
                  taskProviderData.taskTitleController),
              SizedBox(
                height: 20,
              ),
              Text('Category',
                  style: TextStyle(
                      fontFamily: "Medium",
                      color: Colors.black54,
                      fontSize: 15)),
              SizedBox(height: 5),
              Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.purple)),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      isExpanded: true,
                      onChanged: taskProviderData.selectCategory,
                      value: taskProviderData.selectedCat.isNotEmpty
                          ? taskProviderData.selectedCat
                          : null,
                      items: taskProviderData.categoryItems
                          .map(
                            (e) => DropdownMenuItem<String>(
                              child: Text(
                                e,
                                style: TextStyle(
                                    fontFamily: "Medium", color: Colors.black),
                              ),
                              value: e,
                            ),
                          )
                          .toList(),
                    ),
                  )),
              getTextFieldItem(
                  'Date', 'Enter Date', taskProviderData.dateController,
                  suffixWidget: IconButton(
                    icon: Icon(Icons.calendar_month),
                    onPressed: () {
                      taskProviderData.selectDate(context);
                    },
                  )),
              Row(
                children: [
                  Flexible(
                    child: getTextFieldItem(
                      'Start Time',
                      '--:-- AM/PM',
                      taskProviderData.startTimeController,
                      suffixWidget: IconButton(
                        onPressed: () {
                          taskProviderData.selectTime(context, (value) {
                            taskProviderData.startTimeController.text = value;
                          });
                        },
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Flexible(
                    child: getTextFieldItem(
                      'End Time',
                      '--:-- AM/PM',
                      taskProviderData.endTimeController,
                      suffixWidget: IconButton(
                        onPressed: () {
                          taskProviderData.selectTime(context, (value) {
                            taskProviderData.endTimeController.text = value;
                          });
                        },
                        icon: Icon(Icons.access_time),
                      ),
                    ),
                  ),
                ],
              ),
              getTextFieldItem('Description', 'Enter Task Description',
                  taskProviderData.taskDescController),
              MaterialButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0))),
                elevation: 5.0,
                height: 45,
                color: Colors.purple,
                onPressed: () {
                  taskProviderData.createOrUpdateTask(context);
                },
                minWidth: MediaQuery.of(context).size.width,
                child: Text(
                    taskProviderData.taskModel != null
                        ? 'Update Task'
                        : 'Create Task',
                    style: TextStyle(
                        fontFamily: "SemiBold",
                        color: Colors.white,
                        fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFieldItem(
      String title, String hintText, TextEditingController controller,
      {Widget? suffixWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title,
            style: TextStyle(
                fontFamily: "Medium", color: Colors.black54, fontSize: 15)),
        SizedBox(height: 5),
        TextFormField(
          style: TextStyle(fontFamily: "Medium", color: Colors.black),
          controller: controller,
          decoration: InputDecoration(hintText: hintText, suffix: suffixWidget),
        ),
        SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
