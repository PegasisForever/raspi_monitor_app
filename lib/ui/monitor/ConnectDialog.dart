import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:raspi_monitor_app/ui/monitor/MonitorPage.dart';

class ConnectDialog extends StatefulWidget {
  ConnectDialog({this.server});

  final Server server;

  @override
  _ConnectDialogState createState() => _ConnectDialogState();
}

class _ConnectDialogState extends State<ConnectDialog> with AfterLayoutMixin<ConnectDialog> {
  Future<void> _initSSH(BuildContext context) async {
    try {
      final client = await getSSHClient(widget.server);
      await uploadBinary(client);
      Navigator.pop(context);
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (_) => MonitorPage(
                  server: widget.server,
                  sshClient: client,
                )),
      );
    } catch (e) {
      Navigator.pop(context);
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text("Unable to connect to ${widget.server.getDisplayName()}"),
                content: Text(e.toString()),
                actions: <Widget>[
                  FlatButton(
                    child: Text("OK"),
                    onPressed: () => Navigator.pop(context),
                  )
                ],
              ));
    }
  }

  @override
  void afterFirstLayout(BuildContext context) {
    _initSSH(context);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.only(top: 16, left: 16, right: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                CircularProgressIndicator(),
                SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Connecting to ${widget.server.getDisplayName()}',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ),
              ],
            ),
            ButtonBar(
              children: <Widget>[
                FlatButton(
                  child: Text('Cancel'),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
