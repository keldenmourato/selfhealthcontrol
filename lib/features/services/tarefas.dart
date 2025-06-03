import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/modelo_tarefa.dart';
import '../models/modelo_historico.dart';
import 'historico.dart';

class TaskService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final HistoryService _historyService = HistoryService();
  final String _collectionName = 'tasks';

  Future<String> addTask(Task task) async {
    final docRef = await _firestore.collection(_collectionName).add(task.toMap());
    return docRef.id;
  }

  Future<void> updateTask(Task task) async {
    await _firestore.collection(_collectionName).doc(task.id).update(task.toMap());
  }

  Stream<List<Task>> getFutureTasks() {
    return _firestore
        .collection(_collectionName)
        .where('time', isGreaterThanOrEqualTo: Timestamp.now())
        .orderBy('time')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => Task.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> deleteTask(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }

  Future<void> moveExpiredTaskToHistory(String taskId, String status) async {
    final doc = await _firestore.collection(_collectionName).doc(taskId).get();
    if (doc.exists) {
      final task = Task.fromMap(doc.data()!, doc.id);

      await _historyService.addToHistory(
        HistoryTask(
          originalTaskId: task.id!,
          title: task.title,
          description: task.description,
          scheduledTime: task.time,
          completedAt: DateTime.now(),
          status: status,
        ),
      );

      await deleteTask(taskId);
    }
  }

  Future<void> checkAndMoveExpiredTasks() async {
    final now = Timestamp.now();
    final query = await _firestore
        .collection(_collectionName)
        .where('time', isLessThan: now)
        .get();

    for (final doc in query.docs) {
      await moveExpiredTaskToHistory(doc.id, 'pending');
    }
  }
}