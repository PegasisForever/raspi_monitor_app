class Server {
  Server(
    this.ip,
    this.user,
    this.port, {
    this.name,
    this.password,
    this.privKey,
    this.passphrase,
  });

  final String name; // nullable
  final String ip;
  final int port;
  final String user;
  final String password; // nullable
  final String privKey; // nullable
  final String passphrase; // nullable

  Server.fromJson(Map<String, dynamic> map)
      : ip = map["ip"],
        port = map["port"],
        user = map["user"],
        name = map["name"],
        password = map["password"],
        privKey = map["privKey"],
        passphrase = map["passphrase"];

  String getDisplayName(){
    if(name!=null && name.isNotEmpty){
      return name;
    }else{
      return ip;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      "ip": ip,
      "port": port,
      "user": user,
      "name": name,
      "password": password,
      "privKey": privKey,
      "passphrase": passphrase,
    };
  }
}
