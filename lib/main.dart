import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:selfhealthcontrol/features/auth/wrapper.dart';
import 'package:selfhealthcontrol/firebase_options.dart';

import 'features/services/historico.dart';
import 'features/services/notificacoes.dart';
import 'features/services/tarefas.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform
  );
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );

  final notificationService = NotificationService();
  await notificationService.initialize();

  // Verifica tarefas expiradas ao iniciar o app
  final taskService = TaskService();
  await taskService.checkAndMoveExpiredTasks();

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => notificationService),
        Provider(create: (_) => taskService),
        Provider(create: (_) => HistoryService()),
      ],
      child: const MyApp(),
    ),
  );
}
class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      home: Wrapper(),
      debugShowMaterialGrid: false,
      debugShowCheckedModeBanner: false,
    );
  }
}
