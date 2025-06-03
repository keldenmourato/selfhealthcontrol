import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../services/historico.dart';
import '../models/modelo_historico.dart';

class TelaHistorico extends StatelessWidget {
  const TelaHistorico({super.key});

  @override
  Widget build(BuildContext context) {
    final historyService = Provider.of<HistoryService>(context);

    return Scaffold(
      body: StreamBuilder<List<HistoryTask>>(
        stream: historyService.getHistory(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final historyTasks = snapshot.data!;

          if (historyTasks.isEmpty) {
            return const Center(child: Text('Nenhum item no histórico'));
          }

          return ListView.builder(
            itemCount: historyTasks.length,
            itemBuilder: (context, index) {
              final task = historyTasks[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: ListTile(
                  title: Text(task.title),
                  tileColor: Colors.grey[300],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(task.description),
                      const SizedBox(height: 4),
                      Text(
                        'Programado: ${DateFormat('dd/MM/yyyy HH:mm').format(task.scheduledTime)}',
                        style: const TextStyle(fontSize: 12),
                      ),
                      Text(
                        'Status: ${task.status == 'completed' ? 'Concluído' : 'Pendente'}',
                        style: TextStyle(
                          color: task.status == 'completed'
                              ? Colors.green
                              : Colors.orange,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  trailing: task.status == 'pending'
                      ? IconButton(
                    icon: const Icon(Icons.check, color: Colors.green),
                    onPressed: () async {
                      await historyService.updateHistoryStatus(
                        task.id!,
                        'completed',
                      );
                    },
                  )
                      : const Icon(Icons.check_circle, color: Colors.green),
                ),
              );
            },
          );
        },
      ),
    );
  }
}