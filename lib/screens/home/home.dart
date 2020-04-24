import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:lelangonline/main.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/home/adminhome.dart';
import 'package:lelangonline/screens/home/operatorhome.dart';
import 'package:lelangonline/screens/home/userhome.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:lelangonline/widgets/loading.dart';

class Home extends StatefulWidget {
  final User user;

  Home(this.user);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final AuthService _auth = AuthService();

  User user = User(
    level: '',
  );
  bool loading = true;

  @override
  void initState() {
    loading = true;
    populate();
    super.initState();
  }

  Future populate() async {
    await Firestore.instance
        .collection('user')
        .where('username', isEqualTo: widget.user.username)
        .getDocuments()
        .then((onValue) {
      setState(() {
        if (onValue.documents.isEmpty) {
          _auth.signOut();
          user = null;
        } else {
          user = new User(
            username: onValue.documents[0]['username'],
            kota: onValue.documents[0]['kota'],
            nama: onValue.documents[0]['nama'],
            telp: onValue.documents[0]['telp'],
            level: onValue.documents[0]['level'],
          );
        }
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Loading();
    } else {
      if (user == null) {
        return MyApp();
      } else {
        if (user.level == 'Admin') {
          return AdminHome(user);
        } else if (user.level == 'Operator') {
          return OperatorHome(user);
        } else if (user.level == 'User') {
          return UserHome(user);
        } else {
          return Container(
            color: Colors.blueGrey[50],
            child: Center(child: Text('Terjadi Kesalahan')),
          );
        }
      }
    }
  }
}
