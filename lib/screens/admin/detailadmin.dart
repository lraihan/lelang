import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/user/bidding.dart';

class DetailAdmin extends StatefulWidget {
  final DocumentSnapshot snapshot;
  final User user;

  DetailAdmin(this.snapshot, this.user);

  @override
  _DetailAdminState createState() => _DetailAdminState();
}

class _DetailAdminState extends State<DetailAdmin> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Color(0xfff7f7f7),
        image: DecorationImage(
          image: AssetImage('assets/img/detail.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Stack(
        children: <Widget>[
          Container(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height * 0.4,
            child: Image.network(
              widget.snapshot.data['photo'],
              fit: BoxFit.cover,
            ),
          ),
          Scaffold(
            key: _scaffoldKey,
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              iconTheme: IconThemeData(color: Theme.of(context).accentColor),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: MediaQuery.of(context).size.height * 0.24),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.62,
                      width: MediaQuery.of(context).size.width * 0.85,
                      child: Stack(
                        children: <Widget>[
                          Opacity(
                            opacity: 0.8,
                            child: Container(
                              height: MediaQuery.of(context).size.height * 0.62,
                              width: MediaQuery.of(context).size.width * 0.85,
                              child: Card(
                                elevation: 6,
                              ),
                            ),
                          ),
                          Container(
                            child: SingleChildScrollView(
                              child: Container(
                                padding: EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 15,
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      widget.snapshot.data['nama'],
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.11,
                                      child: SingleChildScrollView(
                                          child: Text(
                                        widget.snapshot.data['deskripsi'],
                                      )),
                                    ),
                                    SizedBox(height: 15),
                                    Text('Harga Awal'),
                                    Text(
                                      NumberFormat.compactCurrency(
                                              locale: 'ID',
                                              symbol: 'IDR ',
                                              decimalDigits: 0)
                                          .format(widget
                                              .snapshot.data['harga_awal']),
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 15),
                                    Text('Tawaran Tertinggi'),
                                    Container(
                                      width: double.infinity,
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.15,
                                      child: StreamBuilder(
                                        stream: Firestore.instance
                                            .collection('riwayat')
                                            .where('id_lelang',
                                                isEqualTo:
                                                    widget.snapshot.documentID)
                                            .orderBy('penawaran',
                                                descending: true)
                                            .snapshots(),
                                        builder: (context, snapshots) {
                                          if (!snapshots.hasData ||
                                              snapshots.data.documents.length ==
                                                  0) {
                                            return Container(
                                              margin: EdgeInsets.symmetric(
                                                  vertical: 5),
                                              child: Text(
                                                'Belum ada penawaran',
                                                style: TextStyle(
                                                    fontSize: 18,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            );
                                          } else {
                                            return ListView.builder(
                                              itemBuilder: (context, index) {
                                                return _rank(
                                                    context,
                                                    snapshots
                                                        .data.documents[index]);
                                              },
                                              itemCount: snapshots
                                                  .data.documents.length,
                                            );
                                          }
                                        },
                                      ),
                                    ),
                                    Container(
                                      alignment: Alignment.centerRight,
                                      width: double.infinity,
                                      child: Text(
                                        widget.snapshot.data['status'],
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color:
                                                Theme.of(context).primaryColor),
                                      ),
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(),
                                      width: MediaQuery.of(context).size.width *
                                          0.82,
                                      child: FlatButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(8)),
                                        padding:
                                            EdgeInsets.symmetric(vertical: 7),
                                        color: Colors.deepOrange,
                                        onPressed: () {
                                          if (widget.snapshot.data['status'] ==
                                              'Sedang Dilelang') {
                                            showDialog(
                                              barrierDismissible: false,
                                              context: context,
                                              builder: (_) {
                                                return AlertDialog(
                                                  title: Text('Tutup Lelang'),
                                                  content: Text(
                                                      'Akhiri Sesi Lelang ${widget.snapshot.data['nama']}?'),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () async {
                                                          Navigator.of(context)
                                                              .pop();
                                                          await Firestore
                                                              .instance
                                                              .collection(
                                                                  'lelang')
                                                              .document(widget
                                                                  .snapshot
                                                                  .documentID)
                                                              .setData({
                                                            'status':
                                                                'Lelang Ditutup',
                                                          }, merge: true);
                                                          setState(() {
                                                            _scaffoldKey
                                                                .currentState
                                                                .showSnackBar(
                                                                    SnackBar(
                                                              content: Text(
                                                                  'Sesi lelang berhasil ditutup'),
                                                              duration:
                                                                  Duration(
                                                                      seconds:
                                                                          2),
                                                            ));
                                                          });
                                                        },
                                                        child: Text(
                                                          'Ya',
                                                          style: TextStyle(
                                                              color: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                        )),
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop();
                                                        },
                                                        child: Text('Tidak',
                                                            style: TextStyle(
                                                                color: Theme.of(
                                                                        context)
                                                                    .accentColor)))
                                                  ],
                                                );
                                              },
                                            );
                                          } else {
                                            _scaffoldKey.currentState
                                                .showSnackBar(SnackBar(
                                              content: Text(
                                                  'Sesi lelang telah berakhir'),
                                              duration: Duration(seconds: 2),
                                            ));
                                          }
                                        },
                                        child: Text(
                                          'Tutup Lelang',
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
                        ],
                      ),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

Widget _rank(BuildContext context, DocumentSnapshot snapshot) {
  return Container(
    width: double.infinity,
    height: MediaQuery.of(context).size.height * 0.05,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          NumberFormat.compactCurrency(
                  locale: 'ID', symbol: 'IDR ', decimalDigits: 0)
              .format(snapshot.data['penawaran']),
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        Text(snapshot.data['username'].replaceAll('@lelang.com', '')),
      ],
    ),
  );
}
