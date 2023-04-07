import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Models/auth.dart';
class SuccessfulScreen extends StatefulWidget {
   SuccessfulScreen({Key? key}) : super(key: key);

  @override
  State<SuccessfulScreen> createState() => _SuccessfulScreenState();
}

class _SuccessfulScreenState extends State<SuccessfulScreen> {
   Stream count =Auth().streamCounterFromNative();


@override
  void dispose() {
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      body: StreamBuilder(
        stream:count,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
           
           var val=snapshot.data as List;
          var colorInt=int.tryParse('0xff${val[0]}') ;
          
           var colo =Color(colorInt!);
             //print(colo);
            return AnimatedContainer(
               duration: const Duration(seconds: 4),
               color:colo ,
              child: Column(
               mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   const Center(
                    child: Text('Congratulation', style: TextStyle(fontSize: 24),),
                  ),
                  Center(
                    child: Text(
                    Provider.of<Auth>(context,listen: false).resultValue.toString(),
                      style: Theme.of(context).textTheme.headline4,
                    ),
                  ),
                ],
              ),
            );
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }
}
