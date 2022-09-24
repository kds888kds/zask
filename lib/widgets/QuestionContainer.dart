import 'package:flutter/material.dart';
import 'package:zap_ask/Models/Question.dart';
import 'package:zap_ask/Models/UserModel.dart';



class QuestionContainer extends StatefulWidget {
  final Question question;
  final UserModel author;

  const QuestionContainer({Key? key,required this.question,required this.author}) : super(key: key);

  @override
  State<QuestionContainer> createState() => _QuestionContainerState();
}

class _QuestionContainerState extends State<QuestionContainer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundImage: widget.author.profilePicture.isEmpty?
                    NetworkImage('https://images.unsplash.com/photo-1662992672853-62155b6c3ceb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80'):
                    NetworkImage(widget.author.profilePicture),
              ),
              SizedBox(width: 10,),
              Text(widget.author.name,style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.bold,
              ),)

            ],
          ),
          const SizedBox(height: 15,),
          Text(widget.question.text, style: TextStyle(fontSize: 12,
          fontWeight: FontWeight.bold),),
          widget.question.image.isEmpty?
              SizedBox.shrink():
          Column(
            children: [
              SizedBox(height: 15,),
              Container(height: 250,
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(10),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.question.image)
                  )
                ),

              ),
            ],
          ),
    SizedBox(height: 15,),
                           Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                  Row(children: [
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){

                                        }, icon: Icon(Icons.favorite_border)),
                                        Text(widget.question.likes.toString()+'Likes'),

                                      ],
                                    ),
                                    Row(
                                      children: [
                                        IconButton(onPressed: (){}, icon: Icon(Icons.repeat)),
                                        Text(widget.question.reposts.toString()+'Reposts'),
                                      ],
                                    )

                                  ],

                                                             ),
        ],

      ),
          Text(widget.question.timestamp.toDate().toString().substring(0,19),style: TextStyle(color: Colors.grey)),
          SizedBox(height: 20,),
          Divider()
   ]
    ),
    );
  }
}

