
import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel{
  String id='';
  String name='';
  String profilePicture='';
  String email='';
  String bio='';
  String coverImage='';
UserModel({required this.id,required this.email,required this.name,required this.bio,required this.coverImage,required this.profilePicture});

factory UserModel.fromDoc(DocumentSnapshot doc){
  return UserModel(id: doc.id, email: doc['email'], name: doc['name'], bio: doc['bio'], coverImage: doc['coverImage'], profilePicture: doc['profilePicture']);
}

}