import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/api/auth_data.dart';
import 'package:tezda/auth/auth_screen.dart';
import 'package:tezda/helper/utilities.dart';
import 'package:tezda/model/user_model.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/state/auth_state.dart';
import 'package:tezda/theme/colour.dart';
import 'package:tezda/widgets/custom_flat_button.dart';

class Profile extends StatefulWidget {
  static const String routeName = '/profile';

  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final _formKey = GlobalKey<FormState>();
  Services services = Services();

  User? _user;
  var loading = ValueNotifier(false);

  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _newPasswordTextController = TextEditingController();
  bool _visible = false;
  bool showForm = false;

  String? firstName;
  String? lastName;
  String? email;
  String? password;

  @override
  void initState() {
    getUser();
    super.initState();
  }

  getUser() {
    var authState = Provider.of<AuthState>(context, listen: false);
    if (authState.userModel != null) {
      _user = authState.userModel;
      _firstNameTextController.text = _user!.firstName!;
      _lastNameTextController.text = _user!.lastName!;
      _emailTextController.text = _user!.email!;
    }
    setState(() {});
  }

  Future<void> logOut() async {
    setState(() {
      loading = ValueNotifier(true);
    });
    // await ApiData().removeJsonData('loginData');
    var authState = Provider.of<AuthState>(context, listen: false);
    authState.setAuthStatus(false);
    services.navigateTo(AuthScreen.routeName, '', context);

    setState(() {
      loading = ValueNotifier(false);
    });
  }

  Future<void> _updateProfile() async {
    if (_formKey.currentState!.validate()) {
      if (_newPasswordTextController.text != _user!.password) {
        showSnackBar(context, "Wrong password");
      } else {
        setState(() {
          loading = ValueNotifier(true);
        });

        await updateUserToken(
          firstName: firstName,
          lastName: lastName,
          email: email,
          password: password,
        );
        setState(() {
          loading = ValueNotifier(false);
          showForm = false;
        });
        if (mounted) {
          showSnackBar(context, "Profile updated successfully");
        }
      }
    }
  }

  updateUserToken(
      {String? firstName,
      String? lastName,
      String? email,
      String? password}) async {
    var savedUserDetails = _user!.toJson();

    if (firstName != null) {
      savedUserDetails.update("firstName", (value) => firstName.toString());
    }

    if (lastName != null) {
      savedUserDetails.update("lastName", (value) => lastName.toString());
    }

    if (email != null) {
      savedUserDetails.update("email", (value) => email.toString());
    }

    if (password != null) {
      savedUserDetails.update("password", (value) => password.toString());
    }

    await ApiData().saveJsonData(savedUserDetails, 'loginData');

    if (mounted) {
      var authState = Provider.of<AuthState>(context, listen: false);

      await authState.getUserJsonData('loginData');
      User user = authState.userModel!;
      _user = user;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: services.appBar(showBackButton: false, context: context),
      backgroundColor: Colors.transparent,
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Container(
              width: MediaQuery.sizeOf(context).width,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  color: Colors.white),
              child: Padding(
                padding: const EdgeInsets.only(
                    left: 12, right: 12, top: 15, bottom: 15.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: AppColour.primary.withOpacity(0.2)),
                      child: const Icon(Icons.person_2_outlined, size: 50),
                    ),
                    services.sizedBox(h: 10),
                    if (_user != null)
                      Column(
                        children: [
                          Text(
                              '${_user!.firstName!.toUpperCase()} ${_user!.lastName!.toUpperCase()} ',
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500)),
                          Text(_user!.email!,
                              style: const TextStyle(fontSize: 14)),
                        ],
                      ),
                    services.sizedBox(h: 20),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          showForm = true;
                        });
                      },
                      child: const Text("Edit Profile"),
                    ),
                    services.sizedBox(h: 20),
                    ElevatedButton(
                      onPressed: () {
                        logOut();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColour.primary,
                      ),
                      child: const Text("Logout",
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                ),
              ),
            ),
          ),
          if (showForm)
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          services.formField(
                            controller: _firstNameTextController,
                            keyboardType: TextInputType.text,
                            label: 'First Name',
                            showLabel: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your First Name';
                              }

                              firstName = value;

                              return null;
                            },
                            context: context,
                          ),
                          services.sizedBox(h: 20),
                          services.formField(
                            controller: _lastNameTextController,
                            keyboardType: TextInputType.text,
                            label: 'Last Name',
                            showLabel: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Last Name';
                              }
                              lastName = value;

                              return null;
                            },
                            context: context,
                          ),
                          services.sizedBox(h: 20),
                          services.formField(
                            controller: _emailTextController,
                            keyboardType: TextInputType.emailAddress,
                            label: 'Email Address',
                            showLabel: true,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Email Address';
                              }
                              email = value;

                              return null;
                            },
                            context: context,
                          ),
                          services.sizedBox(h: 20),
                          services.passwordFormField(
                            controller: _newPasswordTextController,
                            label: 'Password',
                            keyboardType: TextInputType.visiblePassword,
                            visible: _visible,
                            onPressed: () {
                              setState(() {
                                _visible = !_visible;
                              });
                            },
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'Please enter your Password';
                              }
                              password = value;

                              return null;
                            },
                            context: context,
                          ),
                          services.sizedBox(h: 20),
                          Container(
                              margin: const EdgeInsets.symmetric(vertical: 35),
                              child: CustomFlatButton(
                                label: 'Update Profile',
                                borderRadius: 14,
                                color: AppColour.primary,
                                labelStyle: TextStyle(
                                    color: AppColour.black, fontSize: 20),
                                onPressed: _updateProfile,
                                width: 0,
                                isLoading: loading,
                              )),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
