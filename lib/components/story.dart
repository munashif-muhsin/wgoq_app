import 'package:flutter/material.dart';
import 'package:wgoq_app/modals/post.dart';

class StoryWidget extends StatelessWidget {

  Post post;

  StoryWidget(this.post);


  @override
  Widget build(BuildContext context) {

    String dateString = '';
    dateString += post.date.day.toString();
    dateString += '/' + post.date.month.toString();
    dateString += '/' + post.date.year.toString();
    dateString += ' ' + post.date.hour.toString();
    dateString += ':' + post.date.minute.toString();


    return  Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        height: 100,
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Hero(
                tag: post.thumbnail,
                child: FadeInImage(
                  image: NetworkImage(post.thumbnail),
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  fit: BoxFit.cover,
                  height: 80,
                  width: 80,
                ),
              ),
            ),
            SizedBox(width: 10),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  constraints: BoxConstraints(maxHeight: 50),
                  width: MediaQuery.of(context).size.width * 0.6,
                  child: Text(
                    post.title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                        fontSize: 15),
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
      );
  }
}