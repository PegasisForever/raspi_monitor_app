import 'dart:async';

import 'package:flutter/material.dart';
import 'package:zeroconf/zeroconf.dart';

void timedLog(String msg) {
  print('[${DateTime.now().toIso8601String()}] $msg');
}

String shrinkText(String text, int length) {
  if (text.length < length) {
    return text;
  } else {
    return text.substring(0, length - 3) + '...';
  }
}

bool isLandScape(BuildContext context) {
  final size = MediaQuery.of(context).size;
  return size.width > size.height;
}

Future<String> resolveMdns(String name) {
  final trimmedName = name.split(".")[0].toLowerCase();
  final completer = Completer<String>();
  var zeroconf = Zeroconf(
    onScanStarted: () => print("started scan"),
    onScanStopped: () => completer.complete(null),
    onServiceResolved: (Service service) {
      if ((service.name.toLowerCase() == trimmedName ||
          service.host.toLowerCase() == trimmedName) &&
          service.addresses.isNotEmpty) {
        completer.complete(service.addresses[0]);
      }
    },
    onError: () => completer.completeError(null),
  );

  zeroconf.startScan(type: "_device-info._tcp");

  return completer.future;
}
