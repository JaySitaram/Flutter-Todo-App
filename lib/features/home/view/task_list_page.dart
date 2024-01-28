import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_application/features/add_task/view/add_task_page.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';

class TaskList extends ConsumerWidget {
  final String section;

  TaskList({required this.section});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final taskModelData = ref.watch(taskProvider);
    taskModelData.loadTasks();
    return Column(
      children: [
        SizedBox(
          height: 20,
        ),
        Text('Slide right on any task to update/delete task'),
        SizedBox(
          height: 20,
        ),
        ListView.builder(
          itemCount: taskModelData.taskModelList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TaskTile(task: taskModelData.taskModelList[index]);
          },
        ),
      ],
    );
  }
}

class TaskTile extends ConsumerWidget {
  final TaskModel task;

  TaskTile({required this.task});

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
              Navigator.of(context).push(MaterialPageRoute(builder: (context) => AddOrEditTaskPage()));
            },
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteConfirmationDialog(context, task.id);
            },
            backgroundColor: Color(0xFF0392CF),
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: 'Delete',
          ),
        ],
      ),
      child: ListTile(
        title: Text(task.title),
        subtitle: task.description.isNotEmpty ? Text(task.description) : null,
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context, String? id) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation'),
          content: Text('Are you sure you want to delete this item?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: Text('No'),
            ),
            TextButton(
              onPressed: () {
                // Perform the delete operation here
                final tasksBox = Hive.box('tasks');
                tasksBox.delete(id);
                Navigator.of(context).pop();
              },
              child: Text('Yes'),
            ),
          ],
        );
      },
    );
  }
}
