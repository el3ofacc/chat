// ignore_for_file: sized_box_for_whitespace, prefer_const_constructors

import 'package:chat/main.dart';
import 'package:chat/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Subscreen extends StatefulWidget {
  const Subscreen(
      {super.key, required this.oldindex, required this.mostoldindex});
  final int oldindex;
  final int mostoldindex;
  @override
  State<Subscreen> createState() => _SubscreenState();
}

class _SubscreenState extends State<Subscreen> {
  TextEditingController subcontroller = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<Change>(context, listen: false).getsubdata(
        mostoldindex: widget.mostoldindex, oldindex: widget.oldindex);
  }

  GlobalKey<FormState> formstate = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Form(
          key: formstate,
          child: Scaffold(
            backgroundColor: provider.dark ? Colors.black : Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.red,
              title: Center(
                child: Mytext(
                    text:
                        "${provider.data[widget.mostoldindex]['place']} > ${provider.taskdata[widget.oldindex]['name']}",
                    size: size.height / 40,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                showModalBottomSheet(
                    context: context,
                    builder: (context) => Container(
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
                              textfrom(obsecuretet: false,
                                  controllervalue: subcontroller,
                                  hint: "add catagory",
                                  lable: "catagory",
                                  iconbutton: null),
                              SizedBox(
                                height: size.width / 20,
                              ),
                              ElevatedButton(
                                  onPressed: () {
                                    try {
                                      if (formstate.currentState!.validate()) {
                                        provider.addsubdata(
                                            mostoldindex: widget.mostoldindex,
                                            oldindex: widget.oldindex,
                                            subcontroller: subcontroller);
                                        provider.scaffoldmessanger(context,
                                            "${subcontroller.text} has been added");
                                        provider.getsubdata(
                                            mostoldindex: widget.mostoldindex,
                                            oldindex: widget.oldindex);
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
                        ));
              },
              child: Icon(
                Icons.add,
                size: 50,
                color: Colors.red,
              ),
            ),
            body: GridView.builder(
                itemCount: provider.subdata.length,
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                    crossAxisSpacing: 20,
                    maxCrossAxisExtent: size.width / 2,
                    mainAxisSpacing: 20),
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onLongPress: () {
                        provider.alert(
                          context,
                          provider.subdata[index]['data'],
                          "update",
                          "delete",
                          () {
                            Navigator.of(context).pop();
                            showModalBottomSheet(
                                context: context,
                                builder: (context) => Container(
                                      width: size.width,
                                      color: Colors.purple,
                                      child: Column(
                                        children: [
                                          Mytext(
                                              text: 'update the catagory',
                                              size: size.height / 30,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.red),
                                          textfrom(obsecuretet: false,
                                              controllervalue: subcontroller,
                                              hint: "update catagory",
                                              lable: "catagory",
                                              iconbutton: null),
                                          ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor:
                                                      Colors.orange),
                                              onPressed: () {
                                                try {
                                                  if (formstate.currentState!
                                                      .validate()) {
                                                    provider.updatesubdata(
                                                        widget.mostoldindex,
                                                        widget.oldindex,
                                                        index,
                                                        subcontroller);
                                                    provider.scaffoldmessanger(
                                                        context,
                                                        "${provider.subdata[index]['data']} has been updated");
                                                    provider.getsubdata(
                                                        mostoldindex:
                                                            widget.mostoldindex,
                                                        oldindex:
                                                            widget.oldindex);
                                                    Navigator.of(context).pop();
                                                  }
                                                } catch (e) {
                                                  provider.alert(context, e, "",
                                                      "ok", () {}, () {
                                                    Navigator.of(context).pop();
                                                  });
                                                }
                                              },
                                              child: Mytext(
                                                  text: 'update',
                                                  size: size.height / 20,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white))
                                        ],
                                      ),
                                    ));
                          },
                          () {
                            try {
                              provider.deletesubdata(
                                  widget.mostoldindex, widget.oldindex, index);
                              provider.scaffoldmessanger(context,
                                  "${provider.subdata[index]['data']} has been deleted");
                              provider.getsubdata(
                                  mostoldindex: widget.mostoldindex,
                                  oldindex: widget.oldindex);
                              Navigator.of(context).pop();
                            } catch (e) {
                              provider.alert(context, e, "", "ok", () {}, () {
                                Navigator.of(context).pop();
                              });
                            }
                          },
                        );
                      },
                      onTap: () {},
                      child: Card(
                        child: Center(
                          child: Mytext(
                              text: provider.subdata[index]['data'],
                              size: size.height / 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.red),
                        ),
                      ),
                    ),
                  );
                }),
          ),
        );
      },
    );
  }
}
