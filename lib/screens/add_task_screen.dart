import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoy_flutter/models/task_data.dart';

class AddTaskScreen extends StatelessWidget {
  const AddTaskScreen({super.key});


  @override
  Widget build(BuildContext context) {
    String newTaskTitle = '';

    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20.0),
            topLeft: Radius.circular(20.0),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Add Task',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.lightBlueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.w400,
              ),
            ),
            TextField(
              autofocus: true,
              textAlign: TextAlign.center,
              onChanged: (newText) {
                newTaskTitle = newText;
              },
            ),
            const SizedBox(
              height: 10.0,
            ),
            ElevatedButton(
              style: const ButtonStyle(
                backgroundColor:
                    MaterialStatePropertyAll(Colors.lightBlueAccent),
              ),
              onPressed: () {
                Provider.of<TaskData>(context).addTask(newTaskTitle);
                Navigator.pop(context);
              },
              child: const Text(
                'Add',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
