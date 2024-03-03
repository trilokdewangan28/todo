import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:todo/controllers/task_controller.dart';
import 'package:todo/models/task.dart';
import 'package:todo/services/NotificationCreationMethod.dart';
import 'package:todo/services/NotificationServices.dart';
import 'package:todo/services/ThemeServices.dart';
import 'package:todo/ui/AddTaskPage.dart';
import 'package:todo/ui/Themes.dart';
import 'package:todo/ui/widgets/button.dart';

import 'widgets/task_tile.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var notifyHelper;
  final _taskController = Get.put(TaskController());
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    _taskController.getTasks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: context.theme.backgroundColor,
        appBar: _appBar(),
        body: Column(
          children: [
            _addTaskBar(),
            _addDateBar(),
            SizedBox(height: 10,),
            _showTask()
          ],
        ));
  }
  
  
  //======================================SHOW TASK WIDGET
  _showTask(){
    return Expanded(
        child: Obx(
            (){
              return ListView.builder(
                  itemCount: _taskController.taskList.length,
                  itemBuilder: (context,index){
                    Task task = _taskController.taskList[index];
                    //print(task.toJson());
                    if(task.repeat=="Daily"){
                      DateTime date = DateFormat.jm().parse(task.startTime.toString());
                      var myTime = DateFormat("HH:mm a").format(date);
                      int hour = int.parse(myTime.toString().split(":")[0]); // 12
                      int minute = int.parse(myTime.toString().split(":")[1].split(" ")[0]); //
                      String amPm = myTime.toString().split(":")[1].split(" ")[1];
                      int? playHour;
                      int? playMinute;
                      if(minute>task.remind!){
                        //15:25 =>(minute-remind)25-5= minute 20
                        playHour = hour;
                        playMinute = minute-task.remind!;
                      }else{
                        //15:03 => (hour-1)15-1=hour 14 && (remind-minute)=2 && (60-2)
                        playHour = hour-1;
                        int minusMinute = task.remind! - minute;
                        playMinute = minusMinute!=0 ? 60-minusMinute : 0;
                      }
                      print('notification time is $playHour : $playMinute');
                      NotificationCreationMethod.raiseScheduledNotificationDateAndTime(
                          task: task,
                          minute:playMinute ,
                          hour:playHour,
                        isRepeat: true
                      );
                      //1.41
                      return AnimationConfiguration.staggeredList(
                            position: index,
                            child: SlideAnimation(
                              horizontalOffset: 100.0,
                              child: FadeInAnimation(
                                child: Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        _showBottomSheet(context,task);
                                      },
                                      child: TaskTile(task),
                                    )
                                  ],
                                ),
                              ),
                            )
                        );
                    }
                    if(task.date==DateFormat.yMd().format(_selectedDate)){
                      return AnimationConfiguration.staggeredList(
                          position: index,
                          child: SlideAnimation(
                            horizontalOffset: 100.0,
                            child: FadeInAnimation(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: (){
                                      _showBottomSheet(context,task);
                                    },
                                    child: TaskTile(task),
                                  )
                                ],
                              ),
                            ),
                          )
                      );
                    }else{
                      return Container();
                    }
                  }
              );
            }
        )
    );
  }
  
  //=======================================SHOW BOTTOM SHEET
  _showBottomSheet(BuildContext context, Task task){
    return Get.bottomSheet(
        Container(
          width: MediaQuery.of(context).size.width,
          padding: EdgeInsets.only(top: 4),
          height: task.isCompleted==1 ? MediaQuery.of(context).size.height*0.24 : MediaQuery.of(context).size.height*0.32,
          color: Get.isDarkMode? darkGreyClr : Colors.white ,
          child: Column(
            children: [
              Container(
                height: 6,
                width: 120,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300]
                ),
              ),
              Spacer(),
              task.isCompleted==1 
                  ? Container()
                  :_bottomSheetButton(
                  label: "Task Completed", 
                  onTap: (){
                    _taskController.markTaskCompleted(task.id!);
                    Get.back();
                  }, 
                  clr: primaryColor,
                context: context
              ),
              _bottomSheetButton(
                  label: "Delete Task",
                  onTap: (){
                    _taskController.deleteTasks(task);
                    Get.back();
                  },
                  clr: Colors.red[400]!,
                  context: context
              ),
              SizedBox(height: 20,),
              _bottomSheetButton(
                  label: "Close",
                  onTap: (){
                    Get.back();
                  },
                  clr: Colors.red[400]!,
                isClose: true,
                  context: context,
                
              ),
              SizedBox(height: 10,)
            ],
          ),
        )
    );
  } 
  
  //========================================BOTTOM SHEET BUTTON
  _bottomSheetButton({
    required String label,
    required Function()? onTap,
    required Color clr,
    bool isClose=false,
    required BuildContext context
}){
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 4),
        height: 55,
        width: MediaQuery.of(context).size.width*0.9,
        decoration: BoxDecoration(
          color: isClose==true?Colors.transparent : clr,
          border: Border.all(
            width: 2,
            color: isClose==true ? Get.isDarkMode? Colors.grey[600]!:Colors.grey[300]! : clr
          ),
          borderRadius: BorderRadius.circular(20)
        ),
        child: Center(
          child: Text(
              label,
            style: isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  //======================================ADD DATE BAR
  _addDateBar(){
    return Container(
        margin: EdgeInsets.only(top: 20, left: 20),
        child: DatePicker(
          DateTime.now(),
          height: 100,
          width: 80,
          initialSelectedDate: DateTime.now(),
          selectionColor: primaryColor,
          selectedTextColor: Colors.white,
          dateTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
          ),
          dayTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
          ),
          monthTextStyle: GoogleFonts.lato(
            textStyle: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.grey),
          ),
          onDateChange: (date){
            setState(() {
              _selectedDate = date;
            });
          },
        ));
  }
  //=====================================RETURNING ADD TASK BAR
  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd().format(DateTime.now()),
                  style: subHeadingStyle,
                ),
                Text(
                  'Today',
                  style: headingStyle,
                )
              ],
            ),
          ),
          MyButton(label: "+ Add Task", onTap:()async{
           await Get.to(AddTaskPage());
           _taskController.getTasks();
          })
        ],
      ),
    );
  }

  //=====================================RETURNING APPBAR
  _appBar() {
    return AppBar(
      elevation: 0,
      leading: GestureDetector(
        onTap: () {
          ThemeServices().switchTheme();
          NotificationCreationMethod.raiseSimpleNotification(
              title: "Changed theme",
              body: Get.isDarkMode
                  ? "Light Theme Activated"
                  : "Dark Theme Activated");
        },
        child: Icon(
          Get.isDarkMode ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
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
}
