import 'package:shared_preferences/shared_preferences.dart';

class LocalDB{
  static String emailKey = "#dsamdmnfkj4r34emcekcnkfenbfwEdcmnfejkmMAILKEY";

  static Future<bool> saveMail(String useremail) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(emailKey, useremail);
  }

  static Future<String?> getEmail() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.getString(emailKey);
  }

}