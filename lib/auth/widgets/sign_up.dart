import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tezda/helper/utilities.dart';
import 'package:tezda/services/services.dart';
import 'package:tezda/state/auth_state.dart';
import 'package:tezda/theme/colour.dart';
import 'package:tezda/widgets/custom_flat_button.dart';

class SignUp extends StatefulWidget {
  static const String routeName = '/register-screen';

  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  Services services = Services();

  final _formKey = GlobalKey<FormState>();
  final _firstNameTextController = TextEditingController();
  final _lastNameTextController = TextEditingController();
  final _emailTextController = TextEditingController();
  final _passwordTextController = TextEditingController();
  final _confirmPasswordTextController = TextEditingController();

  Icon? icon;
  bool _visible = false;
  var loading = ValueNotifier(false);

  @override
  void dispose() {
    _firstNameTextController.dispose();
    _lastNameTextController.dispose();
    _emailTextController.dispose();
    _passwordTextController.dispose();
    _confirmPasswordTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var state = Provider.of<AuthState>(context);
    Services services = Services();

    signUp() async {
      if (_formKey.currentState!.validate()) {
        if (_passwordTextController.text !=
            _confirmPasswordTextController.text) {
          showSnackBar(context, "Password doesn\'t match");
        } else {
          setState(() {
            loading = ValueNotifier(true);
          });

          state.createAccount(
            firstName: _firstNameTextController.text,
            lastName: _lastNameTextController.text,
            email: _emailTextController.text,
            password: _passwordTextController.text,
            context: context,
          );
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
                bigText: 'Register',
                smallText: 'Create your account',
              ),
              services.sizedBox(h: 40),
              services.formField(
                controller: _firstNameTextController,
                keyboardType: TextInputType.text,
                label: 'First Name',
                showLabel: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your First Name';
                  }

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
                    return 'Please enter your Password';
                  }
                  if (value.length <= 6) {
                    return 'Password must be more than six characters';
                  }

                  return null;
                },
                context: context,
              ),
              services.sizedBox(h: 20),
              services.passwordFormField(
                controller: _confirmPasswordTextController,
                label: 'Confirm Password',
                keyboardType: TextInputType.visiblePassword,
                visible: _visible,
                onPressed: () {
                  setState(() {
                    _visible = !_visible;
                  });
                },
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Please enter your Confirm Password';
                  }
                  if (value.length <= 6) {
                    return 'Password must be more than six characters';
                  }

                  return null;
                },
                context: context,
              ),
              services.sizedBox(h: 2),
              Container(
                  margin: const EdgeInsets.symmetric(vertical: 35),
                  child: CustomFlatButton(
                    label: 'Register',
                    borderRadius: 14,
                    color: AppColour.primary,
                    labelStyle: TextStyle(color: AppColour.black, fontSize: 20),
                    onPressed: signUp,
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
