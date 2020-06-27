import 'package:crypto/crypto.dart';
import 'package:path_provider/path_provider.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:ssh/ssh.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

final basePath = '/var/tmp/raspi_monitor';
final zippedFileName = 'raspi_monitor.gz';
final unzippedFileName = 'raspi_monitor';

Future<SSHClient> getSSHClient(Server server) async {
  final client = SSHClient(
    host: server.ip,
    port: server.port,
    username: server.user,
    passwordOrKey: server.password,
  );
  await client.connect();
  await client.connectSFTP();
  return client;
}

Future<void> disconnectAll(SSHClient client) async {
  await client.disconnect();
  client.disconnectSFTP();
}

Future<String> _getArch(SSHClient client) async {
  final stdout = (await client.execute('uname -m')).trim();
  if (stdout.indexOf("armv8") != -1 || stdout.indexOf("aarch64") != -1) {
    return "arm64";
  } else if (stdout.indexOf("arm") != -1) {
    return "arm32";
  } else if (stdout == "x86_64" || stdout == "x64") {
    return "x64";
  } else if (stdout.indexOf("86") != -1) {
    return "x86";
  } else {
    throw ("Not Supported Architecture: $stdout");
  }
}

Future<String> _getSha1(String filePath) async {
  final file = File(filePath);
  if (await file.exists()) {
    final bytes = await file.readAsBytes();
    return sha1.convert(bytes).toString();
  } else {
    return null;
  }
}

Future<List<String>> _getLatestSha1s(String arch) async {
  final response = await http.get('https://dev.pegasis.site/raspi_monitor/$arch/sha1');
  final lines = response.body.split("\n");
  return [lines[0].split(" ")[0], lines[1].split(" ")[0]]; // unzipped, zipped
}

Future<String> _downloadBinary(String arch) async {
  final localPath = (await getApplicationDocumentsDirectory()).path + '/$arch/$zippedFileName';
  final response = await http.get('https://dev.pegasis.site/raspi_monitor/$arch/$zippedFileName');
  final file = File(localPath);
  await file.create(recursive: true);
  await file.writeAsBytes(response.bodyBytes);
  return localPath;
}

Future<String> _downloadBinaryCached(String arch, String latestSha1) async {
  final localPath = (await getApplicationDocumentsDirectory()).path + '/$arch/$zippedFileName';
  final localSha1 = await _getSha1(localPath);
  if (localSha1 == null) {
    // file doesn't exist
    return _downloadBinary(arch);
  } else if (localSha1 == latestSha1) {
    // file exists
    return localPath;
  } else {
    // file old
    return _downloadBinary(arch);
  }
}

Future<String> _getSftpSha1(SSHClient client) async {
  try {
    final stdout = await client.execute("sha1sum $basePath/raspi_monitor");
    return stdout.split(" ")[0];
  } catch (e) {
    return null;
  }
}

Future<void> _uploadBinary(SSHClient client, String path) async {
  await client.execute('mkdir -p $basePath');
  await client.sftpUpload(path: path, toPath: '$basePath');
  await client.execute('gzip -d $basePath/$unzippedFileName');
}

Future<void> _setPermission(SSHClient client) async {
  await client.execute('chmod 770 $basePath/$unzippedFileName');
}

Future<void> _uploadBinaryCached(SSHClient client, String path, String latestSha1) async {
  final localSha1 = await _getSftpSha1(client);
  if (localSha1 == null || localSha1 != latestSha1) {
    await _uploadBinary(client, path);
  }
  await _setPermission(client);
}

Future<void> uploadBinary(SSHClient client) async {
  final arch = await _getArch(client);
  final latestSha1s = await _getLatestSha1s(arch);
  final binPath = await _downloadBinaryCached(arch, latestSha1s[1]);
  await _uploadBinaryCached(client, binPath, latestSha1s[0]);
}

Future<String> getSysInfo(SSHClient client) async {
  return await client.execute('$basePath/raspi_monitor info');
}

Future<String> getMonitorInfo(SSHClient client) async {
  return await client.execute('$basePath/raspi_monitor');
}
