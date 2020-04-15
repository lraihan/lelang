import 'package:flutter/material.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/services/auth.dart';

class OperatorHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User user;

  OperatorHome(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              Text('Operator'),
              FlatButton(
                onPressed: () async {
                  await _auth.signOut();
                },
                child: Text('Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
