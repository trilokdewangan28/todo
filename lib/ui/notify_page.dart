import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
          icon: Icon(Icons.arrow_back_ios),
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
            color: Get.isDarkMode?Colors.white:Colors.grey[400]
          ),
          child: Center(
            child: Text(
              task_info['task_note'],
              style: TextStyle(
                  color: Get.isDarkMode ? Colors.black : Colors.white,
                fontSize: 30
              ),
            ),
          )
        ),
      )
    );
  }
}
