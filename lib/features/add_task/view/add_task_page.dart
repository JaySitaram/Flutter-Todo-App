import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';

class AddOrEditTaskPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final taskProviderData = ref.watch(taskProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Task'),
      ),
      body: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              getTextFieldItem('Task Name', 'Enter Task Title', taskProviderData.taskTitleController),
              Text('Category'),
              SizedBox(height: 5),
              DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  isExpanded: true,
                  onChanged: taskProviderData.selectCategory,
                  value: taskProviderData.selectedCat.isNotEmpty ? taskProviderData.selectedCat : null,
                  items: taskProviderData.categoryItems
                      .map(
                        (e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
              getTextFieldItem('Date', 'Enter Date', taskProviderData.dateController, suffixWidget: IconButton(
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
              getTextFieldItem('Description', 'Enter Task Description', taskProviderData.taskDescController),
              MaterialButton(
                color: Colors.blue,
                onPressed: () {
                  taskProviderData.createOrUpdateTask(context);
                },
                minWidth: MediaQuery.of(context).size.width,
                child: Text(taskProviderData.taskModel != null ? 'Update Task' : 'Create Task'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget getTextFieldItem(String title, String hintText, TextEditingController controller, {Widget? suffixWidget}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title),
        SizedBox(height: 5),
        TextFormField(
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
