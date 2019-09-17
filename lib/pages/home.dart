import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/modals/category.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/services/posts.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
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
  bool isLoaded = false;
  List<Post> _latestPosts = [];
  List<Post> _posts = [];

  PostService _postService = PostService();


  Widget _buildLatestPostItem(BuildContext context, int index) {
    return Container(
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
              child: FadeInImage(
                alignment: Alignment.center,
                fit: BoxFit.cover,
                placeholder: AssetImage('assets/images/test_image.jpg'),
                image: NetworkImage(_latestPosts[index].thumbnail),
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
      child: index < _categories.length
          ? Text(
              _categories[index].name,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.bold),
            )
          : Text('see more'),
    );
  }

  Widget _buildStory(BuildContext context, int index) {

    String dateString = '';
    dateString += _posts[index].date.day.toString();
    dateString += '/' + _posts[index].date.month.toString();
    dateString += '/' + _posts[index].date.year.toString();
    dateString += ' ' + _posts[index].date.hour.toString();
    dateString += ':' + _posts[index].date.minute.toString();





    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Container(
        height: 100,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: FadeInImage(
                image: NetworkImage(_posts[index].thumbnail),
                placeholder: AssetImage('assets/images/test_image.jpg'),
                fit: BoxFit.cover,
                height: 80,
                width: 80,
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    _posts[index].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black),
                  ),
                ),
                SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.access_time,
                      size: 12,
                    ),
                    SizedBox(width: 5),
                    Text(
                      dateString,
                      style: TextStyle(fontSize: 11),
                    )
                  ],
                )
              ],
            )
          ],
        ),
      ),
    );
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
            ],
          );
  }
}
