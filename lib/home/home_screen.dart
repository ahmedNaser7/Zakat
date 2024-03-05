import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../base.dart';
import 'home_view_model.dart';
import 'navigator.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'home';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends BaseState<HomeScreen, HomeViewModel> implements HomeNavigator {
  @override
  HomeViewModel initViewModel() => HomeViewModel();

  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;
  }

  @override
  Widget build(BuildContext context) {
    // Define the custom color
    Color customColor = Color(0xFFcb9c12); // Use the hex code with 0xFF prefix for opacity

    return ChangeNotifierProvider(
      create: (_) => viewModel,
      child: Theme(
        data: ThemeData(
          // Apply the custom color to the primarySwatch.
          // Since primarySwatch expects a MaterialColor, we will use the custom color for primaryColor and accentColor
          primaryColor: customColor,
          floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: customColor,
          ),
          appBarTheme: AppBarTheme(
            color: customColor,
            elevation: 0,
          ),
        ),
        child: Builder(
          builder: (context) => Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: Text('Home'),
            ),
            floatingActionButton: FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () {
                // Navigator.of(context).pushNamed(AddRoomScreen.routeName);
              },
            ),
          ),
        ),
      ),
    );
  }
}
