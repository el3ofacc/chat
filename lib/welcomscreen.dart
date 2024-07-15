// ignore_for_file: prefer_const_constructors, unused_import

import 'package:chat/balancescreen.dart';
import 'package:chat/homepage.dart';
import 'package:chat/innerpage.dart';
import 'package:chat/market.dart';
import 'package:chat/signup.dart';
import 'package:chat/taskscreen.dart';
import 'package:chat/widgets.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';

class Welcomescreen extends StatefulWidget {
  const Welcomescreen({super.key});

  @override
  State<Welcomescreen> createState() => _WelcomescreenState();
}

class _WelcomescreenState extends State<Welcomescreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<int> counteranimation;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(vsync: this, duration: Duration(seconds: 2));
    counteranimation = IntTween(begin: 5, end: 1).animate(animationController);
    animationController.forward();

    final user = FirebaseAuth.instance.currentUser;
    animationController.addStatusListener(
      (status) {
        if (status == AnimationStatus.completed) {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (context) {
            return //Market(); //Taskscreen();
            (user != null && user.email != null)
                ? const Homepage()
                : const Signup();
          }));
        }
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedBuilder(
            animation: animationController,
            builder: (context, child) {
              return Center(
                child: CircleAvatar(
                  backgroundColor: Colors.orange,
                  radius: 50,
                  child: Text(counteranimation.value.toString()),
                ),
              );
            })
      ],
    ));
  }
}
