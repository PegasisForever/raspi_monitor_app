import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:raspi_monitor_app/model/Server.dart';
import 'package:raspi_monitor_app/ssh/sshTools.dart';
import 'package:raspi_monitor_app/tools.dart';

class ServerEditPage extends StatefulWidget {
  ServerEditPage({this.server});

  final Server server;

  @override
  _ServerEditPageState createState() => _ServerEditPageState();
}

class _ServerEditPageState extends State<ServerEditPage> {
  final nickNameController = TextEditingController();
  final addressController = TextEditingController();
  final portController = TextEditingController();
  final userController = TextEditingController();
  final passwordController = TextEditingController();
  final passphraseController = TextEditingController();
  bool isUsePassword = true;
  bool isChecking = false;
  String privateKey;

  @override
  void initState() {
    if (widget.server != null) {
      nickNameController.text = widget.server.name ?? "";
      addressController.text = widget.server.ip;
      portController.text = widget.server.port.toString();
      userController.text = widget.server.user;
      passwordController.text = widget.server.password ?? "";
      isUsePassword = widget.server.password?.isNotEmpty ?? false;
      privateKey = widget.server.privKey;
      passphraseController.text = widget.server.passphrase ?? "";
    } else {
      portController.text = '22';
      userController.text = 'pi';
    }
    super.initState();
  }

  @override
  void dispose() {
    nickNameController.dispose();
    addressController.dispose();
    portController.dispose();
    userController.dispose();
    passwordController.dispose();
    passphraseController.dispose();
    super.dispose();
  }

  Server _createServer(BuildContext context) {
    if (userController.text.isEmpty) {
      _showAlertDialog(context, 'The \'User\' field is empty!');
      return null;
    } else if (addressController.text.isEmpty) {
      _showAlertDialog(context, 'The \'Address\' field is empty!');
      return null;
    } else if (portController.text.isEmpty) {
      _showAlertDialog(context, 'The \'Port\' field is empty!');
      return null;
    } else if (int.tryParse(portController.text) == null ||
        int.tryParse(portController.text) < 0 ||
        int.tryParse(portController.text) > 65535) {
      _showAlertDialog(context, 'The \'Port\' field is not valid!');
      return null;
    } else if (isUsePassword) {
      if (passwordController.text.isEmpty) {
        _showAlertDialog(context, 'The \'Password\' field is empty!');
        return null;
      }
    } else if (!isUsePassword) {
      if (privateKey == null) {
        _showAlertDialog(context, 'Please provide a private key!');
        return null;
      }
    }

    return Server(
      addressController.text,
      userController.text,
      int.parse(portController.text),
      name: nickNameController.text,
      password: isUsePassword ? passwordController.text : null,
      privKey: isUsePassword ? null : privateKey,
      passphrase: isUsePassword ? null : passphraseController.text,
    );
  }

  Future<Exception> _checkServer(BuildContext context, Server server) async {
    if (server == null) return null;
    try {
      final client = await getSSHClient(server);
      disconnectAll(client);
      return null;
    } catch (e) {
      return e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server == null ? 'New Server' : 'Edit Server'),
        actions: <Widget>[
          if (!isChecking)
            IconButton(
              icon: Icon(Icons.check),
              onPressed: () async {
                setState(() {
                  isChecking = true;
                });

                final server = _createServer(context);
                final e = await _checkServer(context, server);
                if (server != null && e == null) {
                  Navigator.pop(context, server);
                } else {
                  setState(() {
                    isChecking = false;
                  });

                  final forceAdd = await showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) => AlertDialog(
                            title: Text("Unable to connect to ${server.getDisplayName()}"),
                            content: Text(e.toString()),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Save It Anyway'),
                                onPressed: () => Navigator.pop(context, true),
                              ),
                              FlatButton(
                                child: Text('Cancel'),
                                onPressed: () => Navigator.pop(context, false),
                              ),
                            ],
                          ));

                  if (forceAdd) {
                    Navigator.pop(context, server);
                  }
                }
              },
            ),
          if (isChecking)
            Stack(
              alignment: Alignment(0, 0),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                )
              ],
            ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              TextField(
                controller: nickNameController,
                decoration: InputDecoration(
                  labelText: "Nickname (Optional)",
                  filled: true,
                ),
              ),
              SizedBox(height: 16),
              Row(
                children: <Widget>[
                  Expanded(
                    flex: 4,
                    child: TextField(
                      controller: userController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "User",
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text('@'),
                  ),
                  Expanded(
                    flex: 8,
                    child: TextField(
                      controller: addressController,
                      keyboardType: TextInputType.visiblePassword,
                      decoration: InputDecoration(
                        labelText: "Address",
                        filled: true,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(4),
                    child: Text(':'),
                  ),
                  Expanded(
                    flex: 3,
                    child: TextField(
                      controller: portController,
                      keyboardType: TextInputType.numberWithOptions(signed: false, decimal: false),
                      decoration: InputDecoration(
                        labelText: "Port",
                        filled: true,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 16),
              Divider(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Authentication Method: ',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                  DropdownButton<bool>(
                    value: isUsePassword,
                    onChanged: (newValue) {
                      setState(() {
                        isUsePassword = newValue;
                      });
                    },
                    items: <DropdownMenuItem<bool>>[
                      DropdownMenuItem<bool>(
                        value: true,
                        child: Text('Password'),
                      ),
                      DropdownMenuItem<bool>(
                        value: false,
                        child: Text('Private Key'),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (isUsePassword)
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: "Password",
                    filled: true,
                  ),
                ),
              if (!isUsePassword)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TextField(
                      controller: passphraseController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Passphrase (Optional)",
                        filled: true,
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          child: Text('Choose a File'),
                          onPressed: () async {
                            final filePath = await FilePicker.getFilePath(type: FileType.any);
                            final file = File(filePath);
                            if (!await _isValidKey(file)) {
                              _showAlertDialog(
                                context,
                                'File \'${file.path.split('/').last}\' is not a valid private key.',
                              );
                              return;
                            }
                            final privateKey = await file.readAsString();
                            setState(() {
                              this.privateKey = privateKey;
                            });
                          },
                        ),
                        Text('or'),
                        RaisedButton(
                          child: Text('Paste from Clipboard'),
                          onPressed: () async {
                            final clipboardText = (await Clipboard.getData('text/plain')).text;
                            if (!await _isValidKey(clipboardText)) {
                              _showAlertDialog(
                                context,
                                '\'${shrinkText(clipboardText, 10)}\' is not a valid private key.',
                              );
                              return;
                            }
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: 16),
                    if (privateKey != null) Text(privateKey.substring(0, 50) + '.....'),
                  ],
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> _isValidKey(key) async {
    String content;
    if (key is File) {
      if (await key.length() > 10240) {
        return false;
      }
      content = await key.readAsString();
    } else if (key is String) {
      content = key;
    } else {
      return false;
    }

    return content.startsWith('-----BEGIN RSA PRIVATE KEY-----') &&
        (content.endsWith('-----END RSA PRIVATE KEY-----\n') || content.endsWith('-----END RSA PRIVATE KEY-----'));
  }

  Future<void> _showAlertDialog(BuildContext context, String msg, {String text}) {
    return showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(msg),
              content: text != null ? Text(text) : null,
              actions: <Widget>[
                FlatButton(
                  child: Text('OK'),
                  onPressed: () => Navigator.pop(context),
                )
              ],
            ));
  }
}
