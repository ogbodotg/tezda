import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tezda/api/auth_data.dart';
import 'package:tezda/helper/enum.dart';
import 'package:tezda/helper/utilities.dart';
import 'package:tezda/model/user_model.dart';
import 'package:tezda/screen/home.dart';
import 'package:tezda/services/services.dart';

class AuthState extends ChangeNotifier {
  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  Services services = Services();
  bool _status = false;
  String _response = '';
  bool get getStatus => _status;
  String get getResponse => _response;
  // final EndPoint point = EndPoint();
  // User? userModel;
  bool loggedInStatus = false;
  User? userModel;
  // User? user;
  bool _isBusy = false;
  bool get isbusy => _isBusy;
  set isBusy(bool value) {
    if (value != _isBusy) {
      _isBusy = value;
      notifyListeners();
    }
  }

// set logged in status
  setAuthStatus(bool status) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('loggedIn', status);
  }

  // check logged in status
  checkAuthStatus() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();

    loggedInStatus = prefs.getBool('loggedIn') ?? false;
    notifyListeners();
  }

  // get current user
  getCurrentUser() async {
    await checkAuthStatus();
    bool _loggedInStatus = loggedInStatus;
    log('Logged in status is $_loggedInStatus');
    if (_loggedInStatus) {
      await getUserJsonData('loginData');
      notifyListeners();
    } else {
      authStatus = AuthStatus.NOT_LOGGED_IN;
      notifyListeners();
    }
  }

  // get saved json data
  getUserJsonData(key) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();

    var temp = prefs.getString('$key');
    var decodedTemp = jsonDecode(temp.toString());
    log('Decoded Saved Json Login Response $decodedTemp');
    authStatus = AuthStatus.LOGGED_IN;

    userModel = User.fromJson(decodedTemp);
    notifyListeners();
  }

// create new account
  createAccount({
    String? firstName,
    String? lastName,
    String? email,
    String? password,
    String? phone,
    context,
  }) async {
    _status = true;
    _response = "Please wait...";
    notifyListeners();
    var data = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'password': password,
    };
    await ApiData().saveJsonData(data, 'loginData');
    await getUserJsonData('loginData');
    setAuthStatus(true);
    services.navigateTo(HomeScreen.routeName, '', context);
    showSnackBar(context, "Registration successful");
  }

  // Login
  login({
    String? email,
    String? password,
    context,
  }) async {
    bool? result;
    final prefs = await SharedPreferences.getInstance();
    prefs.reload();
    var temp = prefs.getString('loginData');
    var decodedTemp = jsonDecode(temp.toString());
    User userModel = User.fromJson(decodedTemp);
    if (email!.toLowerCase() == userModel.email!.toLowerCase() &&
        password == userModel.password) {
      result = true;
    } else {
      result = false;
      showSnackBar(context, "Invalid Login Credentials");
    }
    return result;
  }
}
