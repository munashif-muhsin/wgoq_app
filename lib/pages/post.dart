import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:wgoq_app/modals/post.dart';

class PostPage extends StatelessWidget {
  final Post post;

  PostPage(this.post);

  @override
  Widget build(BuildContext context) {
    String dateString = '';
    dateString += post.date.day.toString();
    dateString += '/' + post.date.month.toString();
    dateString += '/' + post.date.year.toString();
    dateString += ' ' + post.date.hour.toString();
    dateString += ':' + post.date.minute.toString();

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
                      image: NetworkImage(post.thumbnail),
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
                tag: post.thumbnail,
              ),
            ),
            backgroundColor: Colors.white,
            actions: <Widget>[
              IconButton(
                icon: Icon(Icons.bookmark_border),
                onPressed: () {},
              )
            ],
          ),
          SliverList(
            delegate: SliverChildListDelegate.fixed([
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  post.title,
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
                  data: post.content,
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
