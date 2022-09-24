import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:zap_ask/screens/FeedScreen.dart';
import 'package:zap_ask/screens/HomeScreen.dart';
import 'package:zap_ask/screens/welcomescreen.dart';
void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  Widget getScreenId(){
    return StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder:(BuildContext context,snapshot){
          if(snapshot.hasData){
            return FeedScreen(currentUserId:snapshot.data!.uid ,);
          }else
            return WelcomeScreen();
        }
        );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(
      ),
      home: getScreenId(),
    );
  }
}
