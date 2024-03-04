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

class _HomeScreenState extends BaseState<HomeScreen,HomeViewModel> implements
    HomeNavigator{
  @override
  HomeViewModel initViewModel() => HomeViewModel();
  @override
  void initState() {
    super.initState();
    viewModel.navigator = this;

  }
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (_)=>viewModel,
        child: Stack(
            children: [
              Container(
                color: Colors.white,
              ), Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(title: Text('Home'),
                  elevation: 0,
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: (){
                    // Navigator.of(context)
                    //     .pushNamed(AddRoomScreen.routeName);
                  },
                ),
              )])
    );
  }
}