
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zap_ask/Models/UserModel.dart';
import 'package:zap_ask/Service/DatabaseServices.dart';
import 'package:zap_ask/Service/StorageService.dart';

// have to change storage rules in firebase to open in order to store profile pics and cover images.

class EditProfileScreen extends StatefulWidget {
final UserModel user;

  const EditProfileScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  String _name='';
  String _bio='';
  var _profileImage;
  var _coverImage;// need them in file format
  String _imagePickedType='';
  final _formKey=GlobalKey<FormState>();
  bool _isLoading=false;

  displayCoverImage(){
if(_coverImage==null){
  if(widget.user.profilePicture.isNotEmpty){
    return NetworkImage(widget.user.coverImage);
  }

}else{
  return FileImage(_coverImage);
}
  }
  displayProfileImage(){
    if (_profileImage==null){
      if(widget.user.profilePicture.isEmpty){
        return NetworkImage('https://images.unsplash.com/photo-1662992672853-62155b6c3ceb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80');
      // default image
      }else{
        return NetworkImage(widget.user.profilePicture);
      }

    }else{
      return FileImage(_profileImage);
    }

  }
  handleImageFromGallery()async {
    try{
      File imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
      if(imageFile!=null){
        if(_imagePickedType=='profile'){
          setState(() {
            _profileImage=imageFile;
          });
        }else if(_imagePickedType=='cover'){
          setState(() {
            _coverImage=imageFile;
          });
        }
      }
    }catch(e){
      print(e);

    }
    
  }

saveProfile() async {
_formKey.currentState!.save();// null checks
if(_formKey.currentState!.validate()&&!_isLoading){// null checks
  setState(() {
    _isLoading=true;
  });
  String profilePictureUrl='';
  String coverPictureUrl='';
  if(_profileImage==null){
    profilePictureUrl=widget.user.profilePicture;

  }else {
    profilePictureUrl= await StorageService.uploadProfilePicture(
      widget.user.profilePicture,_profileImage,
    );
  }
  if(_coverImage==null){
    coverPictureUrl=widget.user.coverImage;

  }else {
    coverPictureUrl= await StorageService.uploadCoverPicture(
        widget.user.coverImage,_coverImage,
    );
  }
  UserModel user =UserModel(id: widget.user.id,
      email: widget.user.email,
      name: _name,
      bio: _bio,
      coverImage: coverPictureUrl,
      profilePicture: profilePictureUrl,);
  DatabaseServices.updateUserData(user);
  Navigator.pop(context);
}
}

@override
  void initState() {
    super.initState();
    _name=widget.user.name;
    _bio=widget.user.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        physics:  const BouncingScrollPhysics(
          parent: AlwaysScrollableScrollPhysics()
        ),
        children: [
          GestureDetector(
            onTap: (){
              _imagePickedType='cover';
              handleImageFromGallery();
            },
            child: Stack(
              children: [
                Container(
                height: 150,
                decoration:BoxDecoration(
                  color: Colors.blue,
                  image: _coverImage==null && widget.user.coverImage.isEmpty? null:
                  DecorationImage(
                    fit: BoxFit.cover,
                    image:displayCoverImage(),
                  ),
                ) ,

              ),

                Container(
                  height: 150,
                  color: Colors.black54,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.camera_alt,
                      size: 70,
                      color: Colors.white,),
                      Text('Change Cover Photo',
                        textAlign:TextAlign.center ,
                        style: TextStyle(
                        color: Colors.white,fontSize: 20,
                        fontWeight: FontWeight.bold,

                      ),

                      )

                    ],
                  ),
                )

              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            transform: Matrix4.translationValues(0, -40, 0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end ,
                  children: [
                    GestureDetector(
                      onTap: (){
                        _imagePickedType='profile';
                        handleImageFromGallery();
                      },
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 45,
                            backgroundImage: displayProfileImage(),
                          ),// they cover the part of image if you don't have one they provide with you with the default image
                          CircleAvatar(
                            radius: 45,
                              backgroundColor: Colors.black54,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Icon(Icons.camera_alt,
                                  size: 25,
                                  color: Colors.white,),
                                Text('Change Profile Photo',
                                  textAlign:TextAlign.center ,
                                  style: TextStyle(
                                    color: Colors.white,fontSize: 12,
                                    fontWeight: FontWeight.bold,

                                  ),

                                )

                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                    GestureDetector(
                      onTap: saveProfile,

                      child: Container(
                        width: 100,
                        height: 35,
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.blue,
                        ),
                        child: Center(
                          child: Text(
                            'Save',style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 17,
                            color: Colors.white
                          ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 30,),
                      TextFormField(
                        initialValue: _name,
                        decoration: InputDecoration(
                          labelText:'Name',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),

                        ),
                        validator: (input)=>input!.trim().length<2?// null checks
                        'Please Enter a Valid Name':null,
                        onSaved: (value){
                          _name=value!;// null checks
                        },
                      ),
                      const SizedBox(height: 30,),
                      TextFormField(
                        initialValue: _bio,
                        decoration: InputDecoration(
                          labelText:'Bio',
                          labelStyle: TextStyle(
                            color: Colors.blue,
                          ),

                        ),
                        onSaved: (value){
                          _bio=value!;// null checks
                        },
                      ),
                      const SizedBox(height: 30,),
                      _isLoading?CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Colors.blue),
                      ):SizedBox.shrink()



                    ],
                  ),
                )
              ],
            ),
          ),

        ],
      ),
    );
  }
}
