// ignore_for_file: unnecessary_import, unused_import, prefer_const_constructors

import 'package:chat/homepage.dart';
import 'package:chat/main.dart';

import 'package:chat/signin.dart';
import 'package:chat/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  TextEditingController emailcontrol = TextEditingController();
  TextEditingController passwordcontrol = TextEditingController();
  GlobalKey<FormState> formstate = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Form(
            key: formstate,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "sign up",
                  style: TextStyle(fontSize: 40, color: Colors.red),
                ),
                const SizedBox(
                  height: 20,
                ),
                textfrom(controllervalue: emailcontrol,obsecuretet: false,
                 hint: 'example@gmail.com',
                  lable: 'email', 
                  iconbutton:null),
                 
                const SizedBox(
                  height: 20,
                ),
                textfrom(obsecuretet: provider.secure,controllervalue: passwordcontrol, 
                hint: '*******', lable: 'password', 
                iconbutton: IconButton(
                            onPressed: () {
                              provider.changesecure();
                            },
                            icon: Icon(provider.secure
                                ? Icons.visibility_off
                                : Icons.visibility)),
                         
                  ),
               
                SizedBox(
                  height: size.width / 20,
                ),
                ElevatedButton(
                    onPressed: () async {
                      if (formstate.currentState!.validate()) {
                        provider.createuserwithemailandpassword(
                            emailcontrol.text, passwordcontrol.text, context,()=>Homepage());
                      }
                      if (FirebaseAuth.instance.currentUser != null) {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Homepage()));
                      }
                    },
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                    child: Mytext(text: 'sign up', 
                  size  : size.height / 20,
                   fontWeight: FontWeight.bold,
                    color: Colors.red)
                   
                    ),//),
                SizedBox(
                  height: size.height / 20,
                ),
                InkWell(
                    onTap: () {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const Signin()));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(size.width / 20),
                      child: Container(
                        color: Colors.blue,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Mytext(text: 'have an account ?',
                           size:size.height / 25 ,
                            fontWeight: FontWeight.bold,
                             color: Colors.red)
                           
                        ),
                      ),
                    )),
                SizedBox(
                  height: size.height / 20,
                ),
              
              ],
            ),
          ),
        );
      },
    );
  }
}
