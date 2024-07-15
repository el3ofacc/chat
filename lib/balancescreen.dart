// ignore_for_file: use_build_context_synchronously

import 'package:chat/main.dart';
import 'package:chat/widgets.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Balancescreen extends StatefulWidget {
  const Balancescreen({super.key});

  @override
  State<Balancescreen> createState() => _BalancescreenState();
}

class _BalancescreenState extends State<Balancescreen> {
  @override
  void initState() {
   
    super.initState();
    Provider.of<Change>(context, listen: false).getbalance();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Scaffold(
          body: ListView.builder(
              itemCount: provider.balance.length,
              itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      onTap: () async {
                        DocumentReference<Map<String, dynamic>> element =
                            FirebaseFirestore.instance
                                .collection('balance')
                                .doc(provider.balance[index].id);
                        await FirebaseFirestore.instance
                            .runTransaction((transaction) async {
                          DocumentSnapshot<Map<String, dynamic>> snapshot =
                              await transaction.get(element);
                          if (snapshot.exists) {
                            var snapshotdata = snapshot.data();
                            if (snapshotdata is Map<String, dynamic>) {
                              int money = snapshotdata['balance'] + 100;
                              transaction.update(element, {'balance': money});
                            }
                          }
                        });
                        provider.navigatreplace(context, () => const Balancescreen());
                      },
                      child: Container(
                          height: size.height / 10,
                          width: size.width,
                          color: Colors.red,
                          child: ListTile(
                              title: Mytext(
                                  text: provider.balance[index]['name'],
                                  size: size.height / 30,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                              subtitle: Text(
                                provider.balance[index]['balance'].toString(),
                              ))),
                    ),
                  )),
        );
      },
    );
  }
}
