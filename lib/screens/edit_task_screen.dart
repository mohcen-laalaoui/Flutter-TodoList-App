import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoy_flutter/models/task.dart';
import 'package:todoy_flutter/models/task_data.dart';

class EditTaskScreen extends StatefulWidget {
  final Task task;

  const EditTaskScreen({
    super.key,
    required this.task,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {
  late TextEditingController _taskController;
  late TextEditingController _notesController;
  late FocusNode _taskFocusNode;
  late DateTime? _dueDate;
  late Priority _priority;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with existing task data
    _taskController = TextEditingController(text: widget.task.name);
    _notesController = TextEditingController(text: widget.task.notes);
    _taskFocusNode = FocusNode();
    _dueDate = widget.task.dueDate;
    _priority = widget.task.priority;

    // Auto focus on text field when modal opens
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _taskFocusNode.requestFocus();
    });
  }

  @override
  void dispose() {
    _taskController.dispose();
    _notesController.dispose();
    _taskFocusNode.dispose();
    super.dispose();
  }

  void _updateTask() {
    final taskTitle = _taskController.text.trim();
    if (taskTitle.isEmpty) {
      // Show error message if task title is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Task title cannot be empty'),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }

    // Update task
    Provider.of<TaskData>(context, listen: false).updateTaskDetails(
      widget.task,
      name: taskTitle,
      priority: _priority,
      dueDate: _dueDate,
      notes: _notesController.text.trim().isEmpty
          ? null
          : _notesController.text.trim(),
    );

    Navigator.pop(context);
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _dueDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(
          days:
              365)), // Allow selecting dates in the past for existing overdue tasks
      lastDate: DateTime.now().add(const Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.lightBlueAccent,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dueDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
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
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 40),
                const Expanded(
                  child: Text(
                    'Edit Task',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.lightBlueAccent,
                      fontSize: 30.0,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _taskController,
              focusNode: _taskFocusNode,
              textAlign: TextAlign.center,
              decoration: const InputDecoration(
                hintText: 'Enter task title',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide: BorderSide(color: Colors.lightBlueAccent),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  borderSide:
                      BorderSide(color: Colors.lightBlueAccent, width: 2),
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Priority selector
            Row(
              children: [
                const Text('Priority:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                Expanded(
                  child: SegmentedButton<Priority>(
                    segments: const [
                      ButtonSegment<Priority>(
                        value: Priority.low,
                        label: Text('Low'),
                        icon: Icon(Icons.arrow_downward),
                      ),
                      ButtonSegment<Priority>(
                        value: Priority.medium,
                        label: Text('Medium'),
                        icon: Icon(Icons.remove),
                      ),
                      ButtonSegment<Priority>(
                        value: Priority.high,
                        label: Text('High'),
                        icon: Icon(Icons.arrow_upward),
                      ),
                    ],
                    selected: {_priority},
                    onSelectionChanged: (Set<Priority> newSelection) {
                      setState(() {
                        _priority = newSelection.first;
                      });
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20.0),
            // Due date selector
            InkWell(
              onTap: () => _selectDate(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade400),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _dueDate == null
                          ? 'Set due date (optional)'
                          : 'Due: ${_formatDate(_dueDate!)}',
                      style: TextStyle(
                        fontSize: 16,
                        color: _dueDate == null
                            ? Colors.grey.shade600
                            : Colors.black,
                      ),
                    ),
                    Row(
                      children: [
                        if (_dueDate != null)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _dueDate = null;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(
                                Icons.clear,
                                size: 18,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                        Icon(
                          Icons.calendar_today,
                          color: _dueDate == null
                              ? Colors.grey.shade600
                              : Colors.lightBlueAccent,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20.0),
            // Notes field
            TextField(
              controller: _notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                hintText: 'Add notes (optional)',
                contentPadding:
                    EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
              ),
            ),
            const SizedBox(height: 24.0),
            Row(
              children: [
                // Task completion status
                Expanded(
                  child: Row(
                    children: [
                      Checkbox(
                        value: widget.task.isDone,
                        activeColor: Colors.lightBlueAccent,
                        onChanged: (value) {
                          Provider.of<TaskData>(context, listen: false)
                              .updateTaskDetails(
                            widget.task,
                            isDone: value,
                          );
                          setState(() {});
                        },
                      ),
                      const Text('Mark as completed'),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.lightBlueAccent,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 2,
              ),
              onPressed: _updateTask,
              child: const Text(
                'Update Task',
                style: TextStyle(fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
