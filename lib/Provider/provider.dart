import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Providers extends ChangeNotifier{
  bool isChanged=false;
 void updateTheme({required bool data}) async{
   isChanged=data;
   final SharedPreferences prefs = await SharedPreferences.getInstance();

// Save an integer value to 'counter' key.
   await prefs.setBool('isChanged', data);
   notifyListeners();

 }

 void getTheme() async{
   final SharedPreferences prefs = await SharedPreferences.getInstance();

// Save an integer value to 'counter' key.
   await prefs.getBool('isChanged')?? true;
   notifyListeners();
 }
}