import 'package:flutter/material.dart';
import 'package:raspi_monitor_app/model/Server.dart';

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

  @override
  void initState() {
    if (widget.server != null) {
      nickNameController.text = widget.server.name ?? "";
      addressController.text = widget.server.ip;
      portController.text = widget.server.port.toString();
      userController.text = widget.server.user;
      passwordController.text = widget.server.password ?? "";
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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.server == null ? 'New Server' : 'Edit Server'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.check),
            onPressed: () {
              final server = Server(
                addressController.text,
                userController.text,
                int.parse(portController.text),
                password: passwordController.text,
                name: nickNameController.text,
              );
              Navigator.pop(context, server);
            },
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
              SizedBox(height: 8),
              TextField(
                controller: addressController,
                decoration: InputDecoration(
                  labelText: "Address",
                  filled: true,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: portController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Port",
                  filled: true,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: userController,
                decoration: InputDecoration(
                  labelText: "User",
                  filled: true,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Password",
                  filled: true,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
