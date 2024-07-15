
// ignore_for_file: prefer_const_constructors

import 'package:chat/homepage.dart';
import 'package:chat/main.dart';
import 'package:chat/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passwordcontrol = TextEditingController();
  final GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Consumer<Change>(builder: (context, provider, child) {
      return Scaffold(
        body: Form(
          key: formstate,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                "Sign In",
                style: TextStyle(fontSize: 40, color: Colors.red),
              ),
              const SizedBox(height: 20),
              textfrom( controllervalue: emailcontrol,
               hint: 'example@gmail.com',
                lable: 'email',
                iconbutton: null, obsecuretet: false,),
              const SizedBox(height: 20),
              textfrom(controllervalue: passwordcontrol, hint: '********', lable: 'password', iconbutton: IconButton(
                onPressed: () {
                  provider.changesecure();
                },
                icon: Icon(
                  provider.secure ? Icons.visibility_off : Icons.visibility,
                ),
              ), obsecuretet: provider.secure,),
             
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () {
                        try {
                          if(formstate.currentState!.validate()){FirebaseAuth.instance
                              .sendPasswordResetEmail(email: emailcontrol.text);
                          provider.scaffoldmessanger(
                              context, 'Password reset email sent');
                              }
                          
                        } catch (e) {
                          provider.alert(context, e, '', 'ok', () {
                            return;
                          }, () {
                            return;
                          });
                         
                        }
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (formstate.currentState!.validate()) {
                    provider.signinwithemailandpassword(
                        emailcontrol,
                        passwordcontrol,
                        context,
                        () => Homepage(),
                        'Check your email for verification',
                        '',
                        'ok', () {
                      return;
                    }, () {
                      return;
                    });
                  }
                },
                style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white, fontSize: 30),
                ),
              ),
              const SizedBox(height: 30),
              InkWell(
                onTap: () {
                  provider.signinwithgoogle(context, () => Homepage(), '', 'ok',
                      () {
                    return;
                  }, () {
                    return;
                  });
                },
                child: Card(color: Colors.blue,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("or signin with google",
                    style:  TextStyle(fontSize: 30,fontWeight: FontWeight.bold,color: Colors.white),),
                  ),
                )
               
              ),
            ],
          ),
        ),
      );
    });
  }
}
 