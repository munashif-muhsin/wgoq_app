import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/components/story.dart';
import 'package:wgoq_app/modals/category.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/pages/category.dart';
import 'package:wgoq_app/pages/post.dart';
import 'package:wgoq_app/services/posts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with AutomaticKeepAliveClientMixin {
  List<Color> _colors = [
    Colors.blue[800],
    Colors.pinkAccent[400],
    Colors.orangeAccent[700],
    Colors.teal[400],
    Colors.black,
    Colors.cyanAccent[700],
    Colors.deepOrangeAccent[400],
    Colors.deepPurpleAccent[700],
    Colors.indigo[800],
    Colors.blueGrey[600],
  ];
  List<Category> _categories = [];
  bool isLoaded;
  List<Post> _latestPosts = [];
  List<Post> _posts = [];
  ScrollController _scrollController;
  final _scrollThreshold = 200.0;
  int currentPage = 1;
  bool isNewPageLoading = false;

  PostService _postService = PostService();

  Widget _buildLatestPostItem(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PostPage(_latestPosts[index]),
          ),
        );
      },
      child: Container(
        width: 280,
        margin: EdgeInsets.only(left: 15, top: 15, bottom: 15),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Stack(
            children: <Widget>[
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                top: 0,
                child: Hero(
                  tag: _latestPosts[index].thumbnail,
                  child: FadeInImage(
                    alignment: Alignment.center,
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/placeholder.png'),
                    image: NetworkImage(_latestPosts[index].thumbnail),
                  ),
                ),
              ),
              Positioned(
                child: Container(
                  padding: EdgeInsets.all(10),
                  color: Colors.black38,
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.centerRight,
                        width: MediaQuery.of(context).size.width,
                        child: IconButton(
                          icon: Icon(
                            Icons.bookmark_border,
                            color: Colors.white,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      Spacer(
                        flex: 1,
                      ),
                      Text(
                        _latestPosts[index].title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  ListView _buildLatestPosts() {
    return ListView.builder(
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemCount: _latestPosts.length,
      itemBuilder: (BuildContext context, int index) {
        return _buildLatestPostItem(context, index);
      },
    );
  }

  Widget _buildCategories(BuildContext context, int index) {
    return Container(
      margin: index != 0 ? EdgeInsets.only(left: 7) : EdgeInsets.only(left: 15),
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: index < _categories.length ? _colors[index] : Colors.white,
        borderRadius: BorderRadius.circular(5),
      ),
      alignment: Alignment.center,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (BuildContext context) =>
                  CategoryPage(_categories[index]),
            ),
          );
        },
        child: index < _categories.length
            ? Text(
                _categories[index].name,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.bold),
              )
            : Text('see more'),
      ),
    );
  }

  Widget _buildStory(BuildContext context, int index) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (BuildContext context) => PostPage(_posts[index]),
          ),
        );
      },
      child: StoryWidget(_posts[index]),
    );
  }

  loadNextPage() async {
    if (isNewPageLoading) {
      return;
    }
    setState(() {
      isNewPageLoading = true;
    });
    List<Post> newPosts = await _postService.getPosts(currentPage + 1);
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
    Map pageContent = await _postService.getHomePageContent();
    isLoaded = true;
    _categories = pageContent['categories'];
    _latestPosts = pageContent['latest'];
    _posts = pageContent['posts'];
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
    return !isLoaded
        ? Center(
            child: SpinKitChasingDots(
              color: Colors.black87,
              size: 50,
            ),
          )
        : ListView(
            controller: _scrollController,
            children: <Widget>[
              SafeArea(
                child: Container(
                  margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                  alignment: Alignment.bottomLeft,
                  width: 50,
                  height: 50,
                  child: Image.asset('assets/images/wgoq_logo.png'),
                ),
              ),
              Container(
                child: _buildLatestPosts(),
                height: 250,
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                child: Text(
                  'Categories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                height: 40,
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length + 1,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildCategories(context, index);
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.only(top: 25, left: 20, bottom: 10),
                child: Text(
                  'Popular Stories',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 10),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  itemCount: _posts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildStory(context, index);
                  },
                ),
              ),
              isNewPageLoading
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.symmetric(vertical: 15),
                      child: SpinKitWave(
                        color: Colors.black87,
                        size: 20,
                      ),
                    )
                  : Container(),
            ],
          );
  }

  @override
  bool get wantKeepAlive => true;
}
