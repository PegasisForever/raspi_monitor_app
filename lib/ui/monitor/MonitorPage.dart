import 'dart:async';

import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/DataMonitor.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ui/monitor/DataChartWidget.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({this.server});

  final Server server;

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  DataMonitor dataMonitor;

  @override
  void initState() {
    dataMonitor = DataMonitor(widget.server);
    dataMonitor.start();
    super.initState();
  }

  @override
  void dispose() {
    dataMonitor.stop();
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
          if (snapshot.hasError) {
            Future.delayed(
                Duration.zero,
                () => showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => AlertDialog(
                          title: Text("Unable to connect to ${widget.server.getDisplayName()}"),
                          content: Text(snapshot.error.toString()),
                          actions: <Widget>[
                            FlatButton(
                              child: Text("OK"),
                              onPressed: () {
                                Navigator.pop(context);
                                Navigator.pop(context);
                              },
                            )
                          ],
                        )));
            return Container();
          } else {
            return Stack(
              children: <Widget>[
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: snapshot.hasData ? 0 : 1,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        CircularProgressIndicator(),
                        SizedBox(height: 16),
                        Text(
                          'Connecting to ${widget.server.getDisplayName()}',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                ),
                AnimatedOpacity(
                  duration: Duration(milliseconds: 300),
                  opacity: snapshot.hasData ? 1 : 0,
                  child: ListView.separated(
                    shrinkWrap: true,
                    padding: EdgeInsets.only(top: 4),
                    itemCount: snapshot.data?.length ?? 0,
                    itemBuilder: (BuildContext context, i) {
                      return DataChartWidget(snapshot.data[i]);
                    },
                    separatorBuilder: (_, __) => Divider(),
                  ),
                ),
              ],
            );
          }
        },
      ),
    );
  }
}
