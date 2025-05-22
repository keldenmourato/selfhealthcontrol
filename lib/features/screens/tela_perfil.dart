import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selfhealthcontrol/features/components/text_box.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TelaPerfil extends StatefulWidget {
  const TelaPerfil({super.key});

  @override
  State<TelaPerfil> createState() => _TelaPerfilState();
}

class _TelaPerfilState extends State<TelaPerfil> {
  final user = FirebaseAuth.instance.currentUser!;
  final userCollection = FirebaseFirestore.instance.collection('Users');

  Future<void> editarCampo(String campo) async {
    String novoValor = '';

    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Editar $campo'),
        content: TextField(
          autofocus: true,
          decoration: InputDecoration(hintText: 'Digite novo(a) $campo'),
          onChanged: (value) => novoValor = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, novoValor),
            child: const Text('Salvar'),
          ),
        ],
      ),
    );

    if (result != null && result.trim().isNotEmpty) {
      await userCollection.doc(user.email).update({campo: result});
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$campo atualizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<DocumentSnapshot>(
        stream: userCollection.doc(user.email).snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(
                child: Column(
                  children: [
                    const Text('Dados do usuário não encontrados'),
                  ],
                )
            );
          }

          final userData = snapshot.data!.data() as Map<String, dynamic>? ?? {};

          return ListView(
            children: [
              const SizedBox(height: 50),

              // Foto do perfil
              const Icon(Icons.person, size: 72),

              // Email
              Text(
                user.email!,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey[700]),
              ),

              const SizedBox(height: 50),

              // Detalhes do perfil
              const Padding(
                padding: EdgeInsets.only(left: 25.0),
                child: Text(
                  'Detalhes',
                  style: TextStyle(color: Colors.grey),
                ),
              ),

              // Campos editáveis
              Row(
                children: [
                  Expanded(
                      child: MyTextBox(
                        text: userData['nome']?.toString() ?? 'Não definido',
                        sectionName: 'Nome',
                        onPressed: () => editarCampo('nome'),
                      ),
                  ),
                  Expanded(
                      child: MyTextBox(
                        text: userData['sobrenome']?.toString() ?? 'Não definido',
                        sectionName: 'Sobrenome',
                        onPressed: () => editarCampo('sobrenome'),
                      ),
                  )
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextBox(
                      text: userData['idade']?.toString() ?? 'Não definido',
                      sectionName: 'Idade',
                      onPressed: () => editarCampo('idade'),
                    ),
                  ),

                  Expanded(
                    child: MyTextBox(
                      text: userData['peso']?.toString() ?? 'Não definido',
                      sectionName: 'Peso',
                      onPressed: () => editarCampo('peso'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextBox(
                      text: userData['telefone']?.toString() ?? 'Não definido',
                      sectionName: 'Telefone',
                      onPressed: () => editarCampo('telefone'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextBox(
                      text: userData['grupo_sanguineo']?.toString() ?? 'Não definido',
                      sectionName: 'Grupo Sanguineo',
                      onPressed: () => editarCampo('grupo_sanguineo'),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: MyTextBox(
                      text: userData['doenca_cronica']?.toString() ?? 'Não definido',
                      sectionName: 'Doenca Cronica',
                      onPressed: () => editarCampo('doenca_cronica'),
                    ),
                  ),
                ],
              ),
              Row(

                children: [
                  Expanded(
                    child: MyTextBox(
                      text: userData['historico_medico']?.toString() ?? 'Não definido',
                      sectionName: 'Historico Medico',
                      onPressed: () => editarCampo('historico_medico'),
                    ),
                  ),
                ],
              )

            ],
          );
        },
      ),
    );
  }
}