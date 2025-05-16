import 'package:flutter/material.dart';
import 'package:todoy_flutter/models/task.dart';
import 'dart:collection';

class TaskData extends ChangeNotifier {
  // Initial sample tasks with priorities and due dates
  final List<Task> _tasks = [
    Task(
      name: 'Buy Milk',
      priority: Priority.medium,
      dueDate: DateTime.now().add(const Duration(days: 1)),
    ),
    Task(
      name: 'Buy eggs',
      priority: Priority.high,
      dueDate: DateTime.now(),
      notes: 'Get organic eggs if possible',
    ),
    Task(
      name: 'Buy bread',
      priority: Priority.low,
      dueDate: DateTime.now().add(const Duration(days: 3)),
    ),
  ];

  // Sort and filter preferences
  bool _sortByPriority = true;
  bool _sortByDueDate = true;
  bool _hideCompleted = false;

  // Get tasks with applied sorting and filtering
  UnmodifiableListView<Task> get tasks {
    // Create a copy of the tasks list that we can sort
    final tasksCopy = List<Task>.from(_tasks);

    if (_sortByPriority && _sortByDueDate) {
      tasksCopy.sort((a, b) => b.importance.compareTo(a.importance));
    } else if (_sortByPriority) {
      tasksCopy.sort((a, b) => b.priority.index.compareTo(a.priority.index));
    } else if (_sortByDueDate) {
      tasksCopy.sort((a, b) {
        if (a.dueDate == null && b.dueDate == null) return 0;
        if (a.dueDate == null) return 1;
        if (b.dueDate == null) return -1;
        return a.dueDate!.compareTo(b.dueDate!);
      });
    }

    final filteredTasks = _hideCompleted
        ? tasksCopy.where((task) => !task.isDone).toList()
        : tasksCopy;

    return UnmodifiableListView(filteredTasks);
  }

  int get taskCount => _tasks.length;
  int get completedTaskCount => _tasks.where((task) => task.isDone).length;
  int get pendingTaskCount => _tasks.where((task) => !task.isDone).length;

  List<Task> get overdueTasks =>
      _tasks.where((task) => task.isOverdue).toList();

  List<Task> get todayTasks {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);

    return _tasks.where((task) {
      if (task.dueDate == null) return false;
      final taskDate =
          DateTime(task.dueDate!.year, task.dueDate!.month, task.dueDate!.day);
      return taskDate.isAtSameMomentAs(today);
    }).toList();
  }

  bool get sortByPriority => _sortByPriority;
  bool get sortByDueDate => _sortByDueDate;
  bool get hideCompleted => _hideCompleted;

  void setSortByPriority(bool value) {
    _sortByPriority = value;
    notifyListeners();
  }

  void setSortByDueDate(bool value) {
    _sortByDueDate = value;
    notifyListeners();
  }

  void setHideCompleted(bool value) {
    _hideCompleted = value;
    notifyListeners();
  }

  void addTask(String taskTitle,
      {Priority priority = Priority.medium, DateTime? dueDate, String? notes}) {
    if (taskTitle.trim().isEmpty) return;

    final task = Task(
      name: taskTitle,
      priority: priority,
      dueDate: dueDate,
      notes: notes,
    );

    _tasks.add(task);
    notifyListeners();
  }

  void updateTask(Task task) {
    task.toggleDone();
    notifyListeners();
  }

  void updateTaskDetails(
    Task oldTask, {
    String? name,
    bool? isDone,
    Priority? priority,
    DateTime? dueDate,
    String? notes,
  }) {
    final index = _tasks.indexOf(oldTask);
    if (index != -1) {
      _tasks[index] = oldTask.copyWith(
        name: name,
        isDone: isDone,
        priority: priority,
        dueDate: dueDate,
        notes: notes,
      );
      notifyListeners();
    }
  }

  // Delete task (unchanged)
  void deleteTask(Task task) {
    _tasks.remove(task);
    notifyListeners();
  }

  // Clear all completed tasks
  void clearCompletedTasks() {
    _tasks.removeWhere((task) => task.isDone);
    notifyListeners();
  }

  Map<String, List<Task>> get tasksByDueStatus {
    final Map<String, List<Task>> grouped = {
      'Overdue': [],
      'Today': [],
      'Tomorrow': [],
      'This week': [],
      'This month': [],
      'Future': [],
      'No date': [],
    };

    for (var task in _tasks) {
      if (task.dueDate == null) {
        grouped['No date']!.add(task);
      } else {
        final status = task.dueStatus ?? 'No date';
        grouped[status]!.add(task);
      }
    }

    return grouped;
  }

  // Group tasks by priority
  Map<Priority, List<Task>> get tasksByPriority {
    final Map<Priority, List<Task>> grouped = {
      Priority.high: [],
      Priority.medium: [],
      Priority.low: [],
    };

    for (var task in _tasks) {
      grouped[task.priority]!.add(task);
    }

    return grouped;
  }
}
