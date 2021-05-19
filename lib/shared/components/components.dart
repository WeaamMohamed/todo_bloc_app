import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_app/shared/cubit/cubit.dart';
import 'package:todo_app/shared/styles/colors.dart';

Widget defaultTextForm({
  @required IconData icon,
  @required String labelText,
  IconData suffixIcon,
  @required TextEditingController controller,
  @required TextInputType keyboardType,
  Function onSubmitted,
  Function validator,
  bool isObscure = false,
  Function onSuffixPressed,
  Function onTap,
  bool isClickable = true,
}) =>
    TextFormField(
      enabled: isClickable,
      onTap: onTap,
      obscureText: isObscure,
      validator: validator,
      onFieldSubmitted: onSubmitted,
      keyboardType: keyboardType,
      controller: controller,
      decoration: InputDecoration(
        errorStyle: TextStyle(
          color: Colors.red[700], // or any other color
        ),
        labelText: labelText,
        prefixIcon: Icon(
          icon,
        ),
        suffixIcon: suffixIcon != null
            ? IconButton(
                icon: Icon(suffixIcon),
                onPressed: onSuffixPressed,
              )
            : null,
        border: OutlineInputBorder(),
      ),
    );

Widget defaultButton({
  Color color = Colors.redAccent,
  @required String text,
  @required Function onPressed,
  double width = double.infinity,
}) =>
    Container(
      width: width,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: MaterialButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16,
            color: Colors.white,
          ),
        ),
      ),
    );

Widget customNavigationBarItem({
  @required String title,
  @required IconData icon,
  Function onTap,
  color = Colors.white60,
  bool isSelected = false,
  @required BuildContext context,
}) =>
    GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.only(top: 10, bottom: 10),
        height: double.infinity,
        width: MediaQuery.of(context).size.width * 0.19,
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : Colors.white60,
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              title,
              style: TextStyle(
                  color: isSelected ? Colors.white : Colors.white70,
                  fontSize: 14),
            )
          ],
        ),
      ),
    );

TextStyle alertTextStyle() {
  return TextStyle(fontSize: 18, fontWeight: FontWeight.w500);
}

Slidable taskWidget({
  //Color color,
  String title,
  String time,
  Function onDone,
  // Function onDelete,
  Function onArchived,
  bool isArchived = false,
  bool isDone = false,
  int id,
  BuildContext context,
  int index,
}) {
  return Slidable(
    actionPane: SlidableDrawerActionPane(),
    actionExtentRatio: 0.2,
    child: Container(
      height: MediaQuery.of(context).size.height * 0.12,
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            color: Colors.black.withOpacity(0.04),
            offset: Offset(0, 9),
            blurRadius: 10,
            spreadRadius: 1)
      ]),
      child: Row(
        children: [
          InkWell(
            onTap: onDone,
            // onTap: () {
            //
            //   AppCubit.get(context).updateData(id: id, status: 'Done');
            // },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              height: 25,
              width: 25,
              decoration: BoxDecoration(
                color: isDone ? primaryColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(color: primaryColor, width: 3),
              ),
              child: Center(
                  child: Icon(
                Icons.check,
                size: 20,
                color: Colors.white,
              )),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: TextStyle(color: Colors.black, fontSize: 18),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                time,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              )
            ],
          ),
          Expanded(
            child: Container(),
          ),
          Container(
            height: 50,
            width: 5,
            color: primaryColor,
          )
        ],
      ),
    ),
    secondaryActions: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: IconSlideAction(
          caption: isArchived ? 'Unarchive' : 'Archive',
          color: Colors.white,
          //  icon: Icons.archive,
          iconWidget: Icon(
              isArchived ? Icons.unarchive_outlined : Icons.archive_outlined),
          onTap: onArchived,
        ),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: IconSlideAction(
          caption: 'Delete',
          color: primaryColor,
          icon: Icons.edit,
          onTap: () => AppCubit.get(context).deleteData(id: id),
        ),
      )
    ],
  );
}

Widget emptyTasksWidget({String screenName}) => Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.menu,
            size: 100,
            color: Colors.grey,
          ),
          Text(
            'No $screenName tasks yet.',
            style: TextStyle(
                color: Colors.grey, fontWeight: FontWeight.bold, fontSize: 20),
          )
        ],
      ),
    );
