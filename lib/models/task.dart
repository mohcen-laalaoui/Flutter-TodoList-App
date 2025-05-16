import 'package:flutter/foundation.dart';

enum Priority { low, medium, high }

class Task {
  final String name;
  bool isDone;
  final Priority priority;
  final DateTime? dueDate;
  final String? notes;

  Task({
    required this.name,
    this.isDone = false,
    this.priority = Priority.medium,
    this.dueDate,
    this.notes,
  });

  void toggleDone() {
    isDone = !isDone;
  }

  Task copyWith({
    String? name,
    bool? isDone,
    Priority? priority,
    DateTime? dueDate,
    String? notes,
  }) {
    return Task(
      name: name ?? this.name,
      isDone: isDone ?? this.isDone,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      notes: notes ?? this.notes,
    );
  }

  /// Returns whether the task is overdue based on its due date
  bool get isOverdue {
    if (dueDate == null) return false;
    return !isDone && dueDate!.isBefore(DateTime.now());
  }

  /// Returns a color importance based on the task's priority and due date status
  int get importance {
    if (isDone) return 0;

    // Base importance from priority
    int value = priority == Priority.high
        ? 3
        : priority == Priority.medium
            ? 2
            : 1;

    // Increase importance if task is overdue
    if (isOverdue) {
      value += 2;

      // Extra importance for overdue high-priority tasks
      if (priority == Priority.high) {
        value += 1;
      }
    }
    // Increase importance if due today
    else if (dueDate != null && _isToday(dueDate!)) {
      value += 1;
    }

    return value;
  }

  bool _isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year &&
        date.month == now.month &&
        date.day == now.day;
  }

  /// Returns a string representation of the due date status
  String? get dueStatus {
    if (dueDate == null) return null;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final taskDate = DateTime(dueDate!.year, dueDate!.month, dueDate!.day);

    final difference = taskDate.difference(today).inDays;

    if (difference < 0) return 'Overdue';
    if (difference == 0) return 'Today';
    if (difference == 1) return 'Tomorrow';
    if (difference < 7) return 'This week';
    if (difference < 30) return 'This month';
    return 'Future';
  }

  /// Returns a formatted string representation of the due date
  String get formattedDate {
    if (dueDate == null) return '';

    return '${dueDate!.day}/${dueDate!.month}/${dueDate!.year}';
  }

  @override
  String toString() =>
      'Task: $name (Priority: $priority, Due: ${dueDate ?? "None"})';
}
