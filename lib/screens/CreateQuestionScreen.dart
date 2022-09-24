import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:zap_ask/Models/Question.dart';
import 'package:zap_ask/Service/DatabaseServices.dart';
import 'package:zap_ask/Service/StorageService.dart';

class CreateQuestionScreen extends StatefulWidget {
  final String currentUserId;

  const CreateQuestionScreen({Key? key,required this.currentUserId}) : super(key: key);

  @override
  State<CreateQuestionScreen> createState() => _CreateQuestionScreenState();
}

class _CreateQuestionScreenState extends State<CreateQuestionScreen> {
  String _questionText='';
  File? _pickedImage;// null checks
  bool _loading=false;

  handleImageFromGallery() async {
    try{
      File imageFile=await ImagePicker.pickImage(source: ImageSource.gallery);
      if(imageFile!=null){
        setState(() {
          _pickedImage=imageFile;
        });
      }
    }catch(e){
      print(e);
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
     appBar: AppBar(
       centerTitle: true,
       backgroundColor: Colors.blue,
       title: const Text('Questions',
         style: TextStyle(
           color: Colors.white,
           fontSize: 20,
         ),),

     ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 18.0),
        child: Column(
          children: [
            SizedBox(height: 20,),
            TextField(
              maxLength: 300,
              maxLines: 7,
              decoration:const InputDecoration(
                hintText: 'Enter your question'
              ),
          onChanged: (value){
                _questionText=value;

          },
            ),
            SizedBox(height: 10,),
            _pickedImage==null?
                SizedBox.shrink():
                Column(
                  children: [
                    Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: FileImage(_pickedImage!),//null check
                        )
                      ),
                    ),
                    SizedBox(height: 20,)
                    
                  ],
                ),
            GestureDetector(
              onTap: handleImageFromGallery,
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.blue,
                    width: 2,

                  ),
                ),
                child: Icon(Icons.camera_alt,size: 50,color: Colors.blue,),
              ),
            ),
            const SizedBox(height: 20,),
            ElevatedButton(
              child:Text('Post'),
                onPressed: ()async{
                  setState(() {
                    _loading=true;
                  });
                  if(_questionText!=null && _questionText.isNotEmpty){
                    String image;
                    if(_pickedImage==null){
                      image='';
                    }else{
                      image=await StorageService.uploadQuestionPicture(_pickedImage!);//null checks
                    }
                    Question question=Question(
                        authorId: widget.currentUserId,
                        text: _questionText,
                        image: image,
                        likes: 0,
                        reposts: 0,
                      timestamp: Timestamp.fromDate(DateTime.now(),),);
                      DatabaseServices.createQuestion(question);
                      Navigator.pop(context);
                  }

                  setState(() {
                    _loading=false;
                  });
                },
                ),
            SizedBox(height: 20,),
            _loading?CircularProgressIndicator():SizedBox.shrink()


          ],
        ),
      ),
    );
  }
}
