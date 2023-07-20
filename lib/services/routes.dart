import 'package:flutter/cupertino.dart';
import 'package:newsapp/screens/otp_verification.dart';
import 'package:newsapp/screens/sign_in_screen.dart';
import 'package:newsapp/screens/sign_up_screen.dart';
import '../screens/home_screen.dart';
import '../screens/splash_screen.dart';

class Routes {

  static Route? onGenerateRoute(RouteSettings settings) {
    switch(settings.name) {


      case HomeScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const HomeScreen()
      );

      case SplashScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const SplashScreen()
      );

      case SignInScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const SignInScreen()
      );

      case SignUpScreen.routeName: return CupertinoPageRoute(
          builder: (context) => const SignUpScreen()
      );





      default: return null;

    }
  }

}