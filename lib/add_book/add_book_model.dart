import 'dart:html';

import 'package:charts2_app/book_list/book.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class AddBookModel extends ChangeNotifier {
  String bookTitle;
  File imageFile;
  bool isLoading= false;

  startLoading(){
    isLoading=true;
    notifyListeners();
  }

  endLoading(){
    isLoading=false;
    notifyListeners();
  }

  Future addBookToFirebase() async {
    if (bookTitle.isEmpty) {
      throw ('タイトルを入力してください');
    }

    final imageURL = await _uploadImage();

    FirebaseFirestore.instance
      ..collection('books').add(
        {
          'title': bookTitle,
          'imageURL': imageURL,
          'createdAt': Timestamp.now(),
        },
      );
  }

  Future updateBook(Book book) async {
    final imageURL = await _uploadImage();

    final document =
    FirebaseFirestore.instance.collection('books').doc(book.documentID);
    await document.update({
      'title': bookTitle,
      'imageURL': imageURL,
      'createdAt': Timestamp.now(),
    });
  }

  Future showImagePicker() async {
    final picker = ImagePicker();

    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    imageFile = File(pickedFile.path);
    notifyListeners();
  }

  Future<String> _uploadImage() async {
    final Reference ref = FirebaseStorage.instance.ref();
    final TaskSnapshot storedImage = await ref
        .child(bookTitle)
        .putFile(imageFile);

      final String downloadUrl = await storedImage.ref.getDownloadURL();
      return downloadUrl;

  }
}
