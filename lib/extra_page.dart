import 'package:flutter/material.dart';

class MyExtraPage extends StatefulWidget {
  State createState() => MyAppState();
}

class User {
  const User(this.id, this.name);

  final String name;
  final int id;
}

class MyAppState extends State<MyExtraPage> {
  late User selectedUser;
  List<User> users = <User>[const User(1, 'Foo'), const User(2, 'Bar')];

  @override
  void initState() {
    selectedUser = users[0];
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: DropdownButton<User>(
                value: selectedUser,
                onChanged: (User? newValue) {
                  setState(() {
                    selectedUser = newValue!;
                  });
                },
                items: users.map((User user) {
                  return DropdownMenuItem<User>(
                    value: user,
                    child: Text(
                      user.name,
                      style: TextStyle(color: Colors.black),
                    ),
                  );
                }).toList(),
              ),
            ),
            new Text(
                "selected user name is ${selectedUser.name} : and Id is : ${selectedUser.id}"),
          ],
        ),
      ),
    );
  }
}
