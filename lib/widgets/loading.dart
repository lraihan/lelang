import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xfff7f7f7),
      child: Center(
        child: SpinKitThreeBounce(
          color: Theme.of(context).primaryColor,
          size: 45,
        ),
      ),
    );
  }
}