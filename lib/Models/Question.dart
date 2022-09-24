
import 'package:cloud_firestore/cloud_firestore.dart';

class Question{
  String ?id;// null check
  String authorId='';
  String text='';
  String image='';
  late Timestamp timestamp;
  int likes=0;
  int reposts=0;
  Question({
     this.id,
     required this.authorId,
     required this.text,
     required this.image,
     required this.timestamp,
     required this.likes,
     required this.reposts,
  });
  factory Question.fromDoc(DocumentSnapshot doc){
    return Question(id: doc.id, authorId: doc['authorId'], text: doc['text'], image: doc['image'], timestamp: doc['timestamp'], likes: doc['likes'], reposts: doc['reposts']);

  }



}