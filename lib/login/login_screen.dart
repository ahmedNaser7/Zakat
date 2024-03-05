import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base.dart';
import '../home/home_screen.dart';
import '../my_user.dart';
import '../register/register_screen.dart';
import '../user_provider.dart';
import 'login_view_model.dart';
import 'navigator.dart';

class LoginScreen extends StatefulWidget {
  static const String routeName = 'Login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends BaseState<LoginScreen, LoginViewModel>
    implements LoginNavigator {
  @override
  LoginViewModel initViewModel() => LoginViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  String email = '';
  String password = '';
  var formKey = GlobalKey<FormState>();

  // Define the gold color
  final Color goldColor = Color(0xffcb9c12);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginViewModel>(
      create: (buildContext) => viewModel,
      child: Stack(
        children: [
          Container(color: Colors.white),
          Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              centerTitle: true,
              elevation: 0,
              backgroundColor: Colors.transparent,
              title: Text(
                'Login',
                style: TextStyle(color: goldColor, fontWeight: FontWeight.bold),
              ),
            ),
            body: Container(
              padding: EdgeInsets.all(12),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: goldColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: goldColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: goldColor, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (text) {
                        email = text;
                      },
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter Email';
                        }

                        bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(text);
                        if (!emailValid) {
                          return 'Email format not valid';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 10),
                    TextFormField(
                      decoration: InputDecoration(
                        labelText: 'Password',
                        labelStyle: TextStyle(color: goldColor),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: goldColor),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: goldColor, width: 2),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onChanged: (text) {
                        password = text;
                      },
                      validator: (text) {
                        if (text == null || text.trim().isEmpty) {
                          return 'Please enter password';
                        }
                        if (text.trim().length < 6) {
                          return 'Password should be at least 6 chars';
                        }
                        return null;
                      },
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        validateForm();
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(goldColor),
                        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      child: Text(
                        'Login',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 10),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, RegisterScreen.routeName);
                      },
                      child: Text(
                        "Don't have an account ? ",
                        style: TextStyle(color: goldColor),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void validateForm() {
    if (formKey.currentState?.validate() == true) {
      viewModel.login(email, password);
    }
  }

  @override
  void gotoHome(MyUser user) {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.user = user;

    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }
}
