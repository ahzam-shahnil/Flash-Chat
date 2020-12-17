import 'package:flash_chat/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HelperFunctions {
  static String sharedPreferenceUserLoggedInKey = 'ISLOGGEDIN';
  static String sharedPreferenceUserNameKey = 'USERNAMEKEY';
  static String sharedPreferenceUserEmailKey = 'USEREMAILKEY';
  static String sharedPreferenceStartScreenKey = kWelcomeScreen;
  static resetPrefs() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setBool(sharedPreferenceUserLoggedInKey, false);
    preferences.setString(sharedPreferenceStartScreenKey, kWelcomeScreen);
    preferences.setString(sharedPreferenceUserEmailKey, '');
    preferences.setString(sharedPreferenceUserNameKey, '');
  }

  //SAVING DATA TO SHARED PREFERENCE
  static Future<bool> saveUserLoggedInSharedPreference(
      bool isUserLoggedIn) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setBool(
        sharedPreferenceUserLoggedInKey, isUserLoggedIn);
  }

  // static Future<bool> saveStartScreenSharedPreference(
  //     String startUpScreen) async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return await preferences.setString(
  //       sharedPreferenceStartScreenKey, startUpScreen);
  // }

  static Future<bool> saveUserNameSharedPreference(String userName) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserNameKey, userName.toLowerCase());
  }

  static Future<bool> saveUserEmailSharedPreference(String userEmail) async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return await preferences.setString(sharedPreferenceUserEmailKey, userEmail.toLowerCase());
  }

  static Future<bool> getUserLoggedInSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getBool(sharedPreferenceUserLoggedInKey);
  }

  static Future<String> getUserNameSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserNameKey);
  }

  // static Future<String> getStartScreenSharedPreference() async {
  //   SharedPreferences preferences = await SharedPreferences.getInstance();
  //   return preferences.getString(sharedPreferenceStartScreenKey);
  // }

  static Future<String> getUserEmailSharedPreference() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    return preferences.getString(sharedPreferenceUserEmailKey);
  }
}
