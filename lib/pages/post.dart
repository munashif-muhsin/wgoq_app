import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/services/util.dart';
import 'package:fluttertoast/fluttertoast.dart';

class PostPage extends StatefulWidget {
  final Post post;
  final String heroTagPrefix;
  PostPage(this.post, this.heroTagPrefix);

  @override
  _PostPageState createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {

  bool isBookmarked = false;
  UtilService _utilService = UtilService();

  checkIfBookmarked() async {
    Post post = await _utilService.getPostFromBookmark(widget.post.id);
    if(post == null) {
      setState(() {
        isBookmarked = false;
      });
    } else {
      setState(() {
        isBookmarked = true;
      });
    }
  }

  toggleBookmark() async {
    if(isBookmarked) {
      bool result = await _utilService.removeBookmark(widget.post.id);
      if(result) {
        Fluttertoast.showToast(
            msg: "Bookmark removed.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0
        );
        setState(() {
          isBookmarked  = false;
        });
      }
    } else {
      bool result = await _utilService.saveBookmark(widget.post);
      if(result) {
         Fluttertoast.showToast(
            msg: "Bookmark added.",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.BOTTOM,
            timeInSecForIos: 1,
            backgroundColor: Colors.black,
            textColor: Colors.white,
            fontSize: 14.0
        );
        setState(() {
          isBookmarked  = true;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    checkIfBookmarked();
  }

  @override
  Widget build(BuildContext context) {
    String dateString = '';
    dateString += widget.post.date.day.toString();
    dateString += '/' + widget.post.date.month.toString();
    dateString += '/' + widget.post.date.year.toString();
    dateString += ' ' + widget.post.date.hour.toString();
    dateString += ':' + widget.post.date.minute.toString();

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            elevation: 0,
            expandedHeight: 256.0,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                child: Stack(
                  children: <Widget>[
                    FadeInImage(
                      image: NetworkImage(widget.post.thumbnail),
                      height: 300.0,
                      width: MediaQuery.of(context).size.width,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/placeholder.png'),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(90),
                            topRight: Radius.circular(90),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                tag: widget.heroTagPrefix + widget.post.thumbnail,
              ),
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: isBookmarked ? Icon(Icons.bookmark) : Icon(Icons.bookmark_border),
                onPressed: () {
                  print('cliecked');
                  toggleBookmark();
                },
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  widget.post.title,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  dateString,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w300,
                    color: Colors.black87,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Html(
                  data: widget.post.content,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
