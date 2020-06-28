import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/licence.dart';
import 'package:raspi_monitor_app/ui/homepage/HomePage.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() {
  SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
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

