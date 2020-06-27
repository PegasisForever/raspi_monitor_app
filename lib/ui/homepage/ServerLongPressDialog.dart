import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';

class ServerLongPressDialog extends StatelessWidget {
  ServerLongPressDialog({
    this.server,
    this.onEdit,
    this.onDelete,
  });

  final Server server;
  final void Function() onEdit;
  final void Function() onDelete;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              server.getDisplayName(),
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
          ListTile(
            title: Text('Edit'),
            leading: Icon(Icons.edit),
            onTap: () {
              Navigator.pop(context);
              onEdit();
            },
          ),
          ListTile(
            title: Text('Delete'),
            leading: Icon(Icons.delete),
            onTap: () {
              Navigator.pop(context);
              onDelete();
            },
          ),
        ],
      ),
    );
  }
}
