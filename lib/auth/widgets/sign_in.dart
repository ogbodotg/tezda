import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/helper/utilities.dart';
import 'package:tezda/screen/home.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/state/auth_state.dart';
import 'package:tezda/theme/colour.dart';
import 'package:tezda/widgets/custom_flat_button.dart';

class SignIn extends StatefulWidget {
  static const String routeName = '/login-screen';

  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();

  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  String? email;
  String? password;
  Icon? icon;
  bool _visible = false;
  var loading = ValueNotifier(false);

  @override
  void dispose() {
    _emailTextController.dispose();
    _passwordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);

    Services services = Services();

    login() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          loading = ValueNotifier(true);
        });

        bool result = await state.login(
          email: _emailTextController.text,
          password: _passwordTextController.text,
          context: context,
        );
        if (result) {
          await state.getUserJsonData('loginData');

          state.setAuthStatus(true);
          if (context.mounted) {
            showSnackBar(context, "Login successful");

            // services.navigateTo(SplashScreen.routeName, '', context);
            Navigator.pushReplacement(
                context,
                PageRouteBuilder(
                    transitionDuration: const Duration(seconds: 1),
                    pageBuilder: (context, __, ___) {
                      return const HomeScreen();
                    }));
          }

          setState(() {
            loading = ValueNotifier(false);
          });
        } else {
          setState(() {
            loading = ValueNotifier(false);
          });
        }
      }
    }

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              services.authText(
                bigText: 'Login',
                smallText: 'Welcome Back! Log In to your Account',
              ),
              services.sizedBox(h: 40),
              services.formField(
                controller: _emailTextController,
                keyboardType: TextInputType.emailAddress,
                label: 'Email Address',
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Email Address';
                  }

                  email = _emailTextController.text;

                  return null;
                },
                context: context,
              ),
              services.sizedBox(h: 20),
              services.passwordFormField(
                controller: _passwordTextController,
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
                    return 'Please enter your password';
                  }
                  if (value.length <= 6) {
                    return 'Password must be more than six characters';
                  }
                  setState(() {
                    password = _passwordTextController.text;
                  });
                  return null;
                },
                context: context,
              ),
              services.sizedBox(h: 2),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 35),
                  child: CustomFlatButton(
                    label: 'Login',
                    borderRadius: 14,
                    color: AppColour.primary,
                    labelStyle: TextStyle(color: AppColour.black, fontSize: 20),
                    onPressed: login,
                    width: 0,
                    isLoading: loading,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
