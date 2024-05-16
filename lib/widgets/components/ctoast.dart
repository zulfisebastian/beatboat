import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'text/ctext.dart';

class CToast {
  static showCustom(BuildContext context, String message, Color color,
      [bool showIcon = false, ToastGravity gravity = ToastGravity.TOP]) {
    var toast = FToast();

    toast.init(context);
    toast.removeQueuedCustomToasts();
    toast.showToast(
      child: Container(
        padding: EdgeInsets.symmetric(
          vertical: 8,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8.0),
          color: color,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showIcon)
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  Icons.check,
                  size: 16,
                  color: Colors.white,
                ),
              ),
            if (showIcon)
              SizedBox(
                width: 8,
              ),
            Expanded(
              child: CText(
                message,
                align: TextAlign.center,
                overflow: TextOverflow.visible,
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ],
        ),
      ),
      toastDuration: Duration(milliseconds: 3500),
      gravity: gravity,
    );
  }

  static showWithoutCOntext(String message, Color color, Color textcolor,
      [ToastGravity gravity = ToastGravity.BOTTOM]) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: color,
      textColor: textcolor,
      fontSize: 16.0,
    );
  }
}
