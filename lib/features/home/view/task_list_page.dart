import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_application/features/add_task/view/add_task_page.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';

class TaskList extends ConsumerStatefulWidget {
  final String section;
  final List<TaskModel> taskList;

  TaskList({required this.section, required this.taskList});

  @override
  ConsumerState<TaskList> createState() => _TaskListState();
}

class _TaskListState extends ConsumerState<TaskList> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
        Text('Slide right on any task to update/delete task',
            style: TextStyle(fontFamily: "Medium", decoration: TextDecoration.underline)),
        SizedBox(height: 15),
        Divider(),
        SizedBox(height: 20),
        widget.taskList.isNotEmpty
            ? Expanded(
                child: ListView.separated(
                  itemCount: widget.taskList.length,
                  separatorBuilder: (context, index) => Divider(color: Colors.purple),
                  itemBuilder: (context, index) {
                    return TaskTile(
                      task: widget.taskList[index],
                      index: index,
                    );
                  },
                ),
              )
            : Center(child: Text('No task here showing')),
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
            onPressed: (context) async {
              final taskProviderData = ref.read(taskProvider);
              taskProviderData.assignTaskItem(task);
              await Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => AddOrEditTaskPage()),
              );
            },
          ),
          SlidableAction(
            onPressed: (context) {
              _showDeleteConfirmationDialog(context);
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
          borderRadius: BorderRadius.all(Radius.circular(10)),
        ),
        child: ListTile(
          title: Text(task.title ?? '', style: TextStyle(fontFamily: "Medium")),
          subtitle: Text(task.description ?? '', style: TextStyle(fontFamily: "Regular")),
        ),
      ),
    );
  }

  Future<void> _showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Confirmation', style: TextStyle(fontFamily: "Bold")),
          content: Text('Are you sure you want to delete this item?', style: TextStyle(fontFamily: "SemiBold")),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('No', style: TextStyle(fontFamily: "Medium")),
            ),
            TextButton(
              onPressed: () async {
                // Perform the delete operation here
                final tasksBox = Hive.box('tasks');
                await tasksBox.deleteAt(index);
            
                Navigator.of(context).pop();
              },
              child: const Text('Yes', style: TextStyle(fontFamily: "Medium")),
            ),
          ],
        );
      },
    );
  }
}
