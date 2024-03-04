import '../base.dart';
import '../my_user.dart';

abstract class RegisterNavigator extends BaseNavigator{
  void gotoHome(MyUser myUser);
}