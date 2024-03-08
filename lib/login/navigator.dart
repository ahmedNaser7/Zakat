import '../provider/base.dart';
import '../provider/my_user.dart';

abstract class LoginNavigator implements BaseNavigator{

  void gotoHome(MyUser user);
}