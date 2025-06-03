import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/modelo_tarefa.dart';

class TaskItem extends StatelessWidget {
  final Task task;
  final Function(String) onDelete;
  final Function(Task) onTap;

  const TaskItem({
    super.key,
    required this.task,
    required this.onDelete,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        tileColor: Colors.grey[300],
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8)
        ),
        title: Text(task.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(task.description),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy HH:mm').format(task.time),
              style: const TextStyle(fontSize: 12),
            ),
          ],
        ),
        trailing: IconButton(
          icon: const Icon(Icons.delete, color: Colors.red),
          onPressed: () => onDelete(task.id!),
        ),
        onTap: () => onTap(task),
      ),
    );
  }
}