import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

toastMessage({
  required String message,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  int timeInSecForIosWeb = 3,
  ToastGravity? gravity = ToastGravity.TOP,
  Toast toastLength = Toast.LENGTH_LONG,
}) {
  if (Platform.isMacOS) {
    return;
  }
  Fluttertoast.showToast(
    msg: message,
    toastLength: toastLength,
    gravity: gravity,
    timeInSecForIosWeb: timeInSecForIosWeb,
    backgroundColor: backgroundColor,
    textColor: textColor,
    webPosition: "center",
    webBgColor: "white",
    // webShowClose: true,
    fontSize: 16.0,
  );
}

downloadingToastMessageContext({
  required BuildContext context,
  required String title,
  required String message,
  Color backgroundColor = Colors.black,
  Color textColor = Colors.white,
  int toastDurationInS = 5,
}) {
  FToast fToast = FToast();
  fToast.init(context);

  Widget toast = Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(16.0), color: backgroundColor),
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 16),
              child: Icon(Icons.downloading, size: 50, color: Colors.white),
            ),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: textColor),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          fToast.removeCustomToast();
                        },
                        child: const Icon(Icons.close, color: Colors.white),
                      ),
                    ],
                  ),
                  Text(
                    message,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: textColor, height: 1.5),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const LinearProgressIndicator(backgroundColor: Colors.white, valueColor: AlwaysStoppedAnimation(Colors.green)),
      ],
    ),
  );
  // Widget toast = Container(
  //   padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
  //   decoration: BoxDecoration(
  //     borderRadius: BorderRadius.circular(8.0),
  //     color: backgroundColor,
  //   ),
  //   child: Column(
  //     mainAxisSize: MainAxisSize.min,
  //     children: [
  //       Text(title, style: TextStyle(fontSize: m, color: textColor, fontWeight: FontWeight.w500),),
  //       Text(message, style: TextStyle(color: textColor, fontSize: s, fontWeight: FontWeight.w400),),
  //     ],
  //   ),
  // );

  fToast.showToast(
    child: toast,
    gravity: ToastGravity.CENTER,
    fadeDuration: const Duration(milliseconds: 400),
    toastDuration: Duration(seconds: toastDurationInS),
  );
}
