import 'package:flutter/material.dart';
import 'package:lelangonline/models/user.dart';
import 'package:lelangonline/screens/authenticate/authenticate.dart';
import 'package:lelangonline/screens/home/home.dart';
import 'package:provider/provider.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);

    return user != null ? Home(user): Authenticate();
    
  }
}