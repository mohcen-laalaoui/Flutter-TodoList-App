import 'package:flutter/material.dart';
import 'package:todoy_flutter/models/task.dart';

class TaskListItem extends StatelessWidget {
  final Task task;
  final Function(bool?) onCheckboxChanged;
  final VoidCallback onEditPressed;
  final VoidCallback onDeletePressed;

  const TaskListItem({
    super.key,
    required this.task,
    required this.onCheckboxChanged,
    required this.onEditPressed,
    required this.onDeletePressed,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(task.name),
      background: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerLeft,
        color: Colors.green,
        child: const Icon(
          Icons.edit,
          color: Colors.white,
        ),
      ),
      secondaryBackground: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        alignment: Alignment.centerRight,
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      confirmDismiss: (direction) async {
        if (direction == DismissDirection.startToEnd) {
          onEditPressed();
          return false;
        } else {
          return await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text("Confirm"),
                content:
                    Text("Are you sure you want to delete '${task.name}'?"),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    child: const Text("CANCEL"),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    child: const Text("DELETE"),
                  ),
                ],
              );
            },
          );
        }
      },
      onDismissed: (direction) {
        if (direction == DismissDirection.endToStart) {
          onDeletePressed();
        }
      },
      child: Card(
        elevation: 2,
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(
            color: _getPriorityColor(task.priority).withOpacity(0.3),
            width: 1,
          ),
        ),
        child: ListTile(
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          leading: Checkbox(
            activeColor: Colors.lightBlueAccent,
            value: task.isDone,
            onChanged: onCheckboxChanged,
          ),
          title: Text(
            task.name,
            style: TextStyle(
              decoration: task.isDone ? TextDecoration.lineThrough : null,
              color: task.isDone ? Colors.grey : Colors.black,
              fontWeight: task.priority == Priority.high
                  ? FontWeight.bold
                  : FontWeight.normal,
            ),
          ),
          subtitle: _buildSubtitle(),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (task.priority != Priority.medium) _buildPriorityIndicator(),
              if (task.dueDate != null) _buildDueDateIndicator(),
              IconButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Colors.grey,
                ),
                onPressed: () {
                  _showOptionsBottomSheet(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget? _buildSubtitle() {
    final List<Widget> elements = [];

    // Add notes indicator if task has notes
    if (task.notes != null && task.notes!.isNotEmpty) {
      elements.add(
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.notes,
              size: 14,
              color: Colors.grey,
            ),
            const SizedBox(width: 4),
            Text(
              task.notes!.length > 30
                  ? '${task.notes!.substring(0, 30)}...'
                  : task.notes!,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return elements.isEmpty
        ? null
        : Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: elements,
          );
  }

  Widget _buildPriorityIndicator() {
    IconData icon;
    Color color;

    switch (task.priority) {
      case Priority.high:
        icon = Icons.arrow_upward;
        color = Colors.red;
        break;
      case Priority.low:
        icon = Icons.arrow_downward;
        color = Colors.green;
        break;
      default:
        // Medium priority doesn't show an indicator
        return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Icon(
        icon,
        size: 16,
        color: color,
      ),
    );
  }

  Widget _buildDueDateIndicator() {
    final isOverdue = task.isOverdue;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      margin: const EdgeInsets.only(right: 4),
      decoration: BoxDecoration(
        color: isOverdue
            ? Colors.red.withOpacity(0.1)
            : Colors.blue.withOpacity(0.1),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.calendar_today,
            size: 12,
            color: isOverdue ? Colors.red : Colors.blue,
          ),
          const SizedBox(width: 4),
          Text(
            task.formattedDate,
            style: TextStyle(
              fontSize: 12,
              color: isOverdue ? Colors.red : Colors.blue,
              fontWeight: isOverdue ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  void _showOptionsBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.edit, color: Colors.blue),
                title: const Text('Edit Task'),
                onTap: () {
                  Navigator.pop(context);
                  onEditPressed();
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Delete Task'),
                onTap: () {
                  Navigator.pop(context);
                  onDeletePressed();
                },
              ),
              if (task.notes != null && task.notes!.isNotEmpty)
                ListTile(
                  leading: const Icon(Icons.notes, color: Colors.amber),
                  title: const Text('View Notes'),
                  onTap: () {
                    Navigator.pop(context);
                    _showNotesDialog(context);
                  },
                ),
            ],
          ),
        );
      },
    );
  }

  void _showNotesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(task.name),
          content: SingleChildScrollView(
            child: Text(task.notes ?? ''),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('CLOSE'),
            ),
          ],
        );
      },
    );
  }

  Color _getPriorityColor(Priority priority) {
    switch (priority) {
      case Priority.high:
        return Colors.red;
      case Priority.medium:
        return Colors.orange;
      case Priority.low:
        return Colors.green;
    }
  }
}
