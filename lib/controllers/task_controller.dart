import 'package:get/get.dart';
import 'package:todo/db/db_helper.dart';
import 'package:todo/models/task.dart';

class TaskController extends GetxController{
  @override
  void onReady() {
    // TODO: implement onReady
    super.onReady();
  }
  
  var taskList = <Task>[].obs;
  
  //==================================ADDING THE TASK TO DATABASE
  Future<int> addTask({Task? task})async{
    return await DBHelper.insertData(task!);
  }
  
  //=================================GET THE TASK LIST FROM DATABASE
  void getTasks()async{
    List<Map<String,dynamic>> task = await DBHelper.getData();
    taskList.assignAll(task.map((data) => new Task.fromJson(data)).toList());
    print(taskList.toString());
  }

  //=================================GET THE TASK LIST FROM DATABASE
  void deleteTasks(Task task)async{
    await DBHelper.deleteExistingTask(task);
    getTasks();
  }
  
  //=================================MARK TASK COMPLETED
  void markTaskCompleted(int id)async{
    await DBHelper.updateTaskStatus(id);
    getTasks();
  }
  
}