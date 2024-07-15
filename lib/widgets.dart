// ignore_for_file: camel_case_types, must_be_immutable, unused_local_variable

import 'package:chat/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';

class textfrom extends StatelessWidget {
  textfrom({
    super.key,
    required this.controllervalue,
    required this.hint,
    required this.lable,
    required this.iconbutton,required this.obsecuretet,
  });
  Widget? iconbutton;
  final TextEditingController controllervalue;
  final String hint;
  final String lable;
  late bool? obsecuretet;
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Consumer<Change>(
      builder: (context, provider, child) {
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            obscureText: obsecuretet!,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return ("Email can't be empty");
              }
              return null;
            },
            keyboardType: TextInputType.emailAddress,
            controller: controllervalue,
            decoration: InputDecoration(
              suffixIcon: iconbutton,
              hintText: hint,
              labelText: lable,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
          ),
        );
      },
    );
  }
}

class Mytext extends StatelessWidget {
  const Mytext(
      {super.key,
      required this.text,
      required this.size,
      required this.fontWeight,
      required this.color});
  final String text;
  final double size;
  final FontWeight fontWeight;
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(fontSize: size, fontWeight: fontWeight, color: color),
    );
  }
}
