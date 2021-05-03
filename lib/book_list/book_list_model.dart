import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'book.dart';

class BookListModel extends ChangeNotifier {
  List<Book> books = [];

  Future fetchBooks() async {
    final docs = await FirebaseFirestore.instance.collection('books').get();

    final books = docs.docs.map((doc) {
      return Book(doc);
    }).toList();
    this.books = books;
    notifyListeners();
  }
}
