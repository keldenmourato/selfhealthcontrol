import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:selfhealthcontrol/features/screens/recuperar_senha.dart';
import 'package:selfhealthcontrol/features/screens/tela_registo.dart';

class TelaLogin extends StatefulWidget {
  const TelaLogin({super.key});

  @override
  State<TelaLogin> createState() => _TelaLoginState();
}

class _TelaLoginState extends State<TelaLogin> {


  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();


  login() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(email: email.text, password: password.text);
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
                            Icon(Icons.person, color: Colors.blue,size: 34,),
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
                        Row(
                          children: [
                            SizedBox(width: 10,),
                            Icon(Icons.lock, color: Colors.blue,size:
                              34,),
                            Expanded(
                              child: TextFormField(
                                controller: password,
                                decoration: InputDecoration(
                                  labelText: 'Senha',
                                  border: OutlineInputBorder(),
                                ),
                                obscureText: true,
                              ),
                            ),
                          ],
                        ),
                        //SizedBox(height: 15),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => RecuperarSenha()),
                              );
                            },
                            child: Text("Esqueci-me da palavra-passe",textAlign: TextAlign.end,style: TextStyle(
                              decoration: TextDecoration.underline
                            ),),
                          ),
                        ),

                        
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue,
                            textStyle: TextStyle(fontWeight: FontWeight.bold),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                            
                          ),
                          onPressed: (){
                            login();
                          },
                          child:Text("Login", style: TextStyle(color: Colors.white),),

                        ),
                        TextButton(
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => TelaRegisto()),
                            );
                          },
                          child: Text("Criar uma conta",style: TextStyle(
                              decoration: TextDecoration.underline
                          ),),
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
