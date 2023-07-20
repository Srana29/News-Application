import 'package:flutter/material.dart';

class DialogBox{
  showLoaderDialog(BuildContext context){
    AlertDialog alert= AlertDialog(
      backgroundColor: Colors.black,
      content:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(margin: const EdgeInsets.only(left: 7,right: 7),child:const Text("Please Wait...",style: TextStyle(
              color: Colors.white
          ),)),
          const CircularProgressIndicator(
              color: Colors.white
          ),
        ],
      ),
    );
    showDialog(barrierDismissible: false,
      context:context,
      builder:(BuildContext context){
        return alert;
      },
    );
  }
}