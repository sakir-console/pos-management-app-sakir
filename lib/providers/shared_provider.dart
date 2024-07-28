import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';


final vendorIdProvider = Provider((ref)  {

 // SharedPreferences preferences = await SharedPreferences.getInstance();
 // final vndId= preferences.getInt('vnd').toString();
  return '5';
});
