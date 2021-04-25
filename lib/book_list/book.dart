import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  Book(QueryDocumentSnapshot doc) {
    documentID = doc.get(documentID);
    title = doc['title'];
    //imageURL = doc['imageURL'];
  }

  String title;
  String documentID;
  //String imageURL;
}
