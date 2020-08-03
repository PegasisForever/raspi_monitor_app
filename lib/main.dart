import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/licence.dart';
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/homepage/HomePage.dart';
import 'package:syncfusion_flutter_core/core.dart';

GlobalKey<MyAppState> appKey = GlobalKey();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  FlutterError.onError = Crashlytics.instance.recordFlutterError;
  SyncfusionLicense.registerLicense(SyncfusionCommunityLicenceKey);
  await initSharedPrefs();
  initPackageInfo();
  runApp(MyApp(key: appKey));
}

class MyApp extends StatefulWidget {
  MyApp({Key key}) : super(key: key);

  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {
  ThemeMode _themeMode;

  @override
  void initState() {
    _getThemeMode();
    super.initState();
  }

  void _getThemeMode() {
    final darkModeSettings = prefs.getInt("dark_mode") ?? 0;
    if (darkModeSettings == -1) {
      _themeMode = ThemeMode.light;
    } else if (darkModeSettings == 1) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.system;
    }
  }

  void updateThemeMode() {
    setState(() {
      _getThemeMode();
    });
  }

  @override
  Widget build(BuildContext context) {
    var darkTheme = ThemeData.dark();
    darkTheme = darkTheme.copyWith(
      textSelectionHandleColor: Colors.blue,
      textSelectionColor: Colors.blue[400],
      accentColor: Colors.blue,
      colorScheme: darkTheme.colorScheme.copyWith(secondary: Colors.blue),
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Raspberry Pi Monitor',
      themeMode: _themeMode,
      theme: ThemeData.light(),
      darkTheme: darkTheme,
      home: HomePage(),
    );
  }
}
