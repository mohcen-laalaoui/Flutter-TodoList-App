import 'package:flutter/material.dart';

class TaskTile extends StatelessWidget {
  final bool isChecked;
  final String taskTitle;
  final Function(bool?) checkboxCallback;
  final void Function() longPressCallback;

  const TaskTile({
    super.key,
    required this.taskTitle,
    required this.isChecked,
    required this.checkboxCallback,
    required this.longPressCallback,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onLongPress: longPressCallback,
      title: Text(
        taskTitle,
        style: TextStyle(
          decoration: isChecked ? TextDecoration.lineThrough : null,
        ),
      ),
      trailing: Checkbox(
        activeColor: Colors.lightBlueAccent,
        value: isChecked,
        onChanged: checkboxCallback,
      ),
    );
  }
}

// class TaskCheckedBox extends StatelessWidget {
//   final bool checkBoxState;
//   final Function(bool?) toggleCheckboxState;
//
//   const TaskCheckedBox({
//     required this.checkBoxState,
//     required this.toggleCheckboxState,
//     Key? key,
//   }) : super(key: key);

// Widget build(BuildContext context) {
// }
