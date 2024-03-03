import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';

import 'package:todo/models/task.dart';
import 'package:todo/services/NotificationCreationMethod.dart';

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
  
  String _selectedWantReminder = "No";
  List<String> wantReminder = ['No','Yes'];
  
  int _selectedColorIndex = 0;
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:context.theme.backgroundColor,
      appBar: _appBar(),
      body: Container(
        padding: const EdgeInsets.only(left: 20,right: 20),
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
                  icon: const Icon(Icons.calendar_today_outlined,color: Colors.grey,),
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
                          icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  ),
                  const SizedBox(width: 12,),
                  Expanded(
                      child: MyInputField(
                        title: "End Time",
                        hint: _endTime,
                        widget: IconButton(
                          onPressed: (){
                            _getTimeFromUser(isStartTime: false);
                          },
                          icon: const Icon(Icons.access_time_rounded,color: Colors.grey,),
                        ),
                      )
                  )
                ],
              ),

              //=====================================WANT NOTIFICATION SELECTOR
              MyInputField(
                  title: 'Do you want notification',
                  hint: _selectedWantReminder,
                  widget: DropdownButton(
                    //value: _selectedRemind.toString(),
                    onChanged: (value){
                      setState(() {
                        _selectedWantReminder =value!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
                    iconSize: 32,
                    elevation: 4,
                    underline: Container(),
                    style: subTitleStyle,
                    items: wantReminder.map<DropdownMenuItem<String>>((String value){
                      return DropdownMenuItem<String>(
                          value: value.toString(),
                          child: Text(value.toString())
                      );
                    }).toList(),
                  )
              ),
              
              //=====================================REMIND SELECTOR
             _selectedWantReminder=="Yes" 
                 ? MyInputField(
                title: 'Remind',
                hint: "$_selectedRemind Minute Early",
                widget: DropdownButton(
                  //value: _selectedRemind.toString(),
                  onChanged: (value){
                    setState(() {
                      _selectedRemind = int.parse(value!);
                    });
                  },
                  icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
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
              ) 
                 : Container(),
              
              //=====================================REPEAT SELECTOR
              _selectedWantReminder=="Yes" 
                  ? MyInputField(
                  title: 'Repeat',
                  hint: _selectedRepeat,
                  widget: DropdownButton(
                    //value: _selectedRemind.toString(),
                    onChanged: (value){
                      setState(() {
                        _selectedRepeat = value!;
                      });
                    },
                    icon: const Icon(Icons.keyboard_arrow_down,color: Colors.grey,),
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
              ) 
                  : Container(),
              const SizedBox(height: 18,),
              
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
              ),
              const SizedBox(height: 12,)
            ],
          ),
        )
      ),
    );
  }

  //=====================================ADD TASK TO DB
  Future<int> _addTaskToDb()async{
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
    return value;
  }
  //=====================================INPUT VALIDATOR
  _validateData()async{
     if(_titleController.text.isNotEmpty && _noteController.text.isNotEmpty){
       var value = await _addTaskToDb();
       await _taskController.getTasksById(value);
       final task = _taskController.particularTaskList[0];
       if(value>0){
         // print('date is $_selectedDate');
         // print('time is $_startTime');
         //============================date conversion for notification
         DateTime dateTime = DateTime.parse(_selectedDate.toString());
         int day = dateTime.day;
         int month = dateTime.month;
         int year = dateTime.year;
         int weekday = dateTime.weekday;

         //===================================time conversion for notification
         DateTime time = DateFormat.jm().parse(_startTime.toString());
         var myTime = DateFormat("HH:mm a").format(time);
         int hour = int.parse(myTime.toString().split(":")[0]); // 12
         int minute = int.parse(myTime.toString().split(":")[1].split(" ")[0]); //
         // String amPm = myTime.toString().split(":")[1].split(" ")[1];
         //============================handling the time========================
         int? playHour;
         int? playMinute;
         if(minute>_selectedRemind){
           //15:25 =>(minute-remind)25-5= minute 20
           playHour = hour;
           playMinute = minute-_selectedRemind;
         }
         else{
           //15:03 => (hour-1)15-1=hour 14 && (remind-minute)=2 && (60-2)
           playHour = hour-1;
           int minusMinute = _selectedRemind - minute;
           playMinute = minusMinute!=0 ? 60-minusMinute : 0;
         }
         
         //=================================NOTIFICATION CREATION BASED ON REPEAT
         if(_selectedWantReminder=="Yes"){
           if(_selectedRepeat!="None"){
             if(_selectedRepeat=="Daily"){
               //================================DAILY NOTIFICATION
              // print('daily notification time is $playHour : $playMinute');
               NotificationCreationMethod.raiseScheduledNotification(
                 task: task ,
                 minute:playMinute ,
                 hour:playHour,
               );
             }
             else if(_selectedRepeat=="Weekly"){
               //==================================WEEKLY NOTIFICATION
              // print('weekly notification week is $weekday');
               NotificationCreationMethod.raiseScheduledNotification(
                   task: task,
                   weekDay: weekday,
                   isRepeat: false
               );
             }else if(_selectedRepeat=="Monthly"){
               //==================================MONTHLY NOTIFICATION
              // print('monthly notification date is $day');
               NotificationCreationMethod.raiseScheduledNotification(
                   task: task,
                   day: day,
                   isRepeat: false
               );
             }
           }else{
             //=================================NOTIFICATIOIN FOR SPACIFIC DATE
             //print('exact notification date is  $day:$month:$year');
             NotificationCreationMethod.raiseScheduledNotification(
                 task: task,
                 day: day,
                 month: month,
                 year: year,
                 hour: playHour,
                 minute: playMinute,
                 isRepeat: false
             );
           }
         }
        // print('inserted data id is: $task');
         Get.back();
       }else{
        // print('data not inserted');
         Get.showSnackbar(const GetSnackBar(title: 'something went wrong while adding new task',));
       }
     }else if(_titleController.text.isEmpty || _noteController.text.isEmpty){
       Get.snackbar(
           'Required', 
           "all fields are required",
         snackPosition: SnackPosition.BOTTOM,
         backgroundColor: Colors.white,
         icon: const Icon(Icons.warning_amber_rounded,color: Colors.red,),
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
        const SizedBox(height: 8,),
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
                      padding: const EdgeInsets.only(right: 8),
                      child: CircleAvatar(
                        radius: 14,
                        backgroundColor: index==0?primaryColor : index==1 ? pinkClr : yellowClr,
                        child: _selectedColorIndex==index
                            ? const Icon(Icons.done,color: Colors.white,size: 16,)
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
        child: const Icon(
          Icons.arrow_back_ios,
          size: 20,
        ),
      ),
      backgroundColor: context.theme.backgroundColor,
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 15),
          child: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.png'),
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
     // print('time cancelled');
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
