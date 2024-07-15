// ignore_for_file: unused_import, prefer_const_constructors, unused_local_variable, sized_box_for_whitespace, sort_child_properties_last

import 'dart:io';

import 'package:chat/chatscreen.dart';
import 'package:chat/market.dart';

import 'package:chat/main.dart';
import 'package:chat/signin.dart';
import 'package:chat/taskscreen.dart';
import 'package:chat/webpage.dart';
import 'package:chat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  

  void gettoken() async {
    var token = FirebaseMessaging.instance.getToken();
  }

  void getpermision() async {
    await FirebaseMessaging.instance.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    var forgroundmessage =
        FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      Provider.of<Change>(context)
          .alert(context, message.notification!.body, "", "ok", () {}, () {
        Navigator.of(context).pop();
      });
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Provider.of<Change>(context).navigate(context, () => Chatscreen());
    });
  }
Future<bool> onwillpop() async {
    return await showDialog(
        context: context,
        builder: (context) => AlertDialog(
              content: Mytext(
                  text: 'are you sure you want to exit from the app ?',
                  size: 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.red),
              actions: [
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(true);
                    },
                    child: const Text("yes")),
                TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                    child: const Text("no"))
              ],
            ));
  }
  @override
  void initState() {
    super.initState();
    getpermision();
    gettoken();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return DefaultTabController(
      length: 3, //2,
      // ignore: deprecated_member_use
      child: WillPopScope(onWillPop: onwillpop,
        child: Consumer<Change>(
          builder: (context, provider, child) {
            return Scaffold(
              backgroundColor: provider.dark ? Colors.black : Colors.white,
              drawer: Drawer(
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      height: 100,
                      color: Colors.brown,
                      child: const Icon(
                        Icons.settings,
                        size: 50,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            InkWell(
                                onTap: () {
                                  provider.logout(
                                      context,
                                      'do you want to logout ?',
                                      'no',
                                      'yes', () {
                                    provider.navigate(
                                        context, () => const Homepage());
                                  }, () {
                                    provider.navigate(
                                        context, () => const Signin());
                                  });
                                },
                                child: const Icon(
                                  Icons.logout,
                                  size: 40,
                                )),
                            const SizedBox(
                              width: 20,
                            ),
                            const Text("logout")
                          ],
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: IconButton(
                              onPressed: () {},
                              icon: const Icon(
                                Icons.dark_mode,
                                size: 50,
                              )),
                        ),
                        const Text("dark mode"),
                        Checkbox(
                          value: provider.dark,
                          onChanged: (value) {
                            provider.changedark(value!);
                          },
                        )
                      ],
                    )
                  ],
                ),
              ),
              appBar: AppBar(
                actions: [
                  CircleAvatar(
                    //backgroundColor: Colors.black,
                    radius: size.width / 8,
                    child: provider.file == null
                        ? InkWell(
                            onTap: () {
                              try {
                                provider.alert(
                                    context, "add picture", "gallery", "camera",
                                    () {
                                  provider.getimage(iscamera: false);
                                  Navigator.of(context).pop();
                                }, () {
                                  provider.getimage(iscamera: true);
                                  Navigator.of(context).pop();
                                });
                              } catch (e) {
                                provider.alert(context, e, "", "ok", () {}, () {
                                  Navigator.of(context).pop();
                                });
                              }
                            },
                            child: Expanded(
                              child: Icon(
                                Icons.image,
                                //  size: size.width / 10,
                                color: Colors.purple,
                              ),
                            ))
                        : ClipOval(
                            child: AspectRatio(
                                aspectRatio: 1,
                                child: InkWell(
                                  onTap: () {
                                    showModalBottomSheet(
                                        context: context,
                                        builder: (context) =>
                                            ListView(children: [
                                              Container(
                                                child: Column(
                                                  children: [
                                                    Image.file(
                                                      provider
                                                          .file!, //-------------------
                                                      fit: BoxFit.cover,
                                                    ),
                                                    Row(children: [
                                                      TextButton(
                                                          onPressed: () {
                                                            Navigator.of(
                                                                    context)
                                                                .pop();
                                                          },
                                                          child:
                                                              Text("cancel")),
                                                      TextButton(
                                                          onPressed: () {
                                                            provider.alert(
                                                                context,
                                                                "image from ...",
                                                                "camera",
                                                                "gallery", () {
                                                              provider.getimage(
                                                                  iscamera:
                                                                      true);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            }, () {
                                                              provider.getimage(
                                                                  iscamera:
                                                                      false);
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                            });
                                                          },
                                                          child: Text("update"))
                                                    ])
                                                  ],
                                                ),
                                                width: size.width,
                                              ),
                                            ]));
                                  },
                                  child: Image.file(
                                    provider
                                        .file!, //---------------------------------
                                    fit: BoxFit.cover,
                                  ),
                                ))),
                  )
                ],
                backgroundColor: Colors.cyan,
                bottom: TabBar(tabs: [
                  Tab(
                    icon: Icon(
                      Icons.home,
                      color: Colors.red,
                      size: size.width / 15,
                    ),
                    //    text: "home page",
                  ),
                  Tab(
                    icon: Icon(
                      Icons.task,
                      size: size.width / 15,
                      color: Colors.red,
                    ),
                    //  text: 'notes',
                  ),
                  Tab(
                    icon: Icon(
                      Icons.chat,
                      color: Colors.red,
                      size: size.width / 15,
                    ),
                    //text: "chats",
                  )
                ]),
              ),
              body: const TabBarView(
                children: [Webpage(), Taskscreen(), Chatscreen()],
              ),
            );
          },
        ),
      ),
    );
  }
}
