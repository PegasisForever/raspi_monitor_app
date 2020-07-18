import 'package:flutter/material.dart';

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
