import 'package:flutter/material.dart' hide AboutDialog;
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/settings/AboutDialog.dart';

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
            title: Text('Dashboard Style'),
            trailing: DropdownButton<bool>(
              value: prefs.getBool("prefer_chart") ?? true,
              onChanged: (newValue) {
                setState(() {
                  prefs.setBool("prefer_chart", newValue);
                });
              },
              items: <DropdownMenuItem<bool>>[
                DropdownMenuItem<bool>(
                  value: true,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.trending_up),
                      SizedBox(width: 8),
                      Text('Chart'),
                    ],
                  ),
                ),
                DropdownMenuItem<bool>(
                  value: false,
                  child: Row(
                    children: <Widget>[
                      Icon(Icons.dashboard),
                      SizedBox(width: 8),
                      Text('Grid'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            title: Text('About'),
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AboutDialog(),
              );
            },
          ),
        ],
      ),
    );
  }
}
