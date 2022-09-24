import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:zap_ask/screens/HomeScreen.dart';
import 'package:zap_ask/screens/NotificationScreen.dart';
import 'package:zap_ask/screens/ProfileScreen.dart';
import 'package:zap_ask/screens/SearchScreen.dart';



class FeedScreen extends StatefulWidget {
  final String currentUserId;

  const FeedScreen({Key? key, required this.currentUserId}) : super(key: key);


  @override
  State<FeedScreen> createState() => _FeedScreenState();
}

class _FeedScreenState extends State<FeedScreen> {

int _selectedTab=0;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:[HomeScreen(
        currentUserId: widget.currentUserId,

      ),
        SearchScreen(
          currentUserId:widget.currentUserId,
        ),
        NotificationScreen(),
        ProfileScreen(
          currentUserId: widget.currentUserId,
          visitedUserId: widget.currentUserId,
        ),
        ].elementAt(_selectedTab) ,


      bottomNavigationBar: CupertinoTabBar(

        onTap:(index){
          setState(() {
            _selectedTab=index;
          });
        },
        activeColor: Colors.blue,
        currentIndex: _selectedTab,
 items: [
   BottomNavigationBarItem(icon: Icon(Icons.home)),
   BottomNavigationBarItem(icon: Icon(Icons.search)),
   BottomNavigationBarItem(icon: Icon(Icons.notifications)),
   BottomNavigationBarItem(icon: Icon(Icons.person)),

 ],
      ),



    );
  }
}
