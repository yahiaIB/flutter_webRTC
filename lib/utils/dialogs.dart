
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class Dialogs {

  static Future<bool> confirmDialog3(BuildContext context, title) {
    return showDialog<bool>(
        context: context,
        barrierDismissible: false, // user must tap button!
        builder: (BuildContext context) {
          return Container(
            child: new AlertDialog(
              title: new Text(title),
              actions: <Widget>[
                new FlatButton(
                  child: Text('YES'),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
                new FlatButton(
                  child: Text('NO'),
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                ),
              ],
            ),
          );
        });
  }
}
