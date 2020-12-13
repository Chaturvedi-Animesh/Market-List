
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

import 'list.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Market List"),
          centerTitle: true,
        ),
        body: MyList(),
      ),
    );
  }
}

