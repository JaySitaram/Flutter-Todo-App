import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_todo_application/features/add_task/view/add_task_page.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';

class HomePage extends StatefulWidget {
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text('Task Manager'),
          bottom: TabBar(
            controller: tabController,
            tabs: [
              Tab(text: 'Today'),
              Tab(text: 'Tomorrow'),
              Tab(text: 'Upcoming'),
            ],
          )),
      body: TabBarView(
        controller: tabController,
        children: [
          TaskList(section: 'Today'),
          TaskList(section: 'Tomorrow'),
          TaskList(section: 'Upcoming'),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the plus icon tap
          // You can add navigation or any other action here
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddOrEditTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TaskList extends StatefulWidget {
  final String section;

  TaskList({required this.section});

  @override
  _TaskListState createState() => _TaskListState();
}

class _TaskListState extends State<TaskList> {
  // final DatabaseHelper dbHelper = DatabaseHelper.instance;
  // List<Task> tasks = [];

  @override
  void initState() {
    super.initState();
    //  _loadTasks();
  }

  // void _loadTasks() async {
  //   List<Task> loadedTasks = await dbHelper.getTasksBySection(widget.section);
  //   setState(() {
  //     tasks = loadedTasks;
  //   });
  // }

  @override
  Widget build(BuildContext context) {
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
          itemCount: taskList.length,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            return TaskTile(task: taskList[index]);
          },
        ),
      ],
    );
  }
}

class TaskTile extends StatelessWidget {
  final TaskModel task;

  TaskTile({required this.task});

  @override
  Widget build(BuildContext context) {
    return Slidable(
      key: Key(task.id.toString()),
      endActionPane:  ActionPane(
        motion: ScrollMotion(),
        children: [
          SlidableAction(
           // onPressed: (context) {},
            backgroundColor: Color(0xFF7BC043),
            foregroundColor: Colors.white,
            icon: Icons.edit,
            label: 'Edit', onPressed: (context) { 
               Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddOrEditTaskPage(taskModel: task,)));
             },
          ),
          SlidableAction(
            onPressed: (context) {
              
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
}
