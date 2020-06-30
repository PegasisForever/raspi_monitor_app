import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/SettingsPage.dart';
import 'package:raspi_monitor_app/ui/homepage/ServerListWidget.dart';
import 'package:raspi_monitor_app/ui/homepage/ServerLongPressDialog.dart';
import 'package:raspi_monitor_app/ui/monitor/MonitorPage.dart';
import 'package:raspi_monitor_app/ui/servereditpage/ServerEditPage.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Raspberry Pi Monitor'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.settings),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SettingsPage()),
              );
            },
          )
        ],
      ),
      body: FutureBuilder(
        future: getServerList(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ServerListWidget(
              servers: snapshot.data,
              onTap: (server) async {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MonitorPage(server: server)),
                );
              },
              onLongPress: (server) {
                showDialog(
                    context: context,
                    builder: (context) => ServerLongPressDialog(
                          server: server,
                          onEdit: () async {
                            final newServer = await Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => ServerEditPage(server: server)),
                            );
                            if (newServer != null) {
                              await updateServer(server, newServer);
                              setState(() {});
                            }
                          },
                          onDelete: () async {
                            await removeServer(server);
                            setState(() {});
                          },
                        ));
              },
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final server = await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => ServerEditPage()),
          );
          if (server != null) {
            await addServer(server);
            setState(() {});
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
