import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'model/Server.dart';

final secureStorage = new FlutterSecureStorage();

List<Server> _lastGetServerList;

Future<List<Server>> getServerList() async {
  final serverListJson = await secureStorage.read(key: 'server_list') ?? '[]';
  final decoded = json.decode(serverListJson) as List<dynamic>;
  _lastGetServerList = decoded.map((e) => Server.fromJson(e)).toList();
  return _lastGetServerList;
}

Future<void> addServer(Server server) async {
  _lastGetServerList.insert(0, server);
  await _saveList();
}

Future<void> removeServer(Server server) async {
  _lastGetServerList.remove(server);
  await _saveList();
}

Future<void> updateServer(Server oldServer, Server newServer) async {
  final index = _lastGetServerList.indexOf(oldServer);
  _lastGetServerList[index] = newServer;
  await _saveList();
}

Future<void> _saveList() async {
  final jsonStr = json.encode(_lastGetServerList.map((server) => server.toJson()).toList());
  await secureStorage.write(key: 'server_list', value: jsonStr);
}

SharedPreferences prefs;

Future<void> initSharedPrefs() async {
  prefs = await SharedPreferences.getInstance();
}
