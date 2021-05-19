import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/modules/archived/archived_screen.dart';
import 'package:todo_app/modules/done/done_screen.dart';
import 'package:todo_app/modules/my_tasks/my_tasks_screen.dart';
import 'package:todo_app/shared/cubit/states.dart';

class AppCubit extends Cubit<AppStates> {
  AppCubit() : super(AppInitialState());

  //To create one object once to use every time easily
  //return time is an object of this class
  //static to create one time from the class and no need to get an object first.
  static AppCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List layouts = [
    MyTasksScreen(),
    DoneScreen(),
    ArchivedScreen(),
  ];
  List appBarTitles = [
    'New Tasks',
    'Done Tasks',
    'Archived Tasks',
  ];

  void changeIndex(int value) {
    currentIndex = value;
    emit(AppChangeBottomNavBarState());
  }

  bool isBottomSheetOpened = false;
  void changeBottomSheet(bool value) {
    isBottomSheetOpened = value;
    emit(AppChangeBottomSheetState());
  }

  ///database methods
  List<Map> newTasksList = [];
  List<Map> doneTasksList = [];
  List<Map> archivedTasksList = [];

  Database database;
  void createDatabase() {
    // open the database.. create file.db
    ///delete await
    openDatabase('todo.db', version: 1,
        // the first time database is created
        onCreate: (db, version) async {
      // create the table
      await db
          .execute(
        //creating an empty record
        'CREATE TABLE tasks (id INTEGER PRIMARY KEY, title TEXT, time TEXT, date TEXT, status TEXT, isDone INTEGER)',
      )
          .then((value) {
        print('database is created successfully');
        // emit(AppCreateDatabaseState());
      }).catchError((error) {
        print('error when creating database tables: $error');
      });
    },
        //if data base is already created this method will execute to get data that I already added before.
        onOpen: (db) {
      // Get the record
      getDataFormDatabase(db);
      //     .then((value) {
      //   // fill your list with data that is returned form the future method
      //   ///
      //   // setState(() {
      //   //   tasksList = value;
      //   // });
      //
      //   tasksList = value;
      //   print(tasksList);
      //   emit(AppGetDatabaseState());
      // });
      print('database is opened');
      // emit(AppOpenDatabaseState());
    }).then((value) {
      ///
      database = value;
      emit(AppCreateDatabaseState());
    });
  }

  insertToDatabase({
    @required String title,
    @required String date,
    @required String time,
  }) async {
    // Insert some records in a transaction
    await database.transaction((txn) {
      txn
          .rawInsert(
        'INSERT INTO tasks(title, time, date, status, isDone) VALUES("$title", "$time", "$date", "New", 0 )',
      )
          .then((keyValue) {
        print('$keyValue inserted successfully.');
        emit(AppInsertedDatabaseState());
        //insert then get
        //get new data then pop bottom sheet
        getDataFormDatabase(database);
      }).catchError((error) {
        print('Error in inserting new record: $error');
      });
      return null;
    }).then((db) {});
  }

  // here I use future so that I can use .then and use data that will be returned
  void getDataFormDatabase(db) {
    newTasksList = [];
    doneTasksList = [];
    archivedTasksList = [];
    // Get the records
    db.rawQuery('SELECT * FROM tasks').then((value) {
      value.forEach((element) {
        //todo: refactor these lines

        switch (element['status']) {
          case 'New':
            newTasksList.add(element);
            break;
          case 'Done':
            doneTasksList.add(element);

            break;
          case 'Archived':
            archivedTasksList.add(element);
            break;
        }
      });

      // isBottomSheetOpened = false;
      print('New: $newTasksList');
      print('done: $doneTasksList');
      print('archived: $archivedTasksList');
      emit(AppGetDatabaseState());
    });
  }

  void deleteData({
    @required id,
  }) async {
    // Update some record
    await database
        .rawDelete('DELETE FROM tasks WHERE id = ?', [id]).then((value) {
      getDataFormDatabase(database);
      emit(AppDeleteDatabaseState());
    });
  }

  void updateData({
    @required id,
    @required status,
    @required isDone,
  }) async {
    // Update some record
    await database.rawUpdate(
        'UPDATE tasks SET status = ?, isDone = ? WHERE id = ?',
        [status, isDone, id]).then((value) {
      getDataFormDatabase(database);
      emit(AppUpdateDatabaseState());
    });
  }
}
