import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:school_finder_app/ui/pages/home_pages/home_page.dart';

navigateHomePage(context) {
  Navigator.of(context).push(
    PageTransition(
      type: PageTransitionType.scale,
      alignment: Alignment.bottomCenter,
      child: HomePage(),
      inheritTheme: true,
      ctx: context,
    ),
  );
}

customDialog(title, context, content, onPress) {
  try {
    (content as String).length;
  } catch (e) {
    content = 'Try Again!!';
  }
  return showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        title: Text(
          title,
          style: TextStyle(color: Theme.of(context).primaryColorDark),
        ),
        content: Text((content as String)),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 8.0),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              color: Theme.of(context).primaryColor,
              onPressed: onPress,
              child: Text('Ok'),
            ),
          ),
        ],
      );
    },
  );
}
