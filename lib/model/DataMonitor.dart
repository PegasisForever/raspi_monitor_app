import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:raspi_monitor_app/model/Data.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:ssh/ssh.dart';

class DataMonitor {
  RawMonitorData oldRaw;
  RawMonitorData newRaw;
  int lastGetData;
  Map<String, ChartItem> chartItems;
  Stream<Map<String, ChartItem>> stream;
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

  Stream<Map<String, ChartItem>> _getStream() async* {
    try {
      sshClient = await getSSHClient(server);
      await uploadBinary(sshClient);
      while (true) {
        if (lastGetData != null) {
          final now = DateTime.now().millisecondsSinceEpoch;
          final waitMillis = 1000 - (now - lastGetData);
          if (waitMillis > 0) {
            await Future.delayed(Duration(milliseconds: waitMillis));
          }
        }
        lastGetData = DateTime.now().millisecondsSinceEpoch;

        if (stopped == true) break;
        final rawData = getRawMonitorData(await getMonitorDataString(sshClient));
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
      Crashlytics.instance.recordError(e, stacktrace);
      throw (e);
    }
  }
}
