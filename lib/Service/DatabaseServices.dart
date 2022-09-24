
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zap_ask/Constants/Constants.dart';
import 'package:zap_ask/Models/Question.dart';
import 'package:zap_ask/Models/UserModel.dart';

class DatabaseServices{
  static Future<int> followersNum(String userId) async{
    QuerySnapshot followersSnapshot =await followersRef.doc(userId).collection('Followers').get();
    return followersSnapshot.docs.length;


  }
  static Future<int> followingNum(String userId) async{
    QuerySnapshot followingSnapshot =await followingRef.doc(userId).collection('Following').get();
    return followingSnapshot.docs.length;


  }

  static void updateUserData(UserModel user){
    usersRef.doc(user.id).update({
      'name': user.name,
      'bio':user.bio,
      'profilePicture':user.profilePicture,
      'coverImage':user.coverImage,

    });
  }
  static Future<QuerySnapshot> searchUsers( String name) async{
    Future<QuerySnapshot> users =usersRef.where('name',isGreaterThanOrEqualTo: name)
        .where('name',isLessThan: name+'z').get();
    return users;
  }

  static void followUser(String currentUserId,String visitedUserId){
   followingRef.doc(currentUserId).collection('Following').doc(visitedUserId).set({});
   followersRef.doc(currentUserId).collection('Followers').doc(visitedUserId).set({});
    }
  static void unFollowUser(String currentUserId,String visitedUserId){
    followingRef.doc(currentUserId).collection('Following').doc(visitedUserId).get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });
    followersRef.doc(visitedUserId).collection('Followers').doc(currentUserId).get().then((doc){
      if(doc.exists){
        doc.reference.delete();
      }
    });

  }
  static Future<bool> isFollowingUser(String currentUserId,String visitedUserId) async{
    DocumentSnapshot followingDoc =await followersRef.doc(visitedUserId).collection('Followers').doc(currentUserId).get();
    return followingDoc.exists;

  }


  static void createQuestion( Question question){
    questionRef.doc(question.authorId).set({
      'questionTime':question.timestamp
    });
    questionRef.doc(question.authorId).collection('userQuestions').add({
      'text':question.text,
      'image':question.image,
      'authorId':question.authorId,
      'timestamp':question.timestamp,
      'likes':question.likes,
      'reposts':question.reposts,
    });
  }
  static Future<List> getUserQuestions(String userId) async{
    QuerySnapshot userQuestionsSnap= await questionRef.doc(userId).collection('userQuestions').orderBy('timestamp', descending: true).get();
    List<dynamic> userQuestions= userQuestionsSnap.docs.map((doc) => Question.fromDoc(doc)).toList();
    return userQuestions;

  }


}