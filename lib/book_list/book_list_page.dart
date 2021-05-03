import 'package:charts2_app/book_list/book_list_model.dart';
import 'package:charts2_app/add_book/add_book_page.dart';
import 'package:charts2_app/loading/loading_model.dart';
import 'package:charts2_app/user_preference/user_preference_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:charts2_app/book_list/book.dart';

class BookListPage extends StatefulWidget {
  @override
  _BookListPageState createState() => _BookListPageState();
}

class _BookListPageState extends State<BookListPage> {
  BookListBloc bloc;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bloc.fetchBooks();
    });
  }

  @override
  Widget build(BuildContext context) {
    bloc = BookListBloc(loadingModel: Provider.of<LoadingModel>(context, listen: false));
    return Scaffold(
      appBar: AppBar(
        title: Text('問題集一覧'),
      ),
      body: StreamBuilder<List<Book>>(
        stream: bloc.controller.stream,
        builder: (context, snapshot) {
          if (!snapshot.hasData) return Container();
          final books = snapshot.data;
          final listTiles = books
              .map((book) => ListTile(
            title: Text(
              book.title,
            ),
            leading: book.imageURL != null && book.imageURL!=''? Image.network(book.imageURL) : null,
            trailing: IconButton(
              icon: Icon(Icons.edit),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddBookPage(
                      book:book,
                    ),
                    // await Navigator.pushNamed(context, '/addbook');
                  ),
                );
                bloc.fetchBooks();
              },
            ),
          ))
              .toList();

          return ListView(
            children: listTiles,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.pushNamed(context, '/addbook');
          bloc.fetchBooks();
        },
      ),
    );
  }
}
