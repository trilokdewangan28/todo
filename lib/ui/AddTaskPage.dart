import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/NotificationServices.dart';
import 'package:todo/services/ThemeServices.dart';
import 'package:todo/ui/Themes.dart';
import 'package:todo/ui/widgets/button.dart';
import 'package:todo/ui/widgets/input_field.dart';
class AddTaskPage extends StatefulWidget {
  const AddTaskPage({super.key});

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final TaskController _taskController = Get.put(TaskController());
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  DateTime _selectedDate = DateTime.now();
  String _startTime = DateFormat("hh:mm a").format(DateTime.now()).toString();
  String _endTime = "9:30 PM";
  
  int _selectedRemind = 5;
  List<int> remindList = [5,10,15,20];

  String _selectedRepeat = "None";
  List<String> repeatList = ['None','Daily','Weekly','Monthly'];
  
  int _selectedColorIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: EdgeInsets.only(left: 20,right: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //====================================ADD TASK TEXT HEADING
              Text(
                "Add Task",
                style: headingStyle,
              ),
              
              //====================================TITLE TEXTFIELD
              MyInputField(title: 'Title', hint: 'Enter Your Title',controller: _titleController,),
              
              //====================================NOTE TEXTFIELD
              MyInputField(title: 'Note', hint: 'Enter Your Note5',controller: _noteController,),
              
              //=====================================DATE PICKER
              MyInputField(
                  title: 'Date', 
                  hint: DateFormat.yMMMd().format(_selectedDate),
                widget: IconButton(
                  onPressed: (){
                    _getDateFromUser();
                  },
                  icon: Icon(Icons.calendar_today_outlined,color: Colors.grey,),
                ),
              ),
              
              //=====================================TIME PICKER
              Row(
                children: [
                  Expanded(
                      child: MyInputField(
                        title: "Start Time",
                        hint: _startTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime: true);
                          },
                          icon: Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  ),
                  SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  )
                ],
              ),
              
              //=====================================REMIND SELECTOR
              MyInputField(
                title: 'Remind',
                hint: "$_selectedRemind Minute Early",
                widget: DropdownButton(
                  //value: _selectedRemind.toString(),
                  onChanged: (value){
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                  icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                  iconSize: 32,
                  elevation: 4,
                  underline: Container(),
                  style: subTitleStyle,
                  items: remindList.map<DropdownMenuItem<String>>((int value){
                    return DropdownMenuItem<String>(
                      value: value.toString(),
                        child: Text(value.toString())
                    );
                  }).toList(),
                )
              ),
              
              //=====================================REPEAT SELECTOR
              MyInputField(
                  title: 'Repeat',
                  hint: "$_selectedRepeat",
                  widget: DropdownButton(
                    //value: _selectedRemind.toString(),
                    onChanged: (value){
                      setState(() {
                        _selectedRepeat = value!;
                      });
                    },
                    icon: Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(),
                    style: subTitleStyle,
                    items: repeatList.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString())
                      );
                    }).toList(),
                  )
              ),
              SizedBox(height: 18,),
              
              //=====================================CREATE TASK BTN AND PRIORITY SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //===========================COLOR SELECTOR
                  _colorPallate(),
                  //===========================CREATE TASK BUTTON
                  MyButton(label: "Create Task", onTap: _validateData)
                  
                ],
              )
            ],
          ),
        )
      ),
    );
  }

  //=====================================ADD TASK TO DB
  _addTaskToDb()async{
    var value = await _taskController.addTask(
      task:Task(
        title: _titleController.text,
        note: _noteController.text,
        date: DateFormat.yMd().format(_selectedDate),
        startTime: _startTime,
        endTime: _endTime,
        remind: _selectedRemind,
        repeat: _selectedRepeat,
        color: _selectedColorIndex,
        isCompleted: 0,
      ) 
    );
    //var value = await DBHelper.deleteTable();
    //var value = await DBHelper.showTables();
    print('inserted data id is: $value');
  }
  //=====================================INPUT VALIDATOR
  _validateData(){
     if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
       _addTaskToDb();
       Get.back();
     }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
       Get.snackbar(
           'Required', 
           "all fields are required",
         snackPosition: SnackPosition.BOTTOM,
         backgroundColor: Colors.white,
         icon: Icon(Icons.warning_amber_rounded,color: Colors.red,),
         colorText: pinkClr
       );
     }
  }
  //=====================================COLOR PALLATE SELECTOR
  _colorPallate(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Color',style: titleStyle,),
        SizedBox(height: 8,),
        //===========================COLOR SELECTOR
        Wrap(
            children: List<Widget>.generate(
                3,
                    (int index){
                  return GestureDetector(
                    onTap: (){
                      setState(() {
                        _selectedColorIndex = index;
                      });
                    },
                    child:  Padding(
                      padding: EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index==0?primaryColor : index==1 ? pinkClr : yellowClr,
                        child: _selectedColorIndex==index
                            ? Icon(Icons.done,color: Colors.white,size: 16,)
                            :Container(),
                      ),
                    ),
                  );
                }
            )
        )
      ],
    );
  }
  //=====================================RETURNING APPBAR
  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          Get.back();
        },
        child: Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      backgroundColor: context.theme.backgroundColor,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 15),
          child: CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpg'),
          ),
        )
      ],
    );
  }
  
  //=====================================DATE PICKER
  _getDateFromUser()async{
    DateTime? _pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024), 
        lastDate: DateTime(2030)
    );
    if(_pickerDate!=null){
      setState(() {
        _selectedDate = _pickerDate;
      });
    }
  }
  
  //=====================================TIME PICKERR
  _getTimeFromUser({required bool isStartTime})async{
    TimeOfDay pickedTime = await _showTimePicker();
    String _formatedTime = pickedTime.format(context);
    if(pickedTime==null){
      print('time cancelled');
    }else if(isStartTime==true){
      setState(() {
        _startTime=_formatedTime;
      });
    }else if(isStartTime==false){
      setState(() {
        _endTime=_formatedTime;
      });
    }
  }
  _showTimePicker(){
    return  showTimePicker(
        context: context,
        initialEntryMode: TimePickerEntryMode.input,
        initialTime: TimeOfDay(
            hour: int.parse(_startTime.split(":")[0]), 
            minute: int.parse(_startTime.split(":")[1].split(" ")[0]),
        )
    );
  }
}
