import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/DataMonitor.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:raspi_monitor_app/ui/monitor/DataChartWidget.dart';
import 'package:ssh/ssh.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

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
          if (snapshot.hasData) {
            return ListView.separated(
              padding: EdgeInsets.only(top: 4),
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, i) {
                return DataChartWidget(snapshot.data[i]);
              },
              separatorBuilder: (_, __) => Divider(),
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
