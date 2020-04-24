import 'package:flutter/material.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/services/auth.dart';

class About extends StatelessWidget {
  final User user;
  About(this.user);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff7f7f7),
          image: DecorationImage(
            image: AssetImage('assets/img/about.png'),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        key : _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'Profil',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
          ),
          iconTheme: IconThemeData(color: Theme.of(context).accentColor),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        backgroundColor: Colors.transparent,
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * 0.8,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.blueGrey,
                        ),
                        SizedBox(
                          width: 15,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.52,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              FittedBox(
                                fit: BoxFit.fitWidth,
                                child: Text(
                                  user.username.replaceAll('@lelang.com', ''),
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w500),
                                ),
                              ),
                              Text(user.level),
                              SizedBox(
                                height: 10,
                              ),
                              Container(
                                width: double.infinity,
                                height: 30,
                                child: FlatButton(
                                  color: Theme.of(context).primaryColor,
                                  textColor: Colors.white,
                                  child: Text(
                                    'Edit Profil',
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  onPressed: () {
                                    _scaffoldKey.currentState
                                        .showSnackBar(SnackBar(
                                      content: Text('Fitur Dalam Pengembangan'),
                                      duration: Duration(seconds: 2),
                                    ));
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Nama'),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        user.nama,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Kota'),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        user.kota,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('No Telp'),
                    FittedBox(
                      fit: BoxFit.fitWidth,
                      child: Text(
                        user.telp,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                      ),
                    ),
                    SizedBox(
                      height: 50,
                    ),
                    Container(
                      width: 180,
                      height: 30,
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text(
                          'Keluar',
                          style: TextStyle(fontSize: 12),
                        ),
                        onPressed: () async {
                          await _auth.signOut();
                          Navigator.of(context)
                              .popUntil((route) => route.isFirst);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Text('Luc.id Project 2020 © . v1.0.0+1'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
