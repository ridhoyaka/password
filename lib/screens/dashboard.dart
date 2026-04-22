import 'package:flutter/material.dart';
import '../database/db_helper.dart';

class Password {
  int? id;
  String title;
  String username;
  String password;

  Password({
    this.id,
    required this.title,
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'username': username,
      'password': password,
    };
  }

  factory Password.fromMap(Map<String, dynamic> map) {
    return Password(
      id: map['id'],
      title: map['title'],
      username: map['username'],
      password: map['password'],
    );
  }
}

class DashboardPage extends StatefulWidget {
  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Password> passwords = [];
  final DBHelper dbHelper = DBHelper();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() async {
    final data = await dbHelper.getAll();
    setState(() {
      passwords = data.map((e) => Password.fromMap(e)).toList();
    });
  }

  void _addOrEditPassword({Password? existing}) {
    TextEditingController titleController =
        TextEditingController(text: existing?.title ?? '');
    TextEditingController userController =
        TextEditingController(text: existing?.username ?? '');
    TextEditingController passController =
        TextEditingController(text: existing?.password ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(existing == null ? "Tambah Password" : "Edit Password"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: "Judul"),
              ),
              TextField(
                controller: userController,
                decoration: InputDecoration(labelText: "Username"),
              ),
              TextField(
                controller: passController,
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            child: Text("Batal"),
            onPressed: () => Navigator.pop(context),
          ),
          ElevatedButton(
            child: Text("Simpan"),
            onPressed: () async {
              if (existing == null) {
                await dbHelper.insert({
                  'title': titleController.text,
                  'username': userController.text,
                  'password': passController.text,
                });
              } else {
                await dbHelper.update(existing.id!, {
                  'title': titleController.text,
                  'username': userController.text,
                  'password': passController.text,
                });
              }

              Navigator.pop(context);
              _loadData();
            },
          ),
        ],
      ),
    );
  }

  void _deletePassword(int id) async {
    await dbHelper.delete(id);
    _loadData();
  }

  void _viewPassword(Password pass) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.grey[900],
        title: Text(pass.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text("Username: ${pass.username}"),
            SizedBox(height: 10),
            Text("Password: ${pass.password}"),
          ],
        ),
        actions: [
          TextButton(
            child: Text("Edit"),
            onPressed: () {
              Navigator.pop(context);
              _addOrEditPassword(existing: pass);
            },
          ),
          TextButton(
            child: Text("Hapus"),
            onPressed: () {
              Navigator.pop(context);
              _deletePassword(pass.id!);
            },
          ),
          TextButton(
            child: Text("Tutup"),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Dashboard Password"),
        backgroundColor: Colors.blue[900],
      ),
      body: passwords.isEmpty
          ? Center(child: Text("Belum ada data"))
          : ListView.builder(
              itemCount: passwords.length,
              itemBuilder: (context, index) {
                final item = passwords[index];
                return Card(
                  color: Colors.grey[850],
                  child: ListTile(
                    title: Text(item.title),
                    subtitle: Text(item.username),
                    onTap: () => _viewPassword(item),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue[900],
        child: Icon(Icons.add),
        onPressed: () => _addOrEditPassword(),
      ),
    );
  }
}