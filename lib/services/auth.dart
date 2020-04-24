import 'package:firebase_auth/firebase_auth.dart';
import 'package:lelangonline/models/user.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  User _userFromFirebaseUser(FirebaseUser user){
    return user != null ? User(username: user.email) : null;
  }

  Stream<User> get user {
    return _auth.onAuthStateChanged.map(_userFromFirebaseUser);
  }

  Future registerUser(String username, String password) async{
    try {
      AuthResult result = await _auth.createUserWithEmailAndPassword(email: username, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signIn(String username, String password) async{
    try {
      AuthResult result = await _auth.signInWithEmailAndPassword(email: username, password: password);
      FirebaseUser user = result.user;
      return _userFromFirebaseUser(user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch(e) {
      return null;
    }
  }

}