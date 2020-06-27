import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/sshTools.dart';
import 'package:ssh/ssh.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({this.server, this.sshClient});

  final Server server;
  final SSHClient sshClient;

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  Future<String> getData(SSHClient client) async {
    final sysInfo = await getSysInfo(client);
    final monInfo = await getMonitorInfo(client);
    return "$sysInfo\n$monInfo";
  }

  @override
  void dispose() {
    disconnectAll(widget.sshClient);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server.getDisplayName()),
      ),
      body: FutureBuilder(
        future: getData(widget.sshClient),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(snapshot.data),
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }
}
