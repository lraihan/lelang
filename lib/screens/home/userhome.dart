import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/home/about.dart';
import 'package:lelangonline/screens/user/explore.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserHome extends StatelessWidget {
  final AuthService _auth = AuthService();
  final User user;
  final riwayatController =
      PageController(initialPage: 0, viewportFraction: 0.85);

  UserHome(this.user);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.blueGrey[50],
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.person,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(builder: (_) {
                  return About(user);
                }));
              })
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/img/home.png'),
            fit: BoxFit.cover,
          ),
        ),
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Hai,',
                  style: TextStyle(fontSize: 20),
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: FittedBox(
                  fit: BoxFit.fitWidth,
                  child: Text(
                    user.nama,
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.04,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text('Riwayat Pelelangan'),
                    Container(
                      height: 25,
                      child: FlatButton(
                        color: Theme.of(context).primaryColor,
                        textColor: Colors.white,
                        child: Text('Lihat Detail'),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 5),
              Container(
                height: MediaQuery.of(context).size.height * 0.5,
                child: Stack(
                  children: <Widget>[
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.15,
                          ),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            width: double.infinity,
                            height: MediaQuery.of(context).size.height * 0.35,
                            child: Opacity(
                              opacity: 0.6,
                              child: Card(
                                elevation: 6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.5,
                      child: StreamBuilder(
                        stream: Firestore.instance
                            .collection('riwayat')
                            .where('username', isEqualTo: user.username)
                            .orderBy('tanggal', descending: true)
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (!snapshot.hasData ||
                              snapshot.data.documents.length == 0)
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.5,
                              child: Center(
                                child: Column(
                                  children: <Widget>[
                                    Container(
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 20),
                                      child: Image.asset(
                                          'assets/img/nolelang.png'),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        Text('Tap '),
                                        Text(
                                          'Cari Lelang',
                                          style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Theme.of(context).primaryColor,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Text('Untuk Memulai Penawaran'),
                                  ],
                                ),
                              ),
                            );
                          else {
                            return Container(
                              width: MediaQuery.of(context).size.width,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: PageView.builder(
                                controller: riwayatController,
                                itemCount: snapshot.data.documents.length,
                                itemBuilder: (context, index) {
                                  return _riwayat(
                                      context, snapshot.data.documents[index]);
                                },
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Center(
                child: Container(
                  decoration: BoxDecoration(),
                  width: MediaQuery.of(context).size.width * 0.87,
                  child: FlatButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: EdgeInsets.symmetric(vertical: 7),
                    color: Colors.deepOrange,
                    onPressed: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute(builder: (_) {
                        return Explore();
                      }));
                    },
                    child: Text(
                      'Cari Lelang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xfff7f7f7),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _riwayat(BuildContext context, DocumentSnapshot document) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.5,
    child: StreamBuilder(
      stream: Firestore.instance
          .collection('lelang')
          .document(document['id_lelang'])
          .snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        } else {
          return Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: <Widget>[
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.3,
                  child: Card(
                    elevation: 6,
                    shape: RoundedRectangleBorder(),
                    child: Image.network(
                      snapshot.data['photo'],
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                ),
                Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.2,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(vertical: 2),
                        child: Text(
                          snapshot.data['nama'],
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Penawaranmu'),
                            Text(
                              NumberFormat.compactCurrency(
                                      locale: 'ID',
                                      symbol: 'IDR ',
                                      decimalDigits: 0)
                                  .format(document['penawaran']),
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 5),
                      Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Status Lelang'),
                            Text(
                              snapshot.data['status'],
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).primaryColor),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }
      },
    ),
  );
}
