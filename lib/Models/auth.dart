import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../key.dart';
// this notifier class will broadcast is fields and properties to any listener across the application
class Auth with ChangeNotifier {

 String? resultValue='Waiting';
   var _count;
  
 Future connect() async{
 var channel = const MethodChannel('androidtest2/firstpot');
  var con = await   channel.invokeMethod("connect");
  print(con);
}
// the login method of the Auth class uses a platform invokeMethod call to get a platform data. it send the 
//email and password provided to the backend platform with uses this parameter for processing and returns a result
  Future<void> login(String email, String password) async {
    final channel = const MethodChannel('androidtest2/firstpot');
   try {
    // login variable will house the result of the plaftform call
      var login= await   channel.invokeMethod('login',{"email":email,"password":password});
      print(login);
     // passing the data to a auth class property that can be listened to
      resultValue=login;
    }on PlatformException catch (e) {
      print("'${e}' An error occured");
    }

  }
// this a an event trigger from the flutter end to the platform end this method listens for any data 
// from the platform backend and returns the value.
// in this test the stream is listening for a stream of intergers which later will be converted to color and used with an
//animatedContainer to make a color change animation on the sucess page.
 Stream streamCounterFromNative() {
   const counterChannel =
   EventChannel('androidtest2/firstpot/events');
   return counterChannel.receiveBroadcastStream().map((event) {
     return event ;
   });
 }
}