import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/modelo_historico.dart';

class HistoryService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collectionName = 'history';

  Future<String> addToHistory(HistoryTask historyTask) async {
    final docRef = await _firestore
        .collection(_collectionName)
        .add(historyTask.toMap());
    return docRef.id;
  }

  Future<void> updateHistoryStatus(String id, String newStatus) async {
    await _firestore
        .collection(_collectionName)
        .doc(id)
        .update({'status': newStatus});
  }

  Stream<List<HistoryTask>> getHistory() {
    return _firestore
        .collection(_collectionName)
        .orderBy('completedAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => HistoryTask.fromMap(doc.data(), doc.id))
        .toList());
  }

  Future<void> deleteFromHistory(String id) async {
    await _firestore.collection(_collectionName).doc(id).delete();
  }
}