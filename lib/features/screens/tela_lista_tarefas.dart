import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../models/modelo_tarefa.dart';
import '../services/notificacoes.dart';
import '../services/tarefas.dart';
import '../components/task_item.dart';
import 'tela_formulario_tarefa.dart';
import 'dart:async';

class TelaTarefas extends StatefulWidget {
  const TelaTarefas({super.key});

  @override
  State<TelaTarefas> createState() => _TelaTarefasState();
}

class _TelaTarefasState extends State<TelaTarefas> {

  Timer? _timer;

  @override
  void initState() {
    super.initState();

    // Inicia um timer que verifica tarefas expiradas a cada minuto
    _timer = Timer.periodic(Duration(seconds: 15), (timer) {
      final taskService = Provider.of<TaskService>(context, listen: false);
      taskService.checkAndMoveExpiredTasks();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final taskService = Provider.of<TaskService>(context);

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TaskFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<List<Task>>(
        stream: taskService.getFutureTasks(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tasks = snapshot.data!;

          if (tasks.isEmpty) {
            return const Center(child: Text('Nenhuma tarefa agendada'));
          }

          return ListView.builder(
            itemCount: tasks.length,
            itemBuilder: (context, index) {
              final task = tasks[index];
              return TaskItem(
                task: task,
                onDelete: (id) async {
                  await taskService.deleteTask(id);
                  final notificationService = Provider.of<NotificationService>(
                    context,
                    listen: false,
                  );
                  await notificationService.cancelNotification(id.hashCode);
                },
                onTap: (task) => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TaskFormScreen(task: task),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}