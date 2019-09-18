import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/components/story.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/pages/post.dart';
import 'package:wgoq_app/services/posts.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {

  List<Post> posts = [];
  bool isLoading = false;
  PostService _postService = PostService();
  TextEditingController _editingController = TextEditingController();

  Widget _buildStoryItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(builder: (BuildContext context) => PostPage(posts[index]),),
        );
      },
      child: StoryWidget(posts[index]),
    );
  }

  void startSearch() async {
    setState(() {
      isLoading = true;
    });
    String searchValue = _editingController.text;
    posts = await _postService.search(searchValue);
    setState(() {
      isLoading = false;
    });
  }  


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: TextField(
          enabled: !isLoading,
          controller: _editingController,
          autofocus: true,
          onEditingComplete: () {
            startSearch();
            FocusScope.of(context).requestFocus(FocusNode());
          },
          cursorColor: Colors.black,
          decoration: new InputDecoration(
            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.black)),
            prefixIcon: new Icon(Icons.search, color: Colors.black,),
            hintText: 'Search...',
          ),
        ),
      ),
      body: isLoading
          ? Center(
              child: SpinKitChasingDots(
                color: Colors.black87,
                size: 50,
              ),
            )
          : ListView.builder(
        itemCount: posts.length,
        itemBuilder: (BuildContext context, int index) {
          return _buildStoryItem(context, index);
        },
      ),
    );
  }

}
