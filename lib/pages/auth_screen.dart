import 'package:flutter/material.dart';
import 'package:pos_by_sakir/pages/login_page.dart';
import 'package:pos_by_sakir/values/app_constants.dart';
import 'package:pos_by_sakir/values/app_routes.dart';
import 'package:pos_by_sakir/values/app_theme.dart';

class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Theme.of(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Login and Register UI',
      theme: AppTheme.themeData,
      initialRoute: AppRoutes.loginScreen,
      routes: {
        AppRoutes.loginScreen: (context) => const LoginPage()
      },
    );
  }
}
