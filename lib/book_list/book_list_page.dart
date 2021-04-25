import 'file:///C:/project/charts2_app/lib/book_list/book_list_model.dart';
import 'package:charts2_app/add_book/add_book_page.dart';
import 'package:charts2_app/user_preference/user_preference_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts2_app/book_list/book.dart';

class BookListPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BookListModel>(
      create: (_) => BookListModel()..fetchBooks(),
      child: Scaffold(
        appBar: AppBar(
          title: Text('問題集一覧'),
        ),
        body: Consumer<BookListModel>(
          builder: (context, model, child) {
            final books = model.books;
            final listTiles = books
                .map((book) => ListTile(
                      title: Text(
                        book.title,
                      ),
                     // leading: Image.network(book.imageURL),
                      trailing: IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AddBookPage(
                               // book:book,
                              ),
                              // await Navigator.pushNamed(context, '/addbook');
                            ),
                          );
                          model.fetchBooks();
                        },
                      ),
                    ))
                .toList();

            return ListView(
              children: listTiles,
            );
          },
        ),
        floatingActionButton:
            Consumer<BookListModel>(builder: (context, model, child) {
          return FloatingActionButton(
            child: Icon(Icons.add),
            onPressed: () async {
              await Navigator.pushNamed(context, '/addbook');
              model.fetchBooks();
            },
          );
        }),
      ),
    );
  }
}