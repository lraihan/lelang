import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lelangonline/main.dart';
import 'package:lelangonline/screens/authenticate/personaldata.dart';
import 'package:lelangonline/screens/authenticate/sign_in.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:lelangonline/widgets/loading.dart';

class AdminRegist extends StatefulWidget {
  @override
  _AdminRegistState createState() => _AdminRegistState();
}

class _AdminRegistState extends State<AdminRegist> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String username, password, error;
  String nama, kota, telp = '';
  String usercheck;

  bool loading = false;

  String level = '';
  var categoryColor = Colors.grey;

  void changeColor(String cat) {
    setState(() {
      level = cat;
    });
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                'Registrasi Akun',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              backgroundColor: Colors.blueGrey[50],
              elevation: 0,
            ),
            body: Container(
              child: Scaffold(
                backgroundColor: Colors.transparent,
                body: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.95,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextFormField(
                            initialValue: username != null
                                ? username =
                                    username.replaceAll('@lelang.com', '')
                                : username,
                            validator: (val) =>
                                val.isEmpty ? 'Silahkan Pilih Username' : null,
                            decoration: InputDecoration(
                              labelText: 'Username',
                              errorText: usercheck,
                            ),
                            onChanged: (val) {
                              setState(() {
                                username = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (val) => val.length < 6
                                ? 'Password Minimal 6 Karakter'
                                : null,
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Nama Diperlukan' : null,
                            decoration: InputDecoration(
                              labelText: 'Nama',
                            ),
                            onChanged: (val) {
                              setState(() {
                                nama = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'Kota Diperlukan' : null,
                            decoration: InputDecoration(
                              labelText: 'Kota',
                            ),
                            onChanged: (val) {
                              setState(() {
                                kota = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            validator: (val) =>
                                val.isEmpty ? 'No Telp Diperlukan' : null,
                            decoration: InputDecoration(
                              labelText: 'No Telp',
                            ),
                            onChanged: (val) {
                              setState(() {
                                telp = val;
                              });
                            },
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: FlatButton(
                              color: Colors.deepOrange,
                              child: Text(
                                'User',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => changeColor('User'),
                            ),
                          ),
                          Center(
                              child: Row(
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: FlatButton(
                                    color: Colors.indigoAccent,
                                    child: Text(
                                      'Admin',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    onPressed: () => changeColor('Admin')),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: FlatButton(
                                  color: Colors.indigoAccent,
                                  child: Text(
                                    'Operator',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () => changeColor('Operator'),
                                ),
                              ),
                            ],
                          )),
                          SizedBox(
                            height: 15,
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            width: double.infinity,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 7),
                              color: Colors.deepOrange,
                              onPressed: () async {
                                if (_formkey.currentState.validate() &&
                                    level != '') {
                                  setState(() {
                                    loading = true;
                                  });
                                  username = username.replaceAll(
                                          new RegExp(r"\s+\b|\b\s"), "") +
                                      '@lelang.com';
                                  print(username);
                                  dynamic result = await _auth.registerUser(
                                      username, password);
                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      usercheck = 'Username telah dipakai';
                                    });
                                  } else {
                                    await _auth.signOut();
                                    Navigator.popUntil(
                                        context, (route) => route.isFirst);
                                    await Firestore.instance
                                        .collection('user')
                                        .document()
                                        .setData({
                                      'kota': kota,
                                      'level': level,
                                      'nama': nama,
                                      'telp': telp,
                                      'username': username,
                                    }).whenComplete(() {
                                      setState(() {
                                        loading = false;
                                      });
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Register $level',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xfff7f7f7),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          );
  }
}
