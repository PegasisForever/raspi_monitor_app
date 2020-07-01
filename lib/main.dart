import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/licence.dart';
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/homepage/HomePage.dart';
import 'package:syncfusion_flutter_core/core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
  initSharedPrefs();
  initPackageInfo();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var darkTheme = ThemeData.dark();
    darkTheme = darkTheme.copyWith(
      accentColor: Colors.blue,
      colorScheme: darkTheme.colorScheme.copyWith(secondary: Colors.blue),
    );
    return MaterialApp(
      title: 'Raspberry Pi Monitor',
      theme: ThemeData.light(),
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}
