import 'dart:math';

String genretOrderId(){
  DateTime now = DateTime.now();

  int randomNumber = Random().nextInt(99999);
  String id ='${now.microsecondsSinceEpoch}_$randomNumber';

  return id;
}