import 'package:flutter/material.dart';
import 'package:seagate_fast_qr_track/screens/home.dart';
 

void main() {

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
    );
  } 
}
