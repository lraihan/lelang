import 'package:flutter/material.dart';
import 'package:lelangonline/screens/authenticate/personaldata.dart';
import 'package:lelangonline/screens/authenticate/sign_in.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:lelangonline/widgets/loading.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String username, password, confirm, error = '';
  String usercheck;

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            color: Color(0xfff7f7f7),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/img/register.jpg'),
              fit: BoxFit.cover,
            )),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  color: Color(0xfff7f7f7),
                  alignment: Alignment.bottomCenter,
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.64,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
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
                            obscureText: true,
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
                                val != password ? 'Password Tidak Cocok' : null,
                            decoration: InputDecoration(
                              labelText: 'Konfirmasi Password',
                            ),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                confirm = val;
                              });
                            },
                          ),
                          SizedBox(
                            height: 40,
                          ),
                          Container(
                            decoration: BoxDecoration(),
                            width: double.infinity,
                            child: FlatButton(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              padding: EdgeInsets.symmetric(vertical: 7),
                              color: Colors.indigoAccent,
                              onPressed: () async {
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  username = username + '@lelang.com';
                                  dynamic result = await _auth
                                      .registerUser(username, password)
                                      .whenComplete(() {
                                    setState(() {
                                      loading = false;
                                    });
                                    Navigator.of(context).pushReplacement(
                                        MaterialPageRoute(builder: (_) {
                                      return PersonalData(username);
                                    }));
                                  });

                                  if (result == null) {
                                    setState(() {
                                      loading = false;
                                      usercheck = 'Username telah dipakai';
                                    });
                                  }
                                }
                              },
                              child: Text(
                                'Selanjutnya',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xfff7f7f7),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text('sudah punya akun?'),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) {
                                return SignIn();
                              }));
                            },
                            child: Text('Masuk Disini'),
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
