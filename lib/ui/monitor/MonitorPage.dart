import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/DataMonitor.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/model/Units.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
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
            final widgets = <Widget>[];
            final now = DateTime.now().millisecondsSinceEpoch.toDouble();
            final start = now - 60 * 1000;
            snapshot.data.forEach((ChartItem chartItem) {
              widgets.add(Text(
                chartItem.name,
                style: Theme.of(context).textTheme.headline6,
              ));
              widgets.add(SizedBox(height: 8));
              widgets.add(Container(
                height: 150,
                child: SfCartesianChart(
                  primaryXAxis: NumericAxis(
                    visibleMinimum: start,
                  ),
                  primaryYAxis: NumericAxis(),
                  series: chartItem.lines.map((Line line) {
                    return LineSeries<ChartDataPoint, num>(
                      animationDuration: 0,
                      dataSource: line.data,
                      xValueMapper: (ChartDataPoint dataPoint, _) => dataPoint.time,
                      yValueMapper: (ChartDataPoint dataPoint, _) => dataPoint.value.getBestValue(),
                      width: 2,
                    );
                  }).toList(),
                ),
              ));
              widgets.add(Divider());
            });
            widgets.removeLast();

            return ListView(
              padding: EdgeInsets.all(16.0),
              children: widgets,
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
