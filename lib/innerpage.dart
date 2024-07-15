// ignore_for_file: unused_import, prefer_const_constructors, empty_catches

import 'package:chat/main.dart';
import 'package:chat/subscreen.dart';
import 'package:chat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Innerpage extends StatefulWidget {
  const Innerpage({
    super.key,
    required this.oldindex,
  });
  final int? oldindex;

  @override
  State<Innerpage> createState() => _InnerpageState();
}

class _InnerpageState extends State<Innerpage> {
  TextEditingController place = TextEditingController();
  //TextEditingController catagorycontroller = TextEditingController();

  @override
  void initState() {
    super.initState();

    Provider.of<Change>(context, listen: false)
        .getinnerdata(oldindex: widget.oldindex!);
  } //-------------------------------------------------------

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  void dispose() {
   
    super.dispose();
    place.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Form(
          key: formstate,
          child: Scaffold(
            backgroundColor: provider.dark ? Colors.black : Colors.white,
            floatingActionButton: FloatingActionButton(
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.red,
              ),
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
                          color: Colors.teal,
                          width: size.width,
                          child: Column(
                            children: [
                              Mytext(
                                  text: 'add catagory',
                                  size: size.height / 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red),
                              textfrom(
                                  controllervalue: place,
                                  hint: "add catagory",
                                  lable: "catagory",
                                  iconbutton: null, obsecuretet: false,),
                              ElevatedButton(
                                  onPressed: () {
                                    try {
                                      if (formstate.currentState!.validate()) {
                                        provider.addinnercatagory(
                                            widget.oldindex!, place);
                                        provider.scaffoldmessanger(context,
                                            "${place.text} has been added");
                                        provider.getinnerdata(
                                            oldindex: widget.oldindex!);
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
                                      text: "add catagory",
                                      size: size.height / 30,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white))
                            ],
                          ),
                        ));
              },
            ),
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Mytext(
                  text: provider.data[widget.oldindex!]['place'],
                  size: size.height / 30,
                  fontWeight: FontWeight.bold,
                  color: Colors.white),
            ),
            body: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      provider.navigate(
                          context,
                          () => Subscreen(
                                oldindex: index,
                                mostoldindex: widget.oldindex!,
                              ));
                    },
                    onLongPress: () {
                      provider.alert(
                          context,
                          provider.taskdata[index]
                              ['name'], //------------------------------------
                          "update",
                          "delete", () {
                        Navigator.of(context).pop();
                        showModalBottomSheet(
                            context: context,
                            builder: (context) => Container(
                                  width: size.width,
                                  color: Colors.blue,
                                  child: Column(
                                    children: [
                                      Mytext(
                                          text: 'update place',
                                          size: size.width / 10,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.red),
                                      textfrom(obsecuretet: false,
                                          controllervalue: place,
                                          hint: 'catagory',
                                          lable: "catagory",
                                          iconbutton: null),
                                      ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.green),
                                          onPressed: () {
                                            try {
                                              if (formstate.currentState!
                                                  .validate()) {
                                                provider.updateinnerdata(
                                                    widget.oldindex!,
                                                    index,
                                                    place);
                                                provider.scaffoldmessanger(
                                                    context,
                                                    "${provider.taskdata[index]['name']} has been updated");
                                                provider.getinnerdata(
                                                    oldindex: widget.oldindex!);
                                              }
                                            } catch (e) {}
                                            Navigator.of(context).pop();
                                          },

                                          //  },
                                          child: Mytext(
                                              text: 'update',
                                              size: size.width / 10,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white))
                                    ],
                                  ),
                                ));
                      }, () {
                        try {
                          Navigator.of(context).pop();
                          provider.deleteinnerdata(
                              index: index, oldindex: widget.oldindex!);
                          provider.scaffoldmessanger(context,
                              "${provider.taskdata[index]['name']} has been deleted");
                          provider.getinnerdata(oldindex: widget.oldindex!);
                        } catch (e) {
                          provider.alert(context, e, "", "ok", () {}, () {
                            Navigator.of(context).pop();
                          });
                        }
                      });
                    },
                    child: Container(
                      height: size.height / 8,
                      width: size.width,
                      color: Colors.blue,
                      child: Mytext(
                          text: provider.taskdata[index]['name'],
                          size: size.width / 10,
                          fontWeight: FontWeight.bold,
                          color: Colors.red),
                    ),
                  ),
                );
              },
              itemCount: provider
                  .taskdata.length, //-----------------------------------------
            ),
          ),
        );
      },
    );
  }
}
