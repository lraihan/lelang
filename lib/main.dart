import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/wrapper.dart';
import 'package:lelangonline/services/auth.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return StreamProvider<User>.value(
      value: AuthService().user,
      child: MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          accentColor: Colors.indigoAccent,
          scaffoldBackgroundColor: Colors.blueGrey[50],
          appBarTheme: AppBarTheme(
            iconTheme: IconThemeData(color: Theme.of(context).accentColor),
            textTheme: TextTheme(
              title: TextStyle(color: Colors.black87),
            ),
          ),
          fontFamily: 'Montserrat',
        ),
        home: Wrapper(),
      ),
    );
  }
}
