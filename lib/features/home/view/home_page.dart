import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_todo_application/features/add_task/view/add_task_page.dart';
import 'package:flutter_todo_application/features/add_task/view_model/task_provider.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:flutter_todo_application/features/home/view/task_list_page.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  List<String> taskDayTitle = ['Today', 'Tomorrow', 'Upcoming'];

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
          title: Text('Task Manager',style: TextStyle(fontFamily: "SemiBold"),),
          bottom: TabBar(
             labelStyle:  TextStyle(fontFamily: "Medium"),
            controller: tabController,
            onTap: (value){
              
            },
            tabs: taskDayTitle.map((e) => Tab(text: e)).toList(),
          )),
      body: TabBarView(
          controller: tabController,
          children: taskDayTitle
              .map((e) => TaskList(
                    section: e,
                  ))
              .toList()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Handle the plus icon tap
          // You can add navigation or any other action here
            final taskProviderData = ref.read(taskProvider);
            taskProviderData.assignTaskItem(TaskModel());
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => AddOrEditTaskPage()));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
