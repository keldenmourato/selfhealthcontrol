import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:selfhealthcontrol/features/auth/wrapper.dart';
import 'package:selfhealthcontrol/features/screens/tela_login.dart';

class TelaRegisto extends StatefulWidget {
  const TelaRegisto({super.key});



  @override
  State<TelaRegisto> createState() => _TelaRegistoState();
}

class _TelaRegistoState extends State<TelaRegisto> {

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  registo() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(email: email.text, password: password.text);
    Get.offAll(Wrapper());
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
                                    labelText: 'email@gmail.com',
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
                              Icon(Icons.lock, color: Colors.blue,size:34,),
                              Expanded(
                                child: TextFormField(
                                  controller: password,
                                  decoration: InputDecoration(
                                    labelText: 'palavra-passe',
                                    border: OutlineInputBorder(),
                                  ),
                                  obscureText: true,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20,),

                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue,
                              textStyle: TextStyle(fontWeight: FontWeight.bold),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),

                            ),
                            onPressed: (){
                              registo();
                            },
                            child:Text("Registar", style: TextStyle(color: Colors.white),),

                          ),
                          TextButton(
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => TelaLogin()),
                              );
                            },
                            child: Text("Já possui uma conta? faça login",style: TextStyle(
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
        )
    );
  }
}
