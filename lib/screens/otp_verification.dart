import 'dart:async';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:newsapp/services/apis.dart';
import 'package:pinput/pinput.dart';

import '../services/localdb.dart';
import '../widgets/dialogbox.dart';
import 'home_screen.dart';


class VerifyOtp extends StatefulWidget {
  final String name;
  final String email;
  const VerifyOtp({Key? key,required this.name,required this.email}) : super(key: key);

  static const String routeName = "otp";

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {

  TextEditingController otp = TextEditingController();

  void showSnackBarText(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text,style: const TextStyle(color: Colors.white),),
        duration: const Duration(seconds: 3),
        backgroundColor: Colors.purple,
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
          fontSize: 20,
          color: Color.fromRGBO(30, 60, 87, 1),
          fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black54),
        borderRadius: BorderRadius.circular(20),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: const Color.fromRGBO(114, 178, 238, 1)),
      borderRadius: BorderRadius.circular(8),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration?.copyWith(
        color: const Color.fromRGBO(234, 239, 243, 1),
      ),
    );

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        margin: const EdgeInsets.only(left: 25, right: 25),
        alignment: Alignment.center,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/logo.png',
                width: 150,
                height: 150,
              ),
              const SizedBox(
                height: 25,
              ),
              const Text(
                "E-Mail Verification",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                "OTP sent on ${widget.email}!",
                style: const TextStyle(
                  fontSize: 16,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 30,
              ),
              Pinput(
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                controller: otp,
                keyboardType: TextInputType.phone,
                showCursor: true,
                // onCompleted: (pin) => print(pin),
              ),
              const SizedBox(
                height: 20,
              ),
              Material(
                elevation: 5,
                borderRadius: BorderRadius.circular(30),
                color: Colors.redAccent,
                child: MaterialButton(
                    padding: const EdgeInsets.fromLTRB(20, 15, 20, 15),
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () async {
                      if(otp.text.isEmpty){
                        Fluttertoast.showToast(
                            msg: "Please enter OTP!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else if(otp.text.length !=6){
                        Fluttertoast.showToast(
                            msg: "Please enter correct OTP!",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 1,
                            backgroundColor: Colors.redAccent,
                            textColor: Colors.white,
                            fontSize: 16.0
                        );
                      }else{
                        DialogBox().showLoaderDialog(context);
                       Future<bool> isSignUp= APIs().confirmUser(username: widget.name, confirmationCode: otp.text);
                       if(await isSignUp){
                         await LocalDB.saveMail(widget.name);
                         Navigator.popUntil(context, (route) => route.isFirst);
                         Navigator.pushReplacementNamed(context, HomeScreen.routeName);
                       }else{
                         Fluttertoast.showToast(
                             msg: "An error occurred!",
                             toastLength: Toast.LENGTH_SHORT,
                             gravity: ToastGravity.BOTTOM,
                             timeInSecForIosWeb: 1,
                             backgroundColor: Colors.redAccent,
                             textColor: Colors.white,
                             fontSize: 16.0
                         );
                      }
                      }
                    },
                    child: const Text(
                      "Verify E-mail",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
                    )
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Edit E-Mail?",
                        style: TextStyle(color: Colors.black),
                      )),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}