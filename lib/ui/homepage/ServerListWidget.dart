import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ui/homepage/ServerListTile.dart';

class ServerListWidget extends StatelessWidget {
  ServerListWidget({this.servers, this.onTap, this.onLongPress});

  final List<Server> servers;
  final void Function(Server server) onTap;
  final void Function(Server server) onLongPress;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: servers
          .map((server) => ServerListTile(
                server: server,
                onTap: () => onTap(server),
                onLongPress: () => onLongPress(server),
              ))
          .toList(),
    );
  }
}
