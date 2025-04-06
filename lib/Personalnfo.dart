import 'package:flutter/material.dart';

class Personalnfo extends StatelessWidget {
  const Personalnfo({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Personal_Info());
  }
}

class Personal_Info extends StatefulWidget {
  const Personal_Info({super.key});

  @override
  State<Personal_Info> createState() => _Personal_InfoState();
}

class _Personal_InfoState extends State<Personal_Info> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(child: Text('This is the personal info page ')));
  }
}
