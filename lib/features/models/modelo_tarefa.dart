import 'package:cloud_firestore/cloud_firestore.dart';

class Task {
  final String? id;
  final String title;
  final String description;
  final DateTime time;
  final DateTime createdAt;

  Task({
    this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.createdAt,
  });

  factory Task.fromMap(Map<String, dynamic> map, String id) {
    return Task(
      id: id,
      title: map['title'],
      description: map['description'],
      time: (map['time'] as Timestamp).toDate(),
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'description': description,
      'time': Timestamp.fromDate(time),
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}