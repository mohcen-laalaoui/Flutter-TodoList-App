import 'package:flutter/material.dart';
import 'package:todoy_flutter/models/task.dart';
import 'package:todoy_flutter/models/task_data.dart';
import 'package:todoy_flutter/screens/add_task_screen.dart';
import 'package:provider/provider.dart';
import 'package:todoy_flutter/widgets/tasks_list.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 5,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
        onPressed: () {
          showModalBottomSheet(
            context: context,
            isScrollControlled: true,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
            ),
            builder: (context) => SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: const AddTaskScreen(),
              ),
            ),
          );
        },
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _buildTasksHeader(context),
                  const SizedBox(height: 10),
                  _buildFilterChips(context),
                  const SizedBox(height: 10),
                  const Expanded(
                    child: TasksList(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);

    return Container(
      padding: const EdgeInsets.only(
          top: 60.0, left: 30.0, right: 30.0, bottom: 30.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const CircleAvatar(
                backgroundColor: Colors.white,
                radius: 30.0,
                child: Icon(
                  Icons.check_circle_outline,
                  size: 30.0,
                  color: Colors.lightBlueAccent,
                ),
              ),
              _buildStatisticsChip(context),
            ],
          ),
          const SizedBox(height: 10.0),
          const Text(
            'Todoey',
            style: TextStyle(
              color: Colors.white,
              fontSize: 50.0,
              fontWeight: FontWeight.w700,
            ),
          ),
          Row(
            children: [
              Text(
                '${taskData.taskCount} Tasks',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18.0,
                ),
              ),
              const SizedBox(width: 10),
              if (taskData.completedTaskCount > 0)
                Text(
                  '(${taskData.completedTaskCount} completed)',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14.0,
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTasksHeader(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);
    final overdueCount = taskData.overdueTasks.length;

    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'My Tasks',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Colors.black54,
            ),
          ),
          Row(
            children: [
              if (overdueCount > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.red.shade100,
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.warning_amber_rounded,
                          size: 16, color: Colors.red),
                      const SizedBox(width: 5),
                      Text(
                        '$overdueCount overdue',
                        style: TextStyle(color: Colors.red.shade700),
                      ),
                    ],
                  ),
                ),
              const SizedBox(width: 10),
              PopupMenuButton<String>(
                icon: const Icon(Icons.more_vert),
                onSelected: (value) {
                  if (value == 'clear_completed') {
                    taskData.clearCompletedTasks();
                  }
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'clear_completed',
                    child: Text('Clear completed tasks'),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          FilterChip(
            label: const Text('Hide Completed'),
            selected: taskData.hideCompleted,
            onSelected: (selected) {
              taskData.setHideCompleted(selected);
            },
            selectedColor: Colors.lightBlueAccent.withOpacity(0.3),
            checkmarkColor: Colors.lightBlueAccent,
          ),
          const SizedBox(width: 10),
          FilterChip(
            label: const Text('Sort by Priority'),
            selected: taskData.sortByPriority,
            onSelected: (selected) {
              taskData.setSortByPriority(selected);
            },
            selectedColor: Colors.lightBlueAccent.withOpacity(0.3),
            checkmarkColor: Colors.lightBlueAccent,
          ),
          const SizedBox(width: 10),
          FilterChip(
            label: const Text('Sort by Due Date'),
            selected: taskData.sortByDueDate,
            onSelected: (selected) {
              taskData.setSortByDueDate(selected);
            },
            selectedColor: Colors.lightBlueAccent.withOpacity(0.3),
            checkmarkColor: Colors.lightBlueAccent,
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsChip(BuildContext context) {
    final taskData = Provider.of<TaskData>(context);
    final todayTaskCount = taskData.todayTasks.length;

    if (todayTaskCount == 0) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.calendar_today,
            size: 16,
            color: Colors.lightBlueAccent,
          ),
          const SizedBox(width: 5),
          Text(
            '$todayTaskCount for today',
            style: const TextStyle(
              color: Colors.lightBlueAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
