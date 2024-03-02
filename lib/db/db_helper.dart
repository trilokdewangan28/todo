import 'package:sqflite/sqflite.dart';
import 'package:todo/models/task.dart';

class DBHelper{
  static Database? _db;
  static final int _version = 1;
  static final String _tableName = 'task_table';
  static final String _dbName = 'task_db';
  
  //================================INITIALIZE DATABASE
  static Future<void> initDb()async{
    print('init db called for database');
    if(_db!=null){
      return;
    }
    try{
      String _path = await getDatabasesPath()+_dbName;
      _db = await openDatabase(
        _path,
        version: _version,
        onCreate: (db,version){
           createTable(db,version);
        }
      );
    }catch(e){
       print('some error occured while creating database $e');      
    }
  }

  //==================================CREATING TABLE
  static Future createTable(db,version)async{
    print('create table called for database');
    try{
      String sql = 'CREATE TABLE IF NOT EXISTS $_tableName('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, '
          'title STRING, '
          'note TEXT, '
          'date STRING,'
          'startTime STRING,'
          'endTime STRING,'
          'remind INTEGER,'
          'repeat STRING,'
          'color INTEGER, '
          'isCompleted INTEGER'
          ')';
      final result = await db.execute(sql);
      return result;
    }catch(e){
      print('some error occured while creating table $e');
    }
  }
  
  //==================================INSERTING DATA
  static Future<int> insertData(Task task)async{
    print('insert data function called from database');
    if(_db!=null){
      return await _db!.insert(_tableName, task.toJson()); 
    }else{
      initDb();
      return await _db!.insert(_tableName, task.toJson());
    }
    return 1;
  }

  //=================================================DELETE WHOLE EXISTING TABLE
  static Future<dynamic> deleteTable()async{
    print('delete table function called from database');
    final result = await _db!.execute('DROP TABLE IF EXISTS $_tableName');
    return result;
  }

  //=======================================================SHOW TABLES
  static Future<List<dynamic>> showTables()async{
    print('show table method called from database');
    List<Map<String, dynamic>> result = await _db!.rawQuery(
        "SELECT name FROM sqlite_master WHERE type='table' AND name NOT LIKE 'sqlite_%';");
    return result;
  }

  //==========================================================FETCH THE DATA
  static Future<List<Map<String,dynamic>>> getData()async{
    print('get data method called from database');
    final result = await _db!.query('$_tableName',orderBy: 'ID ASC');
    print(result);
    return result;
  }

  //===================================================DELETE DATA BY ID
  static Future<int> deleteExistingTask(Task task)async{
    print('delete task method called from database');
    final result = await _db!.delete('$_tableName',where: 'id=?',whereArgs: [task.id]);
    return result;
  }

  //=========================================================UPDATE THE DATA
  static Future<int> updateTaskStatus(int id)async{
    print('update task status method called from database');
    String sql = '''UPDATE $_tableName SET isCompleted = ? WHERE id = ?''';
    var result = await _db!.rawUpdate(sql,[1,id]);
    print('update task result is $result');
    return result;

  }
  
}