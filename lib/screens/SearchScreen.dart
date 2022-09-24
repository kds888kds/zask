import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:zap_ask/Models/UserModel.dart';
import 'package:zap_ask/Service/DatabaseServices.dart';
import 'package:zap_ask/screens/ProfileScreen.dart';


class SearchScreen extends StatefulWidget {

  final String currentUserId;
  const SearchScreen({Key? key,  required this.currentUserId}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  Future<QuerySnapshot>? _users; // null checks
  TextEditingController _searchController = TextEditingController();

  clearSearch() {
    WidgetsBinding.instance.addPostFrameCallback((_) =>
        _searchController.clear());
    setState(() {
      _users = null;
    });
  }

    buildUserTile(UserModel user) {
      return ListTile(
        leading: CircleAvatar(
          radius: 20,
          backgroundImage: user.profilePicture.isEmpty
              ?
          NetworkImage(
              'https://images.unsplash.com/photo-1662992672853-62155b6c3ceb?ixlib=rb-1.2.1&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=2070&q=80')
              :
          NetworkImage(user.profilePicture),
        ),
        title: Text(user.name),
        onTap: () {
          Navigator.of(context).push(
              MaterialPageRoute(builder: (context) =>
                  ProfileScreen(currentUserId: widget.currentUserId,
                      visitedUserId: user.id))
          );
        },
      );
    }
    @override
    Widget build(BuildContext context) {
      return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.5,
          title: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 15),
              hintText: 'Search ZapAsk ... ',
              hintStyle: TextStyle(color: Colors.white,

              ),
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.white,),
              suffixIcon: IconButton(
                icon: Icon(Icons.clear, color: Colors.white,),
                onPressed: () {
                  clearSearch();
                },),
              filled: true,
            ),
            onChanged: (input) {
              if (input.isNotEmpty) {
                setState(() {
                  _users = DatabaseServices.searchUsers(
                      input); // need to add a search for questions as well and I need to add tags
                });
              }
            },
          ),
        ),
        body: _users == null ?
        Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Icon(Icons.search, size: 200),
              Text('Search ZaPAsk....need to add # and question searching ',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),)
            ],
          ),
        ) : FutureBuilder(
            future: _users,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: CircularProgressIndicator(),
                );
              }
              if (snapshot.data.documents.length == 0) {
                return Center(
                  child: Text('No users found'),
                );
              }
              return ListView.builder(
                  itemCount: snapshot.data.documents.length,
                  itemBuilder: (BuildContext context, int index) {
                    UserModel user = UserModel.fromDoc(
                        snapshot.data.documents[index]);
                    return buildUserTile(user);
                  });
            }),

      );
    }
  }

