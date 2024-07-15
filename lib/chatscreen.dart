// ignore_for_file: unused_import, use_build_context_synchronously, prefer_const_constructors, avoid_unnecessary_containers

import 'package:chat/main.dart';
import 'package:chat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Chatscreen extends StatefulWidget {
  const Chatscreen({super.key});

  @override
  State<Chatscreen> createState() => _ChatscreenState();
}

class _ChatscreenState extends State<Chatscreen> {
  TextEditingController messagecontroller = TextEditingController();
  Future<void> addmessage(BuildContext context) async {
    try {
      await FirebaseFirestore.instance.collection('messages').add({
        'text': messagecontroller.text,
        "time": FieldValue.serverTimestamp(),
        'sender': FirebaseAuth.instance.currentUser!.email
      });
      messagecontroller.clear();
    } catch (e) {
      Provider.of<Change>(context).alert(context, e, "actiontext1", "ok", () {},
          () {
        Navigator.of(context).pop();
      });
    }
  }

  @override
  void dispose() {
   
    super.dispose();
    messagecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Scaffold(
          body: Column(
            children: [
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('messages')
                      .orderBy('time')
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("an error happend");
                    }
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    }
                    return ListView.builder(
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, index) {
                          var message = snapshot.data!.docs[index];

                          return Align(
                            alignment:
                                FirebaseAuth.instance.currentUser!.email ==
                                        message['sender']
                                    ? Alignment.centerRight
                                    : Alignment.centerLeft,
                            child: InkWell(
                              onLongPress: () async {
                                provider.alert(
                                    context,
                                    snapshot.data!.docs[index]['text'],
                                    "update",
                                    "delete", () {
                                  Navigator.of(context).pop();
                                }, () async {
                                  await FirebaseFirestore.instance
                                      .collection('messages')
                                      .doc(snapshot.data!.docs[index].id)
                                      .delete();
                                  Navigator.of(context).pop();
                                });
                              },
                              child: Container(
                                child: Mytext(
                                    text: message['text'],
                                    size: size.height / 30,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red),
                              ),
                            ),
                          );
                        });
                  },
                ),
              ),
              textfrom(
                  controllervalue: messagecontroller,
                  hint: "type message",
                  lable: "message",
                  iconbutton: InkWell(
                      onTap: () {
                        addmessage(context);
                      },
                      child: Icon(Icons.send)), obsecuretet: false)
            ],
          ),
        );
      },
    );
  }
}
