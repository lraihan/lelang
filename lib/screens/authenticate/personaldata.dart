import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lelangonline/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lelangonline/widgets/loading.dart';

class PersonalData extends StatefulWidget {
  final username;
  PersonalData(this.username);
  @override
  _PersonalDataState createState() => _PersonalDataState();
}

class _PersonalDataState extends State<PersonalData> {
  final _formkey = GlobalKey<FormState>();

  String nama, kota, telp, error = '';

  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        ? Loading()
        : Container(
            color: Color(0xfff7f7f7),
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage('assets/img/data.jpg'),
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
                  height: MediaQuery.of(context).size.height * 0.5,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 35),
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
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
                                  await Firestore.instance
                                      .collection('user')
                                      .document()
                                      .setData({
                                    'kota': kota,
                                    'level': 'User',
                                    'nama': nama,
                                    'telp': telp,
                                    'username': widget.username,
                                  }).whenComplete(() {
                                    setState(() {
                                      loading = false;
                                    });
                                    showDialog(
                                      barrierDismissible: false,
                                      context: context,
                                      builder: (_) {
                                        return AlertDialog(
                                          title: Text('Registrasi Berhasil'),
                                          content: Text(
                                              'Silahkan Masuk Terlebih Dahulu'),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pushReplacement(
                                                          MaterialPageRoute(
                                                              builder: (_) {
                                                    return MyApp();
                                                  }));
                                                },
                                                child: Text('OK'))
                                          ],
                                        );
                                      },
                                    );
                                  });
                                }
                              },
                              child: Text(
                                'Daftar',
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
