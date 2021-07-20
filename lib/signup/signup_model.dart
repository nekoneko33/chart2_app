import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';

class SignUpModel extends ChangeNotifier {
  String mail = '';
  String password = '';
  String username = '';
  String uid='';

  //FirebaseAuth auth = FirebaseAuth.instance;
  SignUpModel({this.mail,this.password,this.username});

  Map<String, dynamic> toJson() =>
      <String, dynamic>{'name':username,'uid':uid,'grouplist':[],'email':mail};

}
