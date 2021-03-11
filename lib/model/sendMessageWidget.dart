import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class _SentMessageWidget extends StatelessWidget {
  final String message;

  _SentMessageWidget({this.message});

  final _formatter = DateFormat("HH:MM");

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            _formatter.format(DateTime.now()),
            style: const TextStyle(fontSize: 10),
          ),
          const SizedBox(width: 5),
          Column(
            children: [
              const SizedBox(height: 5),
              Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: 10,
                ),
                constraints: BoxConstraints(
                  maxWidth: MediaQuery
                      .of(context)
                      .size
                      .width * 0.6,
                ),
                decoration: const BoxDecoration(
                  color: Colors.lightGreenAccent,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Text(
                  message,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}