import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/DataMonitor.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:ssh/ssh.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({this.server, this.sshClient});

  final Server server;
  final SSHClient sshClient;

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  DataMonitor dataMonitor;

  @override
  void initState() {
    dataMonitor = DataMonitor(widget.sshClient);
    dataMonitor.start();
    super.initState();
  }

  @override
  void dispose() {
    dataMonitor.stop();
    disconnectAll(widget.sshClient);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server.getDisplayName()),
      ),
      body: StreamBuilder(
        stream: dataMonitor.stream,
        builder: (context, AsyncSnapshot<List<ChartItem>> snapshot) {
          print("build: $snapshot");
          if (snapshot.hasData) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Text(snapshot.data.toString()),
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
