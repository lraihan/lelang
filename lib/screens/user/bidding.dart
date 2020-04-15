import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Bidding extends StatefulWidget {
  final DocumentSnapshot snapshot;
  Bidding(this.snapshot);

  @override
  _BiddingState createState() => _BiddingState();
}

class _BiddingState extends State<Bidding> {
  int initial, bid = 0;

  @override
  void initState() {
    initial = widget.snapshot.data['harga_akhir'] + 50000;
    bid = initial;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      color: Colors.blueGrey[50],
      child: Stack(
        children: <Widget>[
          Image.asset(
            'assets/img/bid.png',
            fit: BoxFit.cover,
          ),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      widget.snapshot.data['nama'],
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          NumberFormat.compactCurrency(
                                  locale: 'ID',
                                  symbol: 'IDR ',
                                  decimalDigits: 0)
                              .format(bid),
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_down),
                              onPressed: () {
                                if (bid <= initial) {
                                  setState(() {
                                    bid = initial;
                                  });
                                } else {
                                  setState(() {
                                    bid -= 50000;
                                  });
                                }
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.keyboard_arrow_up),
                              onPressed: () {
                                setState(() {
                                  bid += 50000;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Container(
                        width: MediaQuery.of(context).size.width * 0.5,
                        height: 30,
                        child: FlatButton(
                          color: Theme.of(context).primaryColor,
                          textColor: Colors.white,
                          child: Text(
                            'Tawar',
                            style: TextStyle(fontSize: 12),
                          ),
                          onPressed: () {},
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
    );
  }
}
