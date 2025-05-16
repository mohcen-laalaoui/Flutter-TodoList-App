import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoy_flutter/models/task.dart';
import 'package:todoy_flutter/models/task_data.dart';
import 'package:todoy_flutter/screens/edit_task_screen.dart';
import 'package:todoy_flutter/widgets/task_list_item.dart';

class TasksList extends StatelessWidget {
  const TasksList({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskData>(
      builder: (context, taskData, child) {
        final tasks = taskData.tasks;

        if (tasks.isEmpty) {
          return _buildEmptyState();
        }

        return ListView.builder(
          itemCount: tasks.length,
          itemBuilder: (context, index) {
            final task = tasks[index];
            return TaskListItem(
              task: task,
              onCheckboxChanged: (checkboxState) {
                taskData.updateTask(task);
              },
              onEditPressed: () {
                _showEditTaskScreen(context, task);
              },
              onDeletePressed: () {
                taskData.deleteTask(task);

                // Show undo option
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Task "${task.name}" deleted'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        taskData.addTask(
                          task.name,
                          priority: task.priority,
                          dueDate: task.dueDate,
                          notes: task.notes,
                        );
                      },
                    ),
                    behavior: SnackBarBehavior.floating,
                    margin: const EdgeInsets.all(10),
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.check_circle_outline,
            size: 80,
            color: Colors.grey.shade300,
          ),
          const SizedBox(height: 20),
          Text(
            'No tasks yet',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Add a new task by tapping the + button',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }

  void _showEditTaskScreen(BuildContext context, Task task) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
      ),
      builder: (context) => SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: EditTaskScreen(task: task),
        ),
      ),
    );
  }
}
