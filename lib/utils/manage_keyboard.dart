import 'package:flutter/cupertino.dart';

class keyboardUtil {
  static void hidekeyboard(BuildContext context){
    FocusScopeNode currentfocus = FocusScope.of(context);

    if(!currentfocus.hasPrimaryFocus){
      currentfocus.unfocus();
    }
  }
}