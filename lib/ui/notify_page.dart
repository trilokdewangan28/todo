import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo/ui/Themes.dart';
class NotifyPage extends StatelessWidget {
  final  task_info;
  const NotifyPage({super.key, required this.task_info});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Get.isDarkMode ? Colors.grey[600] : Colors.white,
        leading: IconButton(
          onPressed: (){
            Get.back();
          },
          icon: const Icon(Icons.arrow_back_ios),
          color: Get.isDarkMode? Colors.white :Colors.grey,
        ),
        title: Text(task_info['task_title']),
      ),
      body: Center(
        child: Container(
          height: 400,
          width: 300,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            color: Get.isDarkMode?primaryColor:primaryColor
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                task_info['task_note'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 30
                ),
              ),
              Text(
                '${task_info['task_startTime']} - ${task_info['task_endTime']}',
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              Text(
                task_info['task_repeat'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
              Text(
                task_info['task_date'],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20
                ),
              ),
            ],
          )
        ),
      )
    );
  }
}
