import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RecuperarSenha extends StatefulWidget {
  const RecuperarSenha({super.key});

  @override
  State<RecuperarSenha> createState() => _RecuperarSenhaState();
}

class _RecuperarSenhaState extends State<RecuperarSenha> {


  TextEditingController email = TextEditingController();

  recuperar() async {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Image.asset('assets/logotipo/SelfHealthControl.png'),

                SizedBox(height: 12),
                Form(
                    child:Column(
                      children: [
                        Row(
                          children: [

                            SizedBox(width: 10,),
                            Icon(Icons.email, color: Colors.blue,size: 34,),
                            Expanded(
                              child: TextFormField(
                                controller: email,
                                decoration: InputDecoration(
                                  labelText: 'usuario@gmail.com',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10,),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),

                          ),
                          onPressed: (){
                            recuperar();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Email enviado!', style: TextStyle(color: Colors.green),),
                                duration: Duration(seconds: 5),
                              )
                            );
                          },
                          child:Text("Enviar", style: TextStyle(color: Colors.white),),

                        ),
                      ],
                    )
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
