import 'dart:convert';

import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:ssh/ssh.dart';

class DataMonitor {
  RawMonitorData oldRaw;
  RawMonitorData newRaw;
  int lastGetData;
  List<ChartItem> chartItems;
  Stream<List<ChartItem>> stream;
  SSHClient sshClient;
  Server server;
  bool stopped;

  DataMonitor(this.server);

  void start() {
    if (stopped == true) throw ("Can't restart a stopped data monitor!");
    stream = _getStream();
  }

  void stop() {
    stopped = true;
  }

  Stream<List<ChartItem>> _getStream() async* {
    try {
      sshClient = await getSSHClient(server);
      await uploadBinary(sshClient);
      while (true) {
        if (lastGetData != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          await Future.delayed(Duration(milliseconds: 1000 - (now - lastGetData)));
        }
        if (stopped == true) break;
        final rawData = getRawMonitorData(await getMonitorDataString(sshClient));
        lastGetData = rawData.time;
        oldRaw = newRaw;
        newRaw = rawData;

        if (oldRaw != null && newRaw != null) {
          final data = MonitorData(oldRaw, newRaw);
          if (chartItems == null) {
            chartItems = data.createChartItems();
          } else {
            chartItems = data.appendToChartItems(chartItems);
          }
          yield chartItems;
        }
      }
      await disconnectAll(sshClient);
    } catch (e, stacktrace) {
      print(e);
      print(stacktrace);
      throw (e);
    }
  }
}
