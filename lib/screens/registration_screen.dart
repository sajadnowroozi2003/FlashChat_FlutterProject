import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat_starting_project/components/rounded_button.dart';
import 'package:flash_chat_starting_project/screens/chat_screen.dart';
import 'package:flash_chat_starting_project/services/auth_service.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '/constants.dart';
import 'package:flutter/material.dart';

class RegistrationScreen extends StatefulWidget {
  static String id = 'registration_screen';

  const RegistrationScreen({super.key});
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  String? errorMassage = '';
  bool errorOccurred = false, showSpinner = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'flash',
                  child: SizedBox(
                    height: 200.0,
                    child: Image.asset('images/logo.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 48.0,
              ),
              Form(
                key: _formkey,
                child: Column(
                  children: [
                    TextFormField(
                      decoration: kTextFildDecoration.copyWith(
                        hintText: 'Enter your email',
                        labelText: 'email',
                      ),
                      controller: _emailController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (email) {
                        return email != null && EmailValidator.validate(email)
                            ? null
                            : 'please enter a vaild email';
                      },
                    ),
                    SizedBox(
                      height: 18,
                    ),
                    TextFormField(
                      decoration: kTextFildDecoration.copyWith(
                        hintText: 'Enter your password',
                        labelText: 'password',
                      ),
                      obscureText: true,
                      controller: _passwordController,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      validator: (password) {
                        return password != null && password.length > 5
                            ? null
                            : 'The password be of 6 characters at least';
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 24.0,
              ),
              Visibility(
                visible: errorOccurred,
                child: Text(
                  '$errorMassage',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
                  ),
                ),
              ),
              RoundedButton(
                color: kRegisterButtonColor,
                title: 'Register',
                onPressed: () async {
                  //regidter the user
                  if (_formkey.currentState!.validate()) {
                    try {
                      setState(() {
                        showSpinner = true;
                        errorOccurred = false;
                      });
                      ;
                      await AuthService()
                          .createUser(
                        email: _emailController.text,
                        password: _passwordController.text,
                      )
                          .then((value) {
                        Navigator.pop(context);
                        Navigator.pushNamed(context, ChatScreen.id);
                      });
                      setState(() {
                        showSpinner = false;
                      });
                    } catch (e) {
                      print('Error ${e.toString()}');
                      setState(() {
                        errorMassage = e.toString().split('] ')[1];
                        errorOccurred = true;
                        showSpinner = false;
                      });
                    } // print('User data is in correct format');
                  } else {
                    setState(() {
                      errorMassage = 'please check your email and password';
                      errorOccurred = true;
                    });
                  }
                },
              ),
              const SizedBox(height: 12),
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
