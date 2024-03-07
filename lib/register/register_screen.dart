import 'package:flutter/material.dart';
import 'package:my_zakat/register/register_view_model.dart';
import 'package:provider/provider.dart';

import '../base.dart';
import '../home/home_screen.dart';
import '../login/login_screen.dart';
import '../my_user.dart';
import '../user_provider.dart';
import 'navigator.dart';

class RegisterScreen extends StatefulWidget {
  static const String routeName = 'register';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends BaseState<RegisterScreen, RegisterViewModel>
    implements RegisterNavigator {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  String firstName = '';
  String lastName = '';
  String email = '';
  String password = '';
  String userName = '';

  final Color customColor = Color.fromARGB(255, 59, 129, 214); // Custom color

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  InputDecoration customInputDecoration(String labelText) {
    return InputDecoration(
      labelText: labelText,
      labelStyle: TextStyle(color: customColor),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: customColor),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: customColor),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Builder(builder: (_) {
        return Stack(
          children: [
            Container(
              color: Colors.white,
            ),
            Scaffold(
              backgroundColor: Colors.transparent,
              appBar: AppBar(
                centerTitle: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                title: Text(
                  'Create Account',
                  style: TextStyle(color: customColor),
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
                        decoration: customInputDecoration('First Name'),
                        style: TextStyle(
                            color: Colors
                                .black), // Text input color changed to black
                        onChanged: (text) {
                          firstName = text;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: customInputDecoration('Last Name'),
                        style: TextStyle(
                            color: Colors
                                .black), // Text input color changed to black
                        onChanged: (text) {
                          lastName = text;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: customInputDecoration('User Name'),
                        style: TextStyle(
                            color: Colors
                                .black), // Text input color changed to black
                        onChanged: (text) {
                          userName = text;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: customInputDecoration('Email'),
                        style: TextStyle(
                            color: Colors
                                .black), // Text input color changed to black
                        onChanged: (text) {
                          email = text;
                        },
                      ),
                      SizedBox(height: 10),
                      TextFormField(
                        decoration: customInputDecoration('Password'),
                        style: TextStyle(
                            color: Colors
                                .black), // Text input color changed to black
                        onChanged: (text) {
                          password = text;
                        },
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                          onPressed: validateForm,
                          child: Text('Create Account',
                              style: TextStyle(color: Colors.white)),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all<Color>(customColor),
                          )),
                      SizedBox(height: 10),
                      InkWell(
                        onTap: () {
                          Navigator.pushReplacementNamed(
                              context, LoginScreen.routeName);
                        },
                        child: Text(
                          "Already have an account? ",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: customColor, fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
          ],
        );
      }),
    );
  }

  void validateForm() {
    if (formKey.currentState?.validate() == true) {
      viewModel.register(email, password, firstName, lastName, userName);
    }
  }

  @override
  RegisterViewModel initViewModel() {
    return RegisterViewModel();
  }

  @override
  void gotoHome(MyUser user) {
    hideDialog();
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    userProvider.user = user;
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }
}
