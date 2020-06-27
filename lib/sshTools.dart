import 'package:path_provider/path_provider.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:ssh/ssh.dart';
import 'package:http/http.dart' as http;
import 'dart:io';

final basePath = '/var/tmp/raspi_monitor';

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
  if (stdout.indexOf("armv8") != -1) {
    return "arm64";
  } else if (stdout.indexOf("arm") != -1) {
    return "arm32";
  } else if (stdout == "x86_64" || stdout == "x64") {
    return "x64";
  } else if (stdout == "i386" || stdout == "i686" || stdout == "x86") {
    return "x86";
  } else {
    throw ("Not Supported Architecture: ${stdout}");
  }
}

Future<String> _downloadBinary(String arch) async {
  final fileName = 'raspi_monitor_$arch.tar.gz';
  final response = await http.get('https://dev.pegasis.site/raspi_monitor/$fileName');
  final path = (await getApplicationDocumentsDirectory()).path + '/$fileName';
  await File(path).writeAsBytes(response.bodyBytes);
  return path;
}

Future<void> _uploadBinary(SSHClient client, String path) async {
  final fileName = path.split('/').last;
  await client.execute('mkdir -p $basePath');
  await client.sftpUpload(path: path, toPath: '$basePath');
  await client.execute('tar -xzf $basePath/$fileName -C $basePath');
  await client.execute('rm $basePath/$fileName');
}

Future<void> uploadBinary(SSHClient client) async {
  final arch = await _getArch(client);
  final binPath = await _downloadBinary(arch);
  await _uploadBinary(client, binPath);
}

Future<String> getSysInfo(SSHClient client) async {
  return await client.execute('$basePath/raspi_monitor info');
}

Future<String> getMonitorInfo(SSHClient client) async {
  return await client.execute('$basePath/raspi_monitor');
}
