import 'package:blogapp/components/round_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showSpinner = false;

  final _formkey = GlobalKey<FormState>();

  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Create Account'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Register',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 30),
                child: Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'Email',
                          label: Text('Email'),
                          prefixIcon: Icon(Icons.email),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (String value) {
                          email = value;
                        },
                        validator: (value) {
                          return value!.isEmpty ? 'enter email' : null;
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: TextFormField(
                          controller: passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          decoration: const InputDecoration(
                            hintText: 'Password',
                            label: Text('Password'),
                            prefixIcon: Icon(Icons.lock),
                            border: OutlineInputBorder(),
                          ),
                          onChanged: (String value) {
                            password = value;
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'enter password' : null;
                          },
                        ),
                      ),
                      RoundButton(
                        title: 'Register',
                        onPress: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(
                              () {
                                showSpinner = true;
                              },
                            );

                            try {
                              final user =
                                  await _auth.createUserWithEmailAndPassword(
                                      email: email.toString().trim(),
                                      password: password.toString().trim());

                              if (user != null) {
                                print("Success");
                                toastMessage("User Successfully Created");
                                setState(
                                  () {
                                    showSpinner = false;
                                  },
                                );
                              }
                            } catch (e) {
                              print(e.toString());
                              toastMessage(e.toString());
                              setState(
                                () {
                                  showSpinner = false;
                                },
                              );
                            }
                          }
                        },
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void toastMessage(String message) {
    Fluttertoast.showToast(
        msg: message.toString(),
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.SNACKBAR,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.white,
        textColor: Colors.black,
        fontSize: 16.0);
  }
}
