import '../provider/base.dart';
import '../provider/my_user.dart';

abstract class RegisterNavigator extends BaseNavigator{
  void gotoHome(MyUser myUser);
}