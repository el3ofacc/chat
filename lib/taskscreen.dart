// ignore_for_file: prefer_const_constructors, unused_import, sized_box_for_whitespace

import 'package:chat/homepage.dart';
import 'package:chat/innerpage.dart';
import 'package:chat/main.dart';
import 'package:chat/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Taskscreen extends StatefulWidget {
  const Taskscreen({super.key});

  @override
  State<Taskscreen> createState() => _TaskscreenState();
}

class _TaskscreenState extends State<Taskscreen> {
  TextEditingController catagory = TextEditingController();
  TextEditingController updatecontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    Provider.of<Change>(context, listen: false).getdata();
  }

  GlobalKey<FormState> fromstate = GlobalKey<FormState>();
  @override
  void dispose() {
     
    super.dispose();
    updatecontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Scaffold(
          backgroundColor: provider.dark ? Colors.black : Colors.white,
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  context: context,
                  builder: (context) => Form(
                        key: fromstate,
                        child: Container(
                          color: Colors.cyan,
                          width: size.width,
                          child: Column(
                            children: [
                              Mytext(
                                  text: "add text",
                                  size: size.width / 10,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              SizedBox(
                                height: size.width / 20,
                              ),
                              textfrom(
                                  controllervalue: catagory,
                                  hint: "add catagory",
                                  lable: "catagory",
                                  iconbutton: null, obsecuretet: false,),
                              SizedBox(
                                height: size.width / 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    try {
                                      if (fromstate.currentState!.validate()) {
                                        provider.adddata(
                                            catagory: catagory,
                                            context: context);
                                        provider.scaffoldmessanger(context,
                                            "${catagory.text} has been added");
                                        provider.getdata();
                                        Navigator.of(context).pop();
                                      }
                                    } catch (e) {
                                      provider.alert(
                                          context, e, "", "ok", () {}, () {
                                        Navigator.of(context).pop();
                                      });
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.blue),
                                  child: Mytext(
                                      text: 'add',
                                      size: size.width / 10,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          ),
                        ),
                      ));
            },
            child: Icon(
              Icons.add,
              size: 50,
              color: Colors.red,
            ),
          ),
          body: GridView.builder(
              itemCount: provider.data.length,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  crossAxisSpacing: 20,
                  maxCrossAxisExtent: size.width / 2,
                  mainAxisSpacing: 20),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onLongPress: () {
                      provider.alert(context, provider.data[index]['place'],
                          "update", "delete", () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Form(
                                  key: fromstate,
                                  child: Container(
                                    width: size.width,
                                    child: Column(
                                      children: [
                                        Mytext(
                                            text: "update catagory",
                                            size: size.height / 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black),
                                        textfrom(
                                            controllervalue: updatecontroller,
                                            hint: "update catagory",
                                            lable: "catagory",
                                            iconbutton: null, obsecuretet: false,),
                                        ElevatedButton(
                                            onPressed: () {
                                              try {
                                                if (fromstate.currentState!
                                                    .validate()) {
                                                  provider.update(
                                                      index: index,
                                                      updatecontroller:
                                                          updatecontroller);
                                                  provider.scaffoldmessanger(
                                                      context,
                                                      "${provider.data[index]['place']} has been updated");
                                                  provider.getdata();
                                                  Navigator.of(context).pop();
                                                }
                                              } catch (e) {
                                                provider.alert(
                                                    context, e, "", "ok", () {},
                                                    () {
                                                  Navigator.of(context).pop();
                                                });
                                              }
                                            },
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.blue),
                                            child: Mytext(
                                                text: "update",
                                                size: size.width / 30,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white))
                                      ],
                                    ),
                                  ),
                                ));
                      }, () {
                        try {
                          provider.deletedata(index);
                          provider.scaffoldmessanger(context,
                              "${provider.taskdata[index]['name']} has been deleted");
                          provider.getdata();
                          Navigator.of(context).pop();
                        } catch (e) {
                          provider.alert(context, e, "", "ok", () {}, () {
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                    onTap: () {
                      provider.navigate(
                          context,
                          () => Innerpage(
                                oldindex: index,
                              ));
                    },
                    child: Card(
                      child: Center(
                        child: Mytext(
                            text: provider.data[index]['place'],
                            size: size.height / 30,
                            fontWeight: FontWeight.bold,
                            color: Colors.red),
                      ),
                    ),
                  ),
                );
              }),
        );
      },
    );
  }
}
