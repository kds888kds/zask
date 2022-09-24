import 'package:flutter/material.dart';
import 'package:zap_ask/screens/CreateQuestionScreen.dart';
import 'package:zap_ask/Models/Question.dart';
import 'package:zap_ask/Constants/Constants.dart';
import 'package:zap_ask/Models/UserModel.dart';
import 'package:zap_ask/Service/DatabaseServices.dart';

class HomeScreen extends StatefulWidget {
  final String currentUserId;
  const HomeScreen({Key? key, required this.currentUserId,}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List _followingQuestions=[];
  bool _loading=false;

  buildQuestion(Question question, UserModel author){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15),
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        child: Icon(Icons.add),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>CreateQuestionScreen(currentUserId: widget.currentUserId,)));// it's referenced as tweetscreen
        },
      ),
      body: Center(child: Text('HomeScreen'),),
    );
  }
}
