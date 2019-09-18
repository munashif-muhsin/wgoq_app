import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/components/story.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/pages/post.dart';
import 'package:wgoq_app/services/database_helpers.dart';
import 'package:wgoq_app/services/posts.dart';
import 'package:wgoq_app/services/util.dart';

class BookmarksPage extends StatefulWidget {
  @override
  _BookmarksPageState createState() => _BookmarksPageState();
}

class _BookmarksPageState extends State<BookmarksPage> {
  DatabaseHelper helper = DatabaseHelper.instance;
  List<Post> posts = [];
  bool isLoading = true;
  UtilService _utilService = UtilService();

  Widget _buildStoryItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PostPage(posts[index]),
          ),
        );
      },
      child: Dismissible(
        onDismissed: (DismissDirection direction) {
              if (direction == DismissDirection.endToStart) {
                removeItem(posts[index].id);
              }
            },
            direction: DismissDirection.endToStart,
            background: Container(
              padding: EdgeInsets.only(right: 20),
              alignment: Alignment.centerRight,
              color: Colors.red,
              child: Icon(
                Icons.delete,
                color: Colors.white,
              ),
            ),
            key: Key(index.toString()),
        child: StoryWidget(posts[index]),
      ),
    );
  }

  removeItem(int id) async {
    await _utilService.removeBookmark(id);
  }

  _getData() async {
    posts = await _utilService.getBookmarks();
    print(posts);
    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
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
      ),
    );
  }
}
