import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:newsapp/screens/sign_in_screen.dart';
import 'package:newsapp/services/apis.dart';
import '../services/localdb.dart';
import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  static const String routeName = "splash";

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {



  var _visible = true;

  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    super.initState();
    getMail();
    animationController = AnimationController(
        vsync: this, duration: const Duration(seconds: 2));
    animation =
        CurvedAnimation(parent: animationController, curve: Curves.easeOut);

    animation.addListener(() => setState(() {}));
    animationController.forward();

    setState(() {
      _visible = !_visible;
    });
    startTime();
  }

  startTime() async {
    var duration = const Duration(seconds: 2);
    return Timer(duration, navigationPage);
  }


  String mail = "";

  getMail() async {
    await LocalDB.getEmail().then((value) {
      setState(() {
        mail = value.toString();
      });
    });
  }

  void navigationPage() async {
    if (mail!="null") {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, HomeScreen.routeName);
    } else {
      Navigator.popUntil(context, (route) => route.isFirst);
      Navigator.pushReplacementNamed(context, SignInScreen.routeName);
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return  Scaffold(
      //backgroundColor: backgroundColor,
      body: Center(
        child: Hero(
          tag: 'hero',
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              // Column(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   mainAxisSize: MainAxisSize.min,
              //   children: <Widget>[
              //     Padding(
              //         padding: const EdgeInsets.only(bottom: 30.0),
              //         child: Image.asset(
              //           "assets/images/logo.png",
              //           height: 25.0,
              //           fit: BoxFit.scaleDown,
              //         ))
              //   ],
              // ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    'assets/images/logo.png',
                    //color: Colors.white,
                    width: animation.value * 250,
                    height: animation.value * 250,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    )  ;
  }
}