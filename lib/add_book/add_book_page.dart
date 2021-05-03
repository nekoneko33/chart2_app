import 'file:///C:/project/charts2_app/lib/book_list/book_list_model.dart';
import 'package:charts2_app/add_book/add_book_model.dart';
import 'package:charts2_app/book_list/book.dart';
import 'package:charts2_app/user_preference/user_preference_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddBookPage extends StatefulWidget {
  AddBookPage({this.book});

  final Book book;

  @override
  _AddBookPageState createState() => _AddBookPageState();
}


class _AddBookPageState extends State<AddBookPage> {
  bool isUpdate ;
  final textEditingController = TextEditingController();
 @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isUpdate= widget.book != null;
    if (isUpdate) {
      textEditingController.text = widget.book.title;
    }
  }

  @override
  Widget build(BuildContext context) {




    return ChangeNotifierProvider<AddBookModel>(
      create: (_) => AddBookModel(bookTitle:widget.book.title),
      child: Stack(
        children: [
          Scaffold(
            appBar: AppBar(
              title: Text(isUpdate ? '本を編集' : '問題集追加'),
            ),
            body: Consumer<AddBookModel>(
              builder: (context, model, child) {
                return Column(
                  children: <Widget>[
                    SizedBox(
                      width: 100,
                      height: 160,
                      child: InkWell(
                        onTap: () async {
                          await model.showImagePicker();
                        },
                        //child: Image.network('https://pics.prcm.jp/fb8c67e83f072/84692097/jpeg/84692097_218x291.jpeg')),
                        child: model.imageFile!= null? Image.file(model.imageFile):widget.book!=null&& widget.book.imageURL != null
                            ? Image.network(widget.book.imageURL)
                            : Container(
                                color: Colors.grey,
                              ),
                      ),
                    ),
                    TextField(
                      controller: textEditingController,
                      onChanged: (text) {
                        model.bookTitle = text;
                      },
                    ),
                    RaisedButton(
                        child: Text(isUpdate ? '更新する' : '追加する'),
                        onPressed: () async {
                          model.startLoading();
                          if (isUpdate) {
                            await updateBook(model, context);
                          } else {
                            await addBook(model, context);
                          }
                          model.endLoading();
                        }),
                  ],
                );
              },
            ),
          ),
          Consumer<AddBookModel>(builder: (context, model, child) {
            return model.isLoading
                ? Container(
                    color: Colors.grey.withOpacity(0.7),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : SizedBox();
          }),
        ],
      ),
    );
  }

  Future addBook(AddBookModel model, BuildContext context) async {
    try {
      await model.addBookToFirebase();
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('保存しました'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future updateBook(AddBookModel model, BuildContext context) async {
    try {
      await model.updateBook(widget.book);
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('更新しました'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
      Navigator.of(context).pop();
    } catch (e) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(e.toString()),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
