import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/components/story.dart';
import 'package:wgoq_app/modals/category.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/pages/post.dart';
import 'package:wgoq_app/services/posts.dart';

class CategoryPage extends StatefulWidget {
  final Category category;

  CategoryPage(this.category);

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  List<Post> _posts = [];
  bool isLoaded;
  ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  int currentPage = 1;
  bool isNewPageLoading = false;
  PostService _postService = PostService();

  Widget _buildStoryItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PostPage(_posts[index]),
          ),
        );
      },
      child: index != _posts.length
          ? StoryWidget(_posts[index])
          : isNewPageLoading
              ? Container(
                  alignment: Alignment.center,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: SpinKitWave(
                    color: Colors.black87,
                    size: 20,
                  ),
                )
              : Container(),
    );
  }

  loadNextPage() async {
    if (isNewPageLoading) {
      return;
    }
    setState(() {
      isNewPageLoading = true;
    });
    List<Post> newPosts = await _postService.getPostsByCategory(
        widget.category.id, currentPage + 1);
    currentPage++;
    setState(() {
      _posts.addAll(newPosts);
      isNewPageLoading = false;
    });
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      loadNextPage();
    }
  }

  _loadData() async {
    List<Post> posts =
        await _postService.getPostsByCategory(widget.category.id);
    isLoaded = true;
    _posts = posts;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    isLoaded = false;
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          widget.category.name,
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      ),
      body: !isLoaded
          ? Center(
              child: SpinKitChasingDots(
                color: Colors.black87,
                size: 50,
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: _posts.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return _buildStoryItem(context, index);
              },
            ),
    );
  }
}
