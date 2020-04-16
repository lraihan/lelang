import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/user/detail.dart';
import 'package:simple_search_bar/simple_search_bar.dart';

class Explore extends StatefulWidget {
  final User user;
  Explore(this.user);
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  final AppBarController appBarController = AppBarController();
  GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Color(0xfff7f7f7),
          image: DecorationImage(
            image: AssetImage('assets/img/explore.jpg'),
            fit: BoxFit.cover,
          )),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: Colors.transparent,
        appBar: SearchAppBar(
          searchFontSize: 16,
          primary: Colors.black54,
          appBarController: appBarController,
          searchHint: "Jam Tangan",
          mainTextColor: Colors.white,
          onChange: (String value) {
            _scaffoldKey.currentState.showSnackBar(SnackBar(
              content: Text('Fitur Dalam Pengembangan'),
              duration: Duration(seconds: 2),
            ));
          },
          mainAppBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            iconTheme: IconThemeData(color: Colors.indigoAccent),
            centerTitle: true,
            title: Text(
              'Cari Lelang',
              style:
                  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            ),
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.search,
                ),
                onPressed: () {
                  _scaffoldKey.currentState.showSnackBar(SnackBar(
                    content: Text('Fitur Dalam Pengembangan'),
                    duration: Duration(seconds: 2),
                  ));
                  appBarController.stream.add(true);
                },
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: StreamBuilder(
            stream: Firestore.instance
                .collection('lelang')
                .where('status', isEqualTo: 'Sedang Dilelang')
                .orderBy('tanggal', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        '0',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(' Lelang Tersedia'),
                    ],
                  ),
                );
              } else {
                return SingleChildScrollView(
                  child: Container(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                snapshot.data.documents.length.toString(),
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              Text(' Lelang Tersedia'),
                            ],
                          ),
                        ),
                        Container(
                          height: MediaQuery.of(context).size.height * 0.82,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: ListView.builder(
                            itemBuilder: (context, index) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(MaterialPageRoute(builder: (_) {
                                    return Detail(
                                        snapshot.data.documents[index],
                                        widget.user);
                                  }));
                                },
                                child: _catalog(
                                    context, snapshot.data.documents[index]),
                              );
                            },
                            itemCount: snapshot.data.documents.length,
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}

Widget _catalog(BuildContext context, DocumentSnapshot snapshot) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 5),
    child: Stack(
      children: <Widget>[
        Opacity(
          opacity: 0.7,
          child: Container(
            height: MediaQuery.of(context).size.height * 0.45,
            width: MediaQuery.of(context).size.width,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(),
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Column(
            children: <Widget>[
              Container(
                width: double.infinity,
                height: MediaQuery.of(context).size.height * 0.3,
                padding: EdgeInsets.only(top: 5),
                child: Card(
                  elevation: 3,
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
                    SizedBox(
                      height: 10,
                    ),
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
                          Text('Tawaran Tertinggi'),
                          Text(
                            NumberFormat.compactCurrency(
                                    locale: 'ID',
                                    symbol: 'IDR ',
                                    decimalDigits: 0)
                                .format(snapshot.data['harga_akhir']),
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 5),
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
