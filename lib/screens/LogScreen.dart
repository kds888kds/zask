import 'package:flutter/material.dart';
import 'package:zap_ask/Service/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  String _email='';
  String _password='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Log In'),


      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Enter Your Email'

              ),
              onChanged: (value){
                _email=value;

              },
            ),
            const SizedBox(height: 20,),
            TextField(
              obscureText: true,
              decoration: InputDecoration(
                  hintText: 'Enter Your Password'
              ),
              onChanged: (value){
                _password=value;

              },
            ),
            const SizedBox(height: 20,),
            ElevatedButton(onPressed:()async
    {
      bool isValid= await AuthService.login(_email,_password);
      if (isValid){
        Navigator.pop(context);
      }else{
        print('Login problem');
      }
    }, child: Text('Log In')),


          ],
        ),
      ),
    );
  }
}
