

import 'dart:io';

import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import 'package:zap_ask/Constants/Constants.dart';
import 'package:firebase_storage/firebase_storage.dart';

class StorageService{
  static Future<String> uploadProfilePicture( String url,File imageFile) async{
    String? uniquePhotoId=Uuid().v4();// new id for every photo uploaded and can be nullable
    File image=await compressImage(uniquePhotoId,imageFile);
    if(url.isNotEmpty){
      RegExp exp =RegExp(r'userProfile_(.*).jpg');
      uniquePhotoId =exp.firstMatch(url)![1];// null checks

    }
UploadTask uploadTask=storageRef.child('images/users/userProfile_$uniquePhotoId.jpg').putFile(image);
    TaskSnapshot taskSnapshot= await uploadTask.whenComplete(() => null);
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }

  static Future<String> uploadCoverPicture( String url,File imageFile) async{
    String? uniquePhotoId=Uuid().v4();// new id for every photo uploaded and can be nullable
    File image=await compressImage(uniquePhotoId,imageFile);
    if(url.isNotEmpty){
      RegExp exp =RegExp(r'userCover_(.*).jpg');
      uniquePhotoId =exp.firstMatch(url)![1];// null checks

    }
    UploadTask uploadTask=storageRef.child('images/users/userCover_$uniquePhotoId.jpg').putFile(image);
    TaskSnapshot taskSnapshot= await uploadTask.whenComplete(() => null);
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }
  static Future<String> uploadQuestionPicture(File imageFile) async{
    String? uniquePhotoId=Uuid().v4();// new id for every photo uploaded and can be nullable
    File image=await compressImage(uniquePhotoId,imageFile);
    UploadTask uploadTask=storageRef.child('images/questions/question_$uniquePhotoId.jpg').putFile(image);
    TaskSnapshot taskSnapshot= await uploadTask.whenComplete(() => null);
    String downloadUrl= await taskSnapshot.ref.getDownloadURL();
    return downloadUrl;

  }


  static Future<File> compressImage(String photoId, File image) async{
    final tempDirection =await getTemporaryDirectory();
    final path= tempDirection.path;
    File? compressImage= await FlutterImageCompress.compressAndGetFile(image.absolute.path,
        '$path/img_$photoId.jpg',
        quality: 70);// null check again
         return compressImage!;// null check again

  }

}