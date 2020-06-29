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
