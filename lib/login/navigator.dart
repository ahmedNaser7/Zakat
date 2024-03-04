import '../base.dart';
import '../my_user.dart';

abstract class LoginNavigator implements BaseNavigator{

  void gotoHome(MyUser user);
}