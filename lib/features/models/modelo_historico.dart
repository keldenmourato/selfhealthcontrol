import 'package:cloud_firestore/cloud_firestore.dart';

class HistoryTask {
  final String? id;
  final String originalTaskId;
  final String title;
  final String description;
  final DateTime scheduledTime;
  final DateTime completedAt;
  final String status; // 'completed' ou 'pending'

  HistoryTask({
    this.id,
    required this.originalTaskId,
    required this.title,
    required this.description,
    required this.scheduledTime,
    required this.completedAt,
    required this.status,
  });

  factory HistoryTask.fromMap(Map<String, dynamic> map, String id) {
    return HistoryTask(
      id: id,
      originalTaskId: map['originalTaskId'],
      title: map['title'],
      description: map['description'],
      scheduledTime: (map['scheduledTime'] as Timestamp).toDate(),
      completedAt: (map['completedAt'] as Timestamp).toDate(),
      status: map['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'originalTaskId': originalTaskId,
      'title': title,
      'description': description,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
      'completedAt': Timestamp.fromDate(completedAt),
      'status': status,
    };
  }
}