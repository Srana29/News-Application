import 'package:amplify_auth_cognito/amplify_auth_cognito.dart';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:newsapp/screens/splash_screen.dart';
import 'package:newsapp/services/routes.dart';
import 'amplifyconfiguration.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.

  bool _isAmplifyConfigured = false;

  @override
  void initState() {
    super.initState();
    configureAmplify();
  }

  void configureAmplify() async {
    // First add plugins (Amplify native requirements)
    final auth =  AmplifyAuthCognito();

    await Amplify.addPlugin(auth);
    // Configure
    try {
      await Amplify.configure(amplifyconfig);
    } on AmplifyAlreadyConfiguredException {
      print(
          "Amplify was already configured. Looks like app restarted on android.");
    }
    setState(() {
      _isAmplifyConfigured = true;
      _isAmplifyConfigured ? print('Amplify Configured'): print('Amplify Not Configured');
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'News App',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        onGenerateRoute: Routes.onGenerateRoute,
        initialRoute: SplashScreen.routeName,
      home: _isAmplifyConfigured ?  const SplashScreen():Container()
    );
  }
}


