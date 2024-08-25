// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

///
import '../../main.dart';
import '../../models/task.dart';
import '../../utils/colors.dart';
import '../../utils/constanst.dart';
import '../../utils/strings.dart';

// ignore: must_be_immutable
class TaskView extends StatefulWidget {
  TaskView({
    Key? key,
    required this.taskControllerForTitle,
    required this.taskControllerForSubtitle,
    required this.task,
  }) : super(key: key);

  TextEditingController? taskControllerForTitle;
  TextEditingController? taskControllerForSubtitle;
  final Task? task;

  @override
  State<TaskView> createState() => _TaskViewState();
}

class _TaskViewState extends State<TaskView> {
  var title;
  var subtitle;
  DateTime? time;
  DateTime? date;

  /// Show Selected Time As String Format
  String showTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateFormat('hh:mm a').format(DateTime.now()).toString();
      } else {
        return DateFormat('hh:mm a').format(time).toString();
      }
    } else {
      return DateFormat('hh:mm a')
          .format(widget.task!.createdAtTime)
          .toString();
    }
  }
  
  /// Show Selected Time As DateTime Format
  DateTime showTimeAsDateTime(DateTime? time) {
    if (widget.task?.createdAtTime == null) {
      if (time == null) {
        return DateTime.now();
      } else {
        return time;
      }
    } else {
      return widget.task!.createdAtTime;
    }
  }

  /// Show Selected Date As String Format
  String showDate(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateFormat.yMMMEd().format(DateTime.now()).toString();
      } else {
        return DateFormat.yMMMEd().format(date).toString();
      }
    } else {
      return DateFormat.yMMMEd().format(widget.task!.createdAtDate).toString();
    }
  }

  // Show Selected Date As DateTime Format
  DateTime showDateAsDateTime(DateTime? date) {
    if (widget.task?.createdAtDate == null) {
      if (date == null) {
        return DateTime.now();
      } else {
        return date;
      }
    } else {
      return widget.task!.createdAtDate;
    }
  }

  /// If any Task Already exist return TRUE otherwise FALSE
  bool isTaskAlreadyExistBool() {
    if (widget.taskControllerForTitle?.text == null &&
        widget.taskControllerForSubtitle?.text == null) {
      return true;
    } else {
      return false;
    }
  }

  /// If any task already exists app will update it otherwise the app will add a new task
  dynamic isTaskAlreadyExistUpdateTask() {
    if (widget.taskControllerForTitle?.text != null &&
        widget.taskControllerForSubtitle?.text != null) {
      try {
        widget.taskControllerForTitle?.text = title;
        widget.taskControllerForSubtitle?.text = subtitle;

        // widget.task?.createdAtDate = date!;
        // widget.task?.createdAtTime = time!;

        widget.task?.save();
        Navigator.of(context).pop();
      } catch (error) {
        nothingEnterOnUpdateTaskMode(context);
      }
    } else {
      if (title != null && subtitle != null) {
        var task = Task.create(
          title: title,
          createdAtTime: time,
          createdAtDate: date,
          subtitle: subtitle,
        );
        BaseWidget.of(context).dataStore.addTask(task: task);
        Navigator.of(context).pop();
      } else {
        emptyFieldsWarning(context);
      }
    }
  }

  /// Delete Selected Task
  dynamic deleteTask() {
    return widget.task?.delete();
  }

  @override
  Widget build(BuildContext context) {
    var textTheme = Theme.of(context).textTheme;
    return GestureDetector(
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: const MyAppBar(),
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  /// new / update Task Text
                  _buildTopText(textTheme),

                  /// Middle Two TextFields, Time And Date Selection Box
                  _buildMiddleTextFieldsANDTimeAndDateSelection(
                      context, textTheme),

                  /// All Bottom Buttons
                  _buildBottomButtons(context),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  /// All Bottom Buttons
  Padding _buildBottomButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        mainAxisAlignment: isTaskAlreadyExistBool()
            ? MainAxisAlignment.center
            : MainAxisAlignment.spaceEvenly,
        children: [
          isTaskAlreadyExistBool()
              ? Container()

              /// Delete Task Button
              : Container(
                  width: 150,
                  height: 55,
                  decoration: BoxDecoration(
                      border:
                          Border.all(color: MyColors.primaryColor, width: 2),
                      borderRadius: BorderRadius.circular(15)),
                  child: MaterialButton(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    minWidth: 150,
                    height: 55,
                    onPressed: () {
                      deleteTask();
                      Navigator.pop(context);
                    },
                    color: Colors.white,
                    child: const Row(
                      children: [
                        Icon(
                          Icons.close,
                          color: MyColors.primaryColor,
                        ),
                        SizedBox(
                          width: 5,
                        ),
                        Text(
                          MyString.deleteTask,
                          style: TextStyle(
                            color: MyColors.primaryColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

          /// Add or Update Task Button
          MaterialButton(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            minWidth: 150,
            height: 55,
            onPressed: () {
              isTaskAlreadyExistUpdateTask();
            },
            color: MyColors.primaryColor,
            child: Text(
              isTaskAlreadyExistBool()
                  ? MyString.addTaskString
                  : MyString.updateTaskString,
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Middle Two TextFields And Time And Date Selection Box
  SizedBox _buildMiddleTextFieldsANDTimeAndDateSelection(
      BuildContext context, TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      height: 450,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Title of TextFiled
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(MyString.titleOfTitleTextField,
                style: textTheme.headlineMedium),
          ),

          /// Title TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForTitle,
                maxLines: 6,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.shade300),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: MyColors.primaryColor),
                  ),
                ),
                onFieldSubmitted: (value) {
                  title = value;
                  FocusManager.instance.primaryFocus?.unfocus();
                },
                onChanged: (value) {
                  title = value;
                },
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// Note TextField
          Container(
            width: MediaQuery.of(context).size.width,
            margin: const EdgeInsets.symmetric(horizontal: 16),
            child: ListTile(
              title: TextFormField(
                controller: widget.taskControllerForSubtitle,
                style: const TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.grey.shade300,
                  prefixIcon:
                      const Icon(Icons.bookmark_border, color: Colors.grey),
                  border: InputBorder.none,
                  counter: Container(),
                  hintText: MyString.addNote,
                ),
                onFieldSubmitted: (value) {
                  subtitle = value;
                },
                onChanged: (value) {
                  subtitle = value;
                },
              ),
            ),
          ),

          /// Time Picker
          GestureDetector(
            onTap: () async {
              final selectedTime = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.fromDateTime(showTimeAsDateTime(time)),
              );

              if (selectedTime != null) {
                setState(() {
                  time = DateTime(
                    showTimeAsDateTime(time).year,
                    showTimeAsDateTime(time).month,
                    showTimeAsDateTime(time).day,
                    selectedTime.hour,
                    selectedTime.minute,
                  );
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.access_time, color: Colors.grey),
                  Text(
                    showTime(time),
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          /// Date Picker
          GestureDetector(
            onTap: () async {
              final selectedDate = await showDatePicker(
                context: context,
                initialDate: showDateAsDateTime(date),
                firstDate: DateTime(2000),
                lastDate: DateTime(2100),
              );

              if (selectedDate != null) {
                setState(() {
                  date = selectedDate;
                });
              }
            },
            child: Container(
              width: MediaQuery.of(context).size.width,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.calendar_today, color: Colors.grey),
                  Text(
                    showDate(date),
                    style: textTheme.headlineMedium,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// New / Update Task Text
  SizedBox _buildTopText(TextTheme textTheme) {
    return SizedBox(
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.only(left: 16, bottom: 16),
        child: Row(
          children: [
            Text(
              isTaskAlreadyExistBool()
                  ? MyString.addTaskString
                  : MyString.updateTaskString,
              style: textTheme.headlineMedium,
            ),
            const Icon(Icons.add_task),
          ],
        ),
      ),
    );
  }
}

/// AppBar
class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MyAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 80,
      child: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: const Icon(
                  Icons.arrow_back_ios_new_rounded,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(100);
}
