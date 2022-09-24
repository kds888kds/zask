import 'package:flutter/material.dart';
import 'package:zap_ask/screens/LogScreen.dart';
import 'package:zap_ask/screens/RegisterScreen.dart';
class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({Key? key}) : super(key: key);

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 180,),
            Center(
              child: Container(
                child: Text("Zap_ask",style: TextStyle(
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                color: Colors.blue),),

              ) ,

            ),
            Container(child: Text('Lets Help People'),),
            const SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
            }, child: Text('LOG IN')),
             const  SizedBox(height: 30,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>RegisterScreen()));
            }, child: Text('SIGN UP'))


          ],
        ),
      ),
    );
  }
}
