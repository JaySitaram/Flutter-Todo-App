import 'package:flutter/material.dart';
import 'package:flutter_todo_application/features/home/model/task_model.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

// ignore: must_be_immutable
class AddOrEditTaskPage extends StatefulWidget {
  TaskModel? taskModel;
  AddOrEditTaskPage({super.key, this.taskModel});

  @override
  State<AddOrEditTaskPage> createState() => _AddOrEditTaskPageState();
}

class _AddOrEditTaskPageState extends State<AddOrEditTaskPage> {
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
  late TextEditingController dateController;
  String selectedCat = '';
   TimeOfDay? selectedTime;
  DateTime selectedDate = DateTime.now();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dateController = TextEditingController(text: selectedDate.toString());
  }

  @override
  Widget build(BuildContext context) {
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
                getTextFieldItem(
                    'Task Name', 'Enter Task Title', taskTitleController),
                Text('Category'),
                SizedBox(height: 5),
                DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                  isExpanded: true,
                  onChanged: (value) {
                    setState(() {
                      selectedCat = value!;
                    });
                  },
                  value: selectedCat.isNotEmpty ? selectedCat : null,
                  items: categoryItems
                      .map((e) => DropdownMenuItem<String>(
                            child: Text(e),
                            value: e,
                          ))
                      .toList(),
                )),
                getTextFieldItem('Date', 'Enter Date', dateController,
                    suffixWidget: IconButton(
                      icon: Icon(Icons.calendar_month),
                      onPressed: () {
                        _selectDate();
                      },
                    )),
                Row(
                  children: [
                    Flexible(
                        child: getTextFieldItem(
                            'Start Time', '--:-- AM/PM', startTimeController,suffixWidget: IconButton(
                              onPressed: (){
                                _selectTime(context, (value){
                                  setState(() {
                                    startTimeController.text=value;
                                  });
                                });
                              },
                              icon: Icon(Icons.access_time)
                            ))),
                    SizedBox(width: 10),
                    Flexible(
                        child: getTextFieldItem(
                            'End Time', '--:-- AM/PM', endTimeController,suffixWidget: IconButton(
                              onPressed: (){
                                 _selectTime(context, (value){
                                  setState(() {
                                     endTimeController.text=value;
                                  });
                                });
                              },
                              icon: Icon(Icons.access_time)
                            )))
                  ],
                ),
                getTextFieldItem(
                    'Description', 'Enter Task Description', taskDescController),
                MaterialButton(
                    color: Colors.blue,
                    onPressed: () {
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
                      tasksBox.put(Uuid().v4(),task.toMap());
                      Navigator.of(context).pop();
                    },
                    minWidth: MediaQuery.of(context).size.width,
                    child: Text(widget.taskModel!=null?'Update Task':'Create Task')),
              ],
            ),
          ),
        ));
  }

   Future<void> _selectTime(BuildContext context,Function(dynamic) callback) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: selectedTime ?? TimeOfDay.now(),
    );

    if (picked != null && picked != selectedTime) {
      setState(() {
        selectedTime = picked;
        callback(picked.format(context));
      });
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  Widget getTextFieldItem(
      String title, String hintText, TextEditingController controller,
      {Widget? suffixWidget}) {
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
