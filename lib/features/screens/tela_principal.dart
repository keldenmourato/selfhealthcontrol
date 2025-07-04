
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:selfhealthcontrol/features/screens/tela_historico.dart';
import 'package:selfhealthcontrol/features/screens/tela_lista_tarefas.dart';
import 'package:selfhealthcontrol/features/screens/tela_perfil.dart';
import 'package:selfhealthcontrol/features/services/notificacoes.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _paginaAtual = 1;
  late List<Widget> _telas;

  @override
  void initState() {
    super.initState();

    _telas = [
      TelaTarefas(),      // index 0
      TelaHistorico(),    // index 1
      TelaPerfil(),       // index 2
    ];

  }

  void _onItemTapped(int index) {
    setState(() {
      _paginaAtual = index;
    });
  }
  void signOut() async{
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self Health Control'),
        actions: [
          IconButton(onPressed: signOut, icon: const Icon(Icons.exit_to_app)),
        ],
        backgroundColor: Colors.green,
        centerTitle: true,
      ),
      body: IndexedStack(
        index: _paginaAtual,
        children: _telas,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        color: Colors.blue,
        backgroundColor: Colors.transparent,
        buttonBackgroundColor: Colors.green,
        animationDuration: Duration(milliseconds: 300),
        index: _paginaAtual,
        onTap: _onItemTapped,
        items: [
          Icon(Icons.task, color: Colors.white),     // TelaTarefas
          Icon(Icons.history, color: Colors.white),  // TelaHistorico
          Icon(Icons.person, color: Colors.white),   // TelaPerfil
        ],

      ),
    );
  }
}


/*class TelaAdicionar extends StatelessWidget {
  const TelaAdicionar({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Adicionar'));
}

class TelaRelatorios extends StatelessWidget {
  const TelaRelatorios({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Relatórios'));
}*/
/*
class TelaHistorico extends StatelessWidget {
  const TelaHistorico({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Histórico'));
}*/
