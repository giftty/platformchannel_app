import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
//import '../key.dart';

class Auth with ChangeNotifier {
 final _channel = const MethodChannel('androidtest2/firstpot');
 String? resultValue='Waiting';
   var _count;
  Future<void> signup(String email, String password) async {
    final url =Uri.parse("test.php"); //Uri.parse('$urlAuth' + '$apiKey');
    final response = await http.post(url, body: json.encode({
      'email': email,
      'password': password,
      'returnSecureToken': true,
    }));
    print(json.decode(response.body));
  }
 
 Future connect() async{
  var con = await   _channel.invokeMethod("connect");
  print(con);
}
  Future<void> login(String email, String password) async {
    // final url = Uri.parse("test.php"); //Uri.parse('$urlLogin' + '$apiKey');
    // final response = await http.post(url, body: json.encode({
    //   'email': email,
    //   'password': password,
    //   'returnSecureToken': true,
    // }));
    // print(json.decode(response.body));
   try {
      // _channel.setMethodCallHandler(_handleMessage);
      // _channel.invokeMethod<void>('login');
      var login= await   _channel.invokeMethod('login',{"email":email,"password":password});
      print(login);
      resultValue=login;
    }on PlatformException catch (e) {
      print("'${e}' An error occured");
    }

  }

 Stream streamCounterFromNative() {
   const counterChannel =
   EventChannel('androidtest2/firstpot/events');
   return counterChannel.receiveBroadcastStream().map((event) {
     return event ;
   });
 }
}