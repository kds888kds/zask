import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zap_ask/Constants/Constants.dart';
import 'package:zap_ask/Models/Question.dart';
import 'package:zap_ask/Models/UserModel.dart';
import 'package:zap_ask/Service/DatabaseServices.dart';
import 'package:zap_ask/screens/EditProfileScreen.dart';
import 'package:zap_ask/widgets/QuestionContainer.dart';

class ProfileScreen extends StatefulWidget {
  final String currentUserId;
  final String visitedUserId;

  const ProfileScreen({Key? key,required this.currentUserId, required this.visitedUserId}) : super(key: key);

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _followersCount=0;
  int _followingCount=0;
  bool _isFollowing=false;
  int _profileSegmentedValue=0;
  List<dynamic> _allQuestions=[];
  List<dynamic> _mediaQuestions=[];

  Map<int,Widget> _profileTabs=<int,Widget>{
    0:Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:    Text(
        'Questions ?',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    ),
    1:Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:    Text(
        'Media',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    ),
    2:Padding(
      padding: EdgeInsets.symmetric(vertical: 10),
      child:    Text(
        'Likes',
        style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: Colors.white
        ),
      ),
    )
  };
  Widget buildProfileWidgets(UserModel author){
    switch(_profileSegmentedValue){
      case 0:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _mediaQuestions.length,
            itemBuilder: (context,index){
              return QuestionContainer(
                author:author,
                question:_mediaQuestions[index],
              );
            });
        break;
      case 1:
        return ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: _allQuestions.length,
            itemBuilder: (context,index){
              return QuestionContainer(
                author:author,
                question:_allQuestions[index],
              );
            });
        break;
      case 2:
        return const Center( child: Text(
          'Likes',style: TextStyle(fontSize: 25),
        ),);
        break;
      default:
        return const Center( child: Text(
          'Something Wrong',style: TextStyle(fontSize: 25),
        ),);break;
    }
  }

  getFollowersCount() async {
    int followersCount= await DatabaseServices.followersNum(widget.visitedUserId);
    if(mounted){
      setState(() {
        _followersCount=followersCount;
      });
    }
  }

  getFollowingCount() async {
    int followingCount= await DatabaseServices.followingNum(widget.visitedUserId);
    if(mounted){
      setState(() {
        _followingCount=followingCount;
      });
    }
  }

  followOrUnFollow(){
    if(_isFollowing){
      unFollowUser();

    }else{
      followUser();
    }
  }

  unFollowUser(){
    DatabaseServices.unFollowUser(widget.currentUserId,widget.visitedUserId);
setState(() {
  _isFollowing=false;
  _followersCount--;
});
  }
followUser(){
    DatabaseServices.followUser(widget.currentUserId,widget.visitedUserId);
    setState(() {
      _isFollowing=true;
      _followersCount++;
    });
}

setupIsFollowing()async{
    bool isFollowingThisUser=await DatabaseServices.isFollowingUser(widget.currentUserId,widget.visitedUserId);
    setState(() {
      _isFollowing=isFollowingThisUser;
    });
}


getAllQuestions()async{
    List<dynamic> userQuestions= await DatabaseServices.getUserQuestions(widget.visitedUserId);
    if(mounted){
      setState(() {
        _allQuestions= userQuestions;

        setState(() {
          _mediaQuestions= _allQuestions.where((element)=> element.image.isNotEmpty).toList();
        });

      });
    }
}


  @override
  void initState() {
    super.initState();
    getFollowersCount();
    getFollowingCount();
    setupIsFollowing();
    getAllQuestions();

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: FutureBuilder(
        future: usersRef.doc(widget.visitedUserId).get(),
        builder: (BuildContext context,AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(
                valueColor:AlwaysStoppedAnimation(Colors.blue) ,
              ),
            );
          }
          UserModel userModel=UserModel.fromDoc(snapshot.data);
          return ListView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
            children: [
              Container(
                height: 150,
                decoration:BoxDecoration(
                  color: Colors.blue,
                  image: userModel.coverImage.isEmpty?null:DecorationImage(fit: BoxFit.cover,
                  image: NetworkImage(userModel.coverImage),),
                ) ,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal:20,vertical: 10 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end ,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                   widget.currentUserId==widget.visitedUserId? PopupMenuButton(
                        icon: Icon(Icons.more_horiz,color:Colors.white ,size: 30,),
                        itemBuilder: (_){
                          return<PopupMenuItem<String>>[
                          new PopupMenuItem(child: Text('Logout'), value: 'logout',)
                              ,

                    ];},
                    onSelected: (selectedItem){},
                    ):SizedBox(),
                  ],
                ),
              ),

              ),
              Container(
                transform: Matrix4.translationValues(0.0, -40.0, 0.0),
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.end ,
                      children: [
                        CircleAvatar(
                          radius: 45,
                          backgroundImage: userModel.profilePicture.isEmpty?
                          NetworkImage('https://images.unsplash.com/photo-1542550371427-311e1b0427cc?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=1170&q=80'):
                          NetworkImage(userModel.profilePicture),
                        ),
                        widget.currentUserId==widget.visitedUserId?
                        GestureDetector(
                          onTap: ()async {
                            await Navigator.push(context, MaterialPageRoute(builder: (context)=>EditProfileScreen(
                              user:userModel,
                            ),),);
                            setState(() {

                            });
                          },
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,border: Border.all(color: Colors.blue)
                            ),
                            child: Center(
                              child: Text(
                                'Edit',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                              ),
                              ),
                            ),
                          ),
                        )
                            :GestureDetector(
                      onTap: followOrUnFollow,
                          child: Container(
                            width: 100,
                            height: 35,
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: _isFollowing?Colors.white:Colors.blue,border: Border.all(color: Colors.blue)
                            ),
                            child: Center(
                              child: Text(
                                _isFollowing?'Following':'Follow',style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 17,
                                color: _isFollowing?Colors.blue:Colors.white,
                              ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 10,),
                    Text(userModel.name,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                    SizedBox(height: 10,),
                    Text(userModel.bio,style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),
                    SizedBox(height: 15,),
                    Row(
                      children: [
                        Text('$_followingCount Following',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 2),),
                        SizedBox(width: 20,),
                        Text('$_followersCount Followers',style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold,letterSpacing: 2),),
                      ],
                    ),
                    SizedBox(height: 20,),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      child: CupertinoSlidingSegmentedControl(
                        groupValue: _profileSegmentedValue,
                        thumbColor: Colors.blue,
                        backgroundColor: Colors.blueGrey,
                        children:_profileTabs ,
                        onValueChanged: (i){
                          setState(() {
                            _profileSegmentedValue= i!;
                          });
                        },

                      ) ,
                    ),
                  ],
                ),
              ),
              buildProfileWidgets(userModel),
            ],
          );
        },
      ),
    );
  }
}
