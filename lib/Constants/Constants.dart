import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

final _fireStore=FirebaseFirestore.instance;


final usersRef =_fireStore.collection('users');

final followersRef= _fireStore.collection('followers');
final followingRef= _fireStore.collection('following');

final storageRef =FirebaseStorage.instance.ref();
final questionRef =_fireStore.collection('questions');