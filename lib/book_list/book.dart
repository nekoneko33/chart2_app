import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class Book {
  Book(QueryDocumentSnapshot doc) {
    documentID = doc.id;
    title = doc.data()['title'];
    imageURL = doc.data()['imageURL'] ;
  }

  String title;
  String documentID;
  String imageURL;
}
