import 'package:flutter/material.dart';

dialogError(context, content) {
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Text(
          'Error Occured',
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        content: Text(content),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Ok'),
            ),
          ),
        ],
      );
    },
  );
}
