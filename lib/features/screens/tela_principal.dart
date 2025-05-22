
import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:selfhealthcontrol/features/screens/tela_perfil.dart';

class TelaPrincipal extends StatefulWidget {
  const TelaPrincipal({super.key});

  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  int _paginaAtual = 0;
  late List<Widget> _telas;

  @override
  void initState() {
    super.initState();

    _telas = [
      TelaAdicionar(),
      TelaRelatorios(),
      TelaHistorico(),
      TelaPerfil()
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _paginaAtual = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Self Health Control'),
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
          Icon(Icons.add, color: Colors.white),
          Icon(Icons.bar_chart, color: Colors.white),
          Icon(Icons.history, color: Colors.white),
          Icon(Icons.person, color: Colors.white),
        ],
      ),
    );
  }
}


class TelaAdicionar extends StatelessWidget {
  const TelaAdicionar({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Adicionar'));
}

class TelaRelatorios extends StatelessWidget {
  const TelaRelatorios({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Relatórios'));
}

class TelaHistorico extends StatelessWidget {
  const TelaHistorico({super.key});

  @override
  Widget build(BuildContext context) => Center(child: Text('Tela Histórico'));
}
