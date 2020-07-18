import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/DataMonitor.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/monitor/DataChartList.dart';
import 'package:raspi_monitor_app/ui/monitor/DataGrid.dart';

class MonitorPage extends StatefulWidget {
  const MonitorPage({this.server});

  final Server server;

  @override
  _MonitorPageState createState() => _MonitorPageState();
}

class _MonitorPageState extends State<MonitorPage> {
  DataMonitor dataMonitor;
  bool isChart = prefs.getBool("prefer_chart") ?? true;
  bool fullScreened = false;

  @override
  void initState() {
    dataMonitor = DataMonitor(widget.server);
    dataMonitor.start();
    super.initState();
  }

  @override
  void dispose() {
    dataMonitor.stop();
    if (fullScreened) SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: !fullScreened,
      appBar: fullScreened
          ? null
          : AppBar(
              title: Text(widget.server.getDisplayName()),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.fullscreen),
                  onPressed: () {
                    SystemChrome.setEnabledSystemUIOverlays([]);
                    setState(() {
                      fullScreened = true;
                    });
                  },
                ),
                IconButton(
                  icon: Icon(isChart ? Icons.dashboard : Icons.trending_up),
                  onPressed: () {
                    setState(() {
                      isChart = !isChart;
                      prefs.setBool("prefer_chart", isChart);
                    });
                  },
                )
              ],
            ),
      body: Stack(
        children: <Widget>[
          StreamBuilder(
            stream: dataMonitor.stream,
            builder: (context, AsyncSnapshot<Map<String, ChartItem>> snapshot) {
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
                Widget mainContent;
                if (!snapshot.hasData) {
                  mainContent = Container();
                } else if (isChart) {
                  mainContent = DataChartList(snapshot.data);
                } else if (!isChart) {
                  mainContent = DataGrid(snapshot.data);
                }
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
                      child: mainContent,
                    ),
                  ],
                );
              }
            },
          ),
          if (fullScreened)
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: Icon(Icons.fullscreen_exit),
                onPressed: () {
                  SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
                  setState(() {
                    fullScreened = false;
                  });
                },
              ),
            )
        ],
      ),
    );
  }
}
