import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart'; 
import 'package:pos_by_sakir/pages/auth_screen.dart'; 
import 'package:shared_preferences/shared_preferences.dart';
import 'package:pos_by_sakir/view/base_scaffold/base_scaffold.dart';
/*Developed: SAKIR
web: www.sakir-console.github.io
Email: sakir.console@gmail.com*/


class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}

void main() async {
  HttpOverrides.global = MyHttpOverrides();
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarIconBrightness: Brightness.light,
    ),
  );
  SharedPreferences preferences = await SharedPreferences.getInstance();
  var token = preferences.getString('token');
  // HttpOverrides.global = MyHttpOverrides();
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Pos Management',
        home: token == null ? const AuthScreen() : BaseScaffold(),
      ),
    ),
  );
}
