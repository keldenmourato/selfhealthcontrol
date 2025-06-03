import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import '../models/modelo_tarefa.dart';
import '../services/tarefas.dart';
import '../services/notificacoes.dart';

class TaskFormScreen extends StatefulWidget {
  final Task? task;
  const TaskFormScreen({super.key, this.task});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime _selectedTime = DateTime.now();
  bool _isSaving = false;

  final notificationService = NotificationService();

  @override
  void initState() {
    super.initState();
    if (widget.task != null) {
      _titleController.text = widget.task!.title;
      _descController.text = widget.task!.description;
      _selectedTime = widget.task!.time;
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedTime),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = DateTime(
          _selectedTime.year,
          _selectedTime.month,
          _selectedTime.day,
          picked.hour,
          picked.minute,
        );
      });
    }
  }

  Future<void> _saveTask() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSaving = true);

    try {
      final taskService = Provider.of<TaskService>(context, listen: false);
      final notificationService = Provider.of<NotificationService>(context, listen: false);

      // Converter para fuso horário de Moçambique
      final mozambiqueTime = tz.TZDateTime.from(_selectedTime, tz.local);

      final newTask = Task(
        id: widget.task?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: _titleController.text,
        description: _descController.text,
        time: mozambiqueTime,
        createdAt: widget.task?.createdAt ?? DateTime.now(),
      );

      if (widget.task == null) {
        // Nova tarefa
        await taskService.addTask(newTask);
        await notificationService.scheduleNotification(
          context: context,
          id: newTask.id.hashCode,
          title: newTask.title,
          body: newTask.description,
          scheduledTime: newTask.time,
        );
      } else {
        // Atualizar tarefa
        await taskService.updateTask(newTask);
        await notificationService.cancelNotification(newTask.id.hashCode);
        await notificationService.scheduleNotification(
          context: context,
          id: newTask.id.hashCode,
          title: newTask.title,
          body: newTask.description,
          scheduledTime: newTask.time,
        );
      }

      if (mounted) {
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erro ao salvar: ${e.toString()}')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isSaving = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.task == null ? 'Nova Tarefa' : 'Editar Tarefa'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: InputDecoration(
                  labelText: 'Título',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _descController,
                decoration: InputDecoration(
                  labelText: 'Descrição',
                  border: const OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.grey[200],
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 16),
              InkWell(
                onTap: () => _selectTime(context),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey[400]!),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.access_time, color: Colors.grey),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Horário', style: TextStyle(color: Colors.grey)),
                          Text(
                            DateFormat('HH:mm').format(_selectedTime),
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                    onPressed: () async {
                      if (_isSaving) return;

                      setState(() {
                        _isSaving = true;
                      });

                      await _saveTask(); // salva a tarefa no Firestore

                      await notificationService.agendarNotificacao(
                        title: 'Novo lembrete',
                        body: _titleController.text,
                        hour: _selectedTime.hour,
                        minute: _selectedTime.minute,
                        id: DateTime.now().millisecondsSinceEpoch ~/ 1000, // ID único
                      );

                      setState(() {
                        _isSaving = false;
                      });

                      //if (mounted) Navigator.pop(context); // volta à tela anterior
                    },
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    'Salvar Tarefa',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}