import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/storage.dart';
import 'package:raspi_monitor_app/ui/settings/Link.dart';

class AboutDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Image.asset(
                  'images/icon.png',
                  width: 64,
                  height: 64,
                ),
                SizedBox(width: 16),
                Flexible(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Raspberry Pi Monitor',
                        style: Theme.of(context).textTheme.headline6,
                      ),
                      Text('${packageInfo.version} (${packageInfo.buildNumber})'),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Text('By Pegasis'),
          SizedBox(height: 8),
          Link(
            text: 'Github',
            link: 'https://github.com/PegasisForever/raspi_monitor_app',
          ),
          ButtonBar(
            children: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
