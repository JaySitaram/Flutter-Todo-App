import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_application/features/add_task/view/add_task_page.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';

class TaskList extends ConsumerStatefulWidget {
  String section;

  TaskList({required this.section});

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  var taskModelData;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    taskModelData = ref.read(taskProvider);
    print('this is >>');
    taskModelData.loadTasks(widget.section);
  }  

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text('Slide right on any task to update/delete task',
            style: TextStyle(
                fontFamily: "Medium", decoration: TextDecoration.underline)),
        SizedBox(
          height: 15,
        ),
        Divider(),
        SizedBox(
          height: 20,
        ),
        taskModelData.taskModelList.isNotEmpty
            ? ListView.builder(
                itemCount: taskModelData.taskModelList?.length,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Column(
                    children: [
                      //Divider(),
                      TaskTile(
                          task: taskModelData.taskModelList![index],
                          index: index),
                      Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                          child: Divider(
                            color: Colors.purple,
                          )),
                    ],
                  );
                },
              )
            : Center(child: CircularProgressIndicator()),
      ],
    );
  }
}

class TaskTile extends ConsumerWidget {
  final TaskModel task;
  final int index;

  TaskTile({required this.task, required this.index});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Slidable(
      key: Key(task.id.toString()),
      endActionPane: ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit',
            onPressed: (context) {
              final taskProviderData = ref.read(taskProvider);
              taskProviderData.assignTaskItem(task);
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => AddOrEditTaskPage()));
            },
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteConfirmationDialog(context, index);
            },
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: Container(
          margin: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.all(Radius.circular(10))),
          child: ListTile(
            title: Text(
              task.title??'',
              style: TextStyle(fontFamily: "Medium"),
            ),
            subtitle: Text(
                    task.description??'',
                    style: TextStyle(fontFamily: "Regular"),
                  ),
          )),
    );
  }

  Future<void> _showDeleteConfirmationDialog(
      BuildContext context, int? index) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Delete Confirmation', style: TextStyle(fontFamily: "Bold")),
          content: Text('Are you sure you want to delete this item?',
              style: TextStyle(fontFamily: "SemiBold")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('No', style: TextStyle(fontFamily: "Medium")),
            ),
            TextButton(
              onPressed: () async {
                // Perform the delete operation here
                final tasksBox = Hive.box('tasks');
                await tasksBox.deleteAt(0);
                // callback();
                Navigator.of(context).pop();
              },
              child: Text('Yes', style: TextStyle(fontFamily: "Medium")),
            ),
          ],
        );
      },
    );
  }
}
