import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/auth/auth_screen.dart';
import 'package:tezda/helper/enum.dart';
import 'package:tezda/screen/main_screen.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/state/auth_state.dart';

class SplashScreen extends StatefulWidget {
  static const String routeName = '/splash-screen';

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Services services = Services();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      timer();
    });
    super.initState();
  }

  /// Check if current app is updated app or not
  /// If app is not updated then redirect user to update app screen
  void timer() async {
    Future.delayed(const Duration(seconds: 3)).then((_) async {
      var state = Provider.of<AuthState>(context, listen: false);
      await state.getCurrentUser();
    });
  }

  Widget body() {
    var height = 150.0;
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Container(
        height: height,
        width: height,
        alignment: Alignment.center,
        child: Container(
          padding: const EdgeInsets.all(50),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.all(
              Radius.circular(10),
            ),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              services.showLoader(100),
              services.logo2(100.0, 100.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    log('User is currently ${state.authStatus}');
    return state.authStatus == AuthStatus.NOT_DETERMINED
        ? Scaffold(body: body())
        : state.authStatus == AuthStatus.NOT_LOGGED_IN
            ? const AuthScreen()
            : const MainScreen(index: 0);
  }
}
