import 'dart:async';

import 'package:charts2_app/loading/loading_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'book.dart';

// Bloc
class BookListBloc {
  final StreamController<List<Book>> controller = StreamController<List<Book>>();
  final LoadingModel loadingModel;

  BookListBloc({@required this.loadingModel});

  Future fetchBooks() async {
    loadingModel.startLoading();
    final docs = await FirebaseFirestore.instance.collection('books').get();

    final books = docs.docs.map((doc) {
      return Book(doc);
    }).toList();
    controller.sink.add(books);
    loadingModel.endLoading();
  }

  void dispose() {
    controller.close();
  }
}
