import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo_app/shared/components/components.dart';
import 'package:todo_app/shared/components/constants.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/cubit/states.dart';
import 'package:todo_app/shared/styles/colors.dart';

class ControlScreen extends StatelessWidget {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  var _formKey = GlobalKey<FormState>();

  final titleController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();

  // @override
  // void initState() {
  //   // TODO: implement initState
  //   super.initState();
  //   createDatabase();
  // }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return BlocProvider(
      create: (BuildContext context) => AppCubit()..createDatabase(),
      child: BlocConsumer<AppCubit, AppStates>(listener: (context, state) {
        if (state is AppInsertedDatabaseState) Navigator.pop(context);
      }, builder: (context, state) {
        AppCubit cubit = AppCubit.get(context);
        return Scaffold(
          key: _scaffoldKey,
          bottomNavigationBar: Theme(
            data: Theme.of(context).copyWith(
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                  backgroundColor: Color(0xff292e4e),
                  unselectedItemColor: Colors.white54,
                  selectedItemColor: Colors.white),
              // textTheme: Theme.of(context)
              //     .textTheme
              //     .copyWith(caption: TextStyle(color: Colors.yellowAccent)),
            ),
            child: BottomNavigationBar(
              currentIndex: cubit.currentIndex,
              onTap: (index) {
                if (index != 3) cubit.changeIndex(index);
              },
              type: BottomNavigationBarType.fixed,
              items: bottomNavigationBarList(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            backgroundColor: primaryColor,
            child: Icon(
              cubit.isBottomSheetOpened ? Icons.add : Icons.edit,
              color: Colors.white,
            ),
            onPressed: () {
              if (cubit.isBottomSheetOpened) {
                if (_formKey.currentState.validate()) {
                  cubit.insertToDatabase(
                    title: titleController.text,
                    date: dateController.text,
                    time: timeController.text,
                  );

                }
              } else {
                _scaffoldKey.currentState
                    .showBottomSheet(
                        (context) => Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Form(
                                key: _formKey,
                                child: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      defaultTextForm(
                                        icon: Icons.title,
                                        labelText: 'Task title',
                                        controller: titleController,
                                        keyboardType: TextInputType.text,
                                        validator: (String value) {
                                          if (value.isEmpty) {
                                            return 'Task title must not be empty.';
                                          }
                                          return null;
                                        },
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //to close keyboard if opened
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          showTimePicker(
                                                  context: context,
                                                  initialTime: TimeOfDay.now())
                                              .then((value) {
                                            if (value != null) {
                                              timeController.text =
                                                  value.format(context);
                                            }
                                          });
                                        },
                                        child: defaultTextForm(
                                          isClickable: false,
                                          icon: Icons.watch_later_outlined,
                                          labelText: 'Task time',
                                          controller: timeController,
                                          keyboardType: TextInputType.datetime,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              // timeController.text =
                                              //     TimeOfDay.now().format(context);
                                              // value.format(context);

                                              return 'time must not be empty.';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                      SizedBox(
                                        height: 15,
                                      ),
                                      GestureDetector(
                                        onTap: () {
                                          //to close keyboard if opened
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());
                                          showDatePicker(
                                            context: context,
                                            initialDate: DateTime.now(),
                                            firstDate: DateTime.now(),
                                            lastDate: DateTime(2022),
                                          ).then((value) {
                                            if (value != null) {
                                              dateController.text =
                                                  DateFormat.yMMMd()
                                                      .format(value);
                                            }
                                          });
                                        },
                                        child: defaultTextForm(
                                          isClickable: false,
                                          icon: Icons.calendar_today,
                                          labelText: 'Task date',
                                          controller: dateController,
                                          keyboardType: TextInputType.datetime,
                                          validator: (String value) {
                                            if (value.isEmpty) {
                                              return 'Task Date must not be empty.';
                                            }
                                            return null;
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                        elevation: 15,
                        backgroundColor: Colors.white)
                    .closed
                    .then((value) {
                  timeController.clear();
                  dateController.clear();
                  titleController.clear();
                  cubit.changeBottomSheet(false);
                });
                cubit.changeBottomSheet(true);
              }
            },
          ),

          // customFloatingActionButton(
          //   size: size,
          //   onTap: () {
          //     _scaffoldKey.currentState.showBottomSheet(
          //       (context) => Container(
          //         color: Colors.teal,
          //         width: double.infinity,
          //         height: 200,
          //       ),
          //     );
          //   },
          // ),
          appBar: AppBar(
            backgroundColor: Color(0xff292e4e),
            // backgroundColor: primaryColor,
            elevation: 0,
            title: Center(
              child: Text(
                cubit.appBarTitles[cubit.currentIndex],
                style: TextStyle(fontSize: 20),
              ),
            ),

          ),
          floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
          body: Container(
            height: double.infinity,
            child: cubit.layouts[cubit.currentIndex],
          ),
        );
      }),
    );
  }

  List<BottomNavigationBarItem> bottomNavigationBarList() {
    return [
      BottomNavigationBarItem(
        label: 'My Tasks',
        icon: Icon(Icons.border_all),
      ),
      BottomNavigationBarItem(
        label: 'Done',
        icon: Icon(Icons.check_circle),
      ),

      BottomNavigationBarItem(
        label: 'Archived',
        icon: Icon(Icons.archive_outlined),
      ),
      BottomNavigationBarItem(
        label: '',
        icon: Icon(
          Icons.archive_outlined,
          color: Colors.transparent,
        ),
      ),
    ];
  }

  customFloatingActionButton({@required Size size, @required Function onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.redAccent,
        ),
        height: size.width * 0.15,
        width: size.width * 0.15,
        child: Center(
          child: Text(
            '+',
            style: TextStyle(fontSize: 30, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
