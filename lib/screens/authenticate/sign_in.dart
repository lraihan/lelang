import 'package:flutter/material.dart';
import 'package:lelangonline/main.dart';
import 'package:lelangonline/screens/authenticate/register.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:lelangonline/widgets/loading.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();

  String username, password = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            decoration: BoxDecoration(
                color: Color(0xfff7f7f7),
                image: DecorationImage(
                  image: AssetImage('assets/img/signin.jpg'),
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
                  height: MediaQuery.of(context).size.height * 0.55,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Username',
                            ),
                            onChanged: (val) {
                              setState(() {
                                username = val;
                              });
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Username Diperlukan' : null,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            decoration: InputDecoration(
                              labelText: 'Password',
                            ),
                            obscureText: true,
                            onChanged: (val) {
                              setState(() {
                                password = val;
                              });
                            },
                            validator: (val) =>
                                val.isEmpty ? 'Password Diperlukan' : null,
                          ),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                            error,
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.w500),
                          ),
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
                                if (_formkey.currentState.validate()) {
                                  setState(() {
                                    loading = true;
                                  });
                                  await _auth
                                      .signIn(
                                          username + '@lelang.com', password)
                                      .then((result) {
                                    if (result == null) {
                                      setState(() {
                                        loading = false;
                                        error = 'Username/Password Salah';
                                      });
                                    } else {
                                      setState(() {
                                        loading = false;
                                      });
                                      Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(builder: (_) {
                                        return MyApp();
                                      }));
                                    }
                                  });
                                }
                              },
                              child: Text(
                                'Masuk',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20,
                                  color: Color(0xfff7f7f7),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 25,
                          ),
                          Text('belum punya akun?'),
                          FlatButton(
                            onPressed: () {
                              Navigator.of(context).pushReplacement(
                                  MaterialPageRoute(builder: (_) {
                                return Register();
                              }));
                            },
                            child: Text('Daftar Disini'),
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
