import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:firebase_storage/firebase_storage.dart';

class BukaLelang extends StatefulWidget {
  @override
  _BukaLelangState createState() => _BukaLelangState();
}

class _BukaLelangState extends State<BukaLelang> {
  File _image;
  String nama, deskripsi, harga, photo;
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueGrey[50],
        elevation: 0,
        centerTitle: true,
        title: Text('Buka Lelang'),
      ),
      body: Container(
        alignment: Alignment.center,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.95,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: SingleChildScrollView(
          child: Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                _image != null
                    ? GestureDetector(
                        onTap: chooseFile,
                        child: Container(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Image.file(
                            _image,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    : GestureDetector(
                        onTap: chooseFile,
                        child: Container(
                          color: Colors.grey,
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height * 0.25,
                          child: Center(
                            child: Text(
                              'Pilih Gambar',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (val) => val.isEmpty ? 'Nama Diperlukan' : null,
                  decoration: InputDecoration(
                    labelText: 'Nama Barang',
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
                      val.isEmpty ? 'Deskripsi Diperlukan' : null,
                  decoration: InputDecoration(
                    labelText: 'Deskripsi',
                  ),
                  onChanged: (val) {
                    setState(() {
                      deskripsi = val;
                    });
                  },
                ),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                  validator: (val) =>
                      val.isEmpty ? 'Harga Awal Diperlukan' : null,
                  decoration: InputDecoration(
                    labelText: 'Harga Awal',
                  ),
                  onChanged: (val) {
                    setState(() {
                      harga = val;
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
                    color: Colors.deepOrange,
                    onPressed: () async {
                      if (_formkey.currentState.validate() && _image != null) {
                        setState(() {
                          loading = true;
                        });
                        StorageReference storageReference = FirebaseStorage
                            .instance
                            .ref()
                            .child('chats/${Path.basename(_image.path)}}');
                        StorageUploadTask uploadTask =
                            storageReference.putFile(_image);
                        await uploadTask.onComplete;
                        print('File Uploaded');
                        storageReference.getDownloadURL().then((fileURL) async {
                          await Firestore.instance
                              .collection('lelang')
                              .document()
                              .setData({
                            'deskripsi': deskripsi,
                            'harga_akhir': int.parse(harga),
                            'harga_awal': int.parse(harga),
                            'nama': nama,
                            'photo': fileURL,
                            'status': 'Sedang Dilelang',
                            'tanggal': DateTime.now(),
                            'username': 'Kosong',
                          }).whenComplete(() {
                            setState(() {
                              loading = false;
                              showDialog(
                                barrierDismissible: false,
                                context: context,
                                builder: (_) {
                                  return AlertDialog(
                                    title: Text('Buka Lelang Berhasil'),
                                    content: Text('$nama Sedang Dilelang'),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).popUntil(
                                                (route) => route.isFirst);
                                          },
                                          child: Text('OK'))
                                    ],
                                  );
                                },
                              );
                            });
                          });
                        });
                      }
                    },
                    child: Text(
                      'Buka Lelang',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                        color: Color(0xfff7f7f7),
                      ),
                    ),
                  ),
                ),
                /* _image != null
                    ? RaisedButton(
                        child: Text('Upload File'),
                        onPressed: uploadFile,
                        color: Colors.cyan,
                      )
                    : Container(),
                _image != null
                    ? RaisedButton(
                        child: Text('Clear Selection'),
                        onPressed: () {},
                      )
                    : Container(),
                Text('Uploaded Image'),
                photo != null
                    ? Image.network(
                        photo,
                        height: 150,
                      )
                    : Container(), */
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future chooseFile() async {
    await ImagePicker.pickImage(source: ImageSource.gallery).then((image) {
      setState(() {
        _image = image;
      });
    });
  }
}
