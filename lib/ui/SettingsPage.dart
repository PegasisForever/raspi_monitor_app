import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/storage.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Settings'),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(
            title: Text('About'),
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) => AboutDialog(
                        applicationName: 'Raspberry Pi Monitor',
                        applicationVersion: 'Prerelease ${packageInfo.version} (${packageInfo.buildNumber})',
                      ));
            },
          ),
        ],
      ),
    );
  }
}
