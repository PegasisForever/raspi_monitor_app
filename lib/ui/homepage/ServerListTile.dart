import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';

class ServerListTile extends StatelessWidget {
  ServerListTile({this.server, this.onTap, this.onLongPress});

  final Server server;
  final GestureTapCallback onTap;
  final GestureLongPressCallback onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(server.getDisplayName()),
      onTap: onTap,
      onLongPress: onLongPress,
    );
  }
}
