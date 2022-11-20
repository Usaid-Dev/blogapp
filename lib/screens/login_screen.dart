import 'package:blogapp/screens/forgot_password.dart';
import 'package:blogapp/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

import '../components/round_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  FirebaseAuth _auth = FirebaseAuth.instance;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool showSpinner = false;
  bool passenable = true;

  final _formkey = GlobalKey<FormState>();
  String email = '', password = '';

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: showSpinner,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Login'),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Login',
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
                          obscureText: passenable,
                          decoration: InputDecoration(
                            hintText: 'Password',
                            labelText: 'Password',
                            prefixIcon: const Icon(Icons.lock),
                            suffixIcon: IconButton(
                                onPressed: () {
                                  setState(() {
                                    if (passenable) {
                                      passenable = false;
                                    } else {
                                      passenable = true;
                                    }
                                  });
                                },
                                icon: Icon(passenable == true
                                    ? Icons.remove_red_eye
                                    : Icons.password)),
                            border: const OutlineInputBorder(),
                          ),
                          onChanged: (String value) {
                            password = value;
                          },
                          validator: (value) {
                            return value!.isEmpty ? 'enter password' : null;
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 30),
                        child: InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const ForgotPasswordScreen()));
                          },
                          child: const Align(
                            alignment: Alignment.centerRight,
                            child: Text('Forgot Password?'),
                          ),
                        ),
                      ),
                      RoundButton(
                        title: 'Login',
                        onPress: () async {
                          if (_formkey.currentState!.validate()) {
                            setState(
                              () {
                                showSpinner = true;
                              },
                            );

                            try {
                              final user =
                                  await _auth.signInWithEmailAndPassword(
                                      email: email.toString().trim(),
                                      password: password.toString().trim());

                              if (user != null) {
                                print("Success");
                                toastMessage("User Successfully Login");
                                setState(
                                  () {
                                    showSpinner = false;
                                  },
                                );
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const HomeScreen()));
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
