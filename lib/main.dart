import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

Future<UserModel?> createUser(String name, String jobTitle) async {
  final response = await http.post(Uri.parse("https://reqres.in/api/users"),
      body: {"name": name, "job": jobTitle});

  if (response.statusCode == 201) {
    final String responseString = response.body;
    return userModelFromJson(responseString);
  } else {
    // return null;
    throw Exception('Failed to create user.');
  }
}

class _MyHomePageState extends State<MyHomePage> {
   UserModel _user = UserModel() ;
  // Future<UserModel>? _user;

  final TextEditingController nameController = TextEditingController();
  final TextEditingController jobController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        padding: EdgeInsets.all(32),
        child: Column(
          children: <Widget>[
            TextField(
              controller: nameController,
            ),
            TextField(
              controller: jobController,
            ),
            SizedBox(
              height: 32,
            ),
            // ignore: unnecessary_null_comparison
            _user.id != null
                ? Text(
                    "The user ${_user.name}, ${_user.id} is created successfully at time ${_user.createdAt!.toIso8601String()}")
                : SizedBox.shrink()
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String name = nameController.text;
          final String jobTitle = jobController.text;

          final UserModel? user = await createUser(name, jobTitle);

          setState(() {
            _user = user!;
          });
        },
        tooltip: 'add user',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
