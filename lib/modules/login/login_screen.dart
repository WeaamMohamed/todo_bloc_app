import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/layout/control_screen.dart';
import 'package:todo_app/modules/register/register_screen.dart';
import '../../shared/components/components.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isObscure = true;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          toolbarHeight: MediaQuery.of(context).size.height * 0.15,
          elevation: 0,
          backgroundColor: Colors.transparent,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                height: 20,
              ),
              Text(
                'Welcome back',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.w600,
                    color: Colors.black),
              ),
              Text(
                "Sign in to continue..",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            ],
          ),
        ),
        body: Container(
          // height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.only(top: 5, left: 10, right: 10),
          child: Center(
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    // Spacer(
                    //   flex: 1,
                    // ),
                    Column(
                      children: [
                        defaultTextForm(
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Email must not be null.';
                            }
                            return null;
                          },
                          icon: Icons.email,
                          labelText: 'Email Address',
                          keyboardType: TextInputType.emailAddress,
                          controller: emailController,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        defaultTextForm(
                          onSuffixPressed: () {
                            setState(() {
                              _isObscure = !_isObscure;
                            });
                          },
                          isObscure: _isObscure,
                          suffixIcon: _isObscure
                              ? Icons.visibility
                              : Icons.visibility_off,
                          icon: Icons.lock,
                          labelText: 'Password',
                          keyboardType: TextInputType.visiblePassword,
                          controller: passwordController,
                          validator: (String value) {
                            if (value.isEmpty) {
                              return 'Password must not be null.';
                            } else if (value.length < 6) {
                              return 'Password must be more than 6 characters';
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        defaultButton(
                            text: 'Log In',
                            onPressed: () {
                              _formKey.currentState.validate();
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (ctx) => ControlScreen()),
                              );
                            }),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Text(
                              'Dont\'t have an account?',
                              style: TextStyle(
                                color: Colors.grey[600],
                              ),
                            ),
                            SizedBox(
                              width: 5,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.of(context)
                                    .pushReplacement(MaterialPageRoute(
                                  builder: (ctx) => RegisterScreen(),
                                ));
                              },
                              child: Text(
                                'Register Now',
                                style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
