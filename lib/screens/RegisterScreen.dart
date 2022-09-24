import 'package:flutter/material.dart';

import '../Service/auth_service.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String _email='';
  String _password='';
  String _name='';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Sign Up'),


      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            const SizedBox(height: 20,),
            TextField(
              decoration: InputDecoration(
                  hintText: 'Enter Your Name'

              ),
              onChanged: (value){
                _name=value;

              },
            ),
            const SizedBox(height: 20,),
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
            ElevatedButton(onPressed: ()async
            {
              bool isValid= await AuthService.signUp(_name,_email,_password);
              if (isValid){
                Navigator.pop(context);
              }else{
                print('Something wrong');
              }
            }, child: const Text('Sign Up')),


          ],
        ),
      ),

    );
  }
}
