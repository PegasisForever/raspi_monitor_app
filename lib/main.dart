import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/ui/homepage/HomePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Raspberry Pi Monitor',
      home: HomePage(),
    );
  }
}

