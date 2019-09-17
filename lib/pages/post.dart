import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:html/dom.dart' as dom;

class PostPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
                      image: AssetImage('assets/images/test_image.jpg'),
                      height: 300.0,
                      fit: BoxFit.cover,
                      placeholder: AssetImage('assets/images/test_image.jpg'),
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
                tag: 'test',
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
                  'DFI to screen 6 award-winning musical films at MIA',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Text(
                  '01/01/2019 at 4:00 PM',
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
                  data:
                      '<p>Doha: Al Duhail and Al Rayyan played out an exciting 1-1 draw in round 3 of the QNB Stars League (QSL) at the Al Janoub Stadium yesterday.</p>\n<p>Ahmed Yasser took Al Duhail ahead in the 66th minute, a lead neutralised by new recruit Franck Kom for Al Rayyan in the 75th minute.</p>\n<p>Al Duhail took their points tally to five and Al Rayyan three. Both teams thus maintained their unbeaten record.</p>\n<p>Al Duhail had beaten Qatar SC 2-1 and drawn 1-1 with Al Arabi, while Al Rayyan had drawn 2-2 with Umm Salal and goalless with Al Gharafa.</p>\n<p>Al Duhail were dominant in first-half play with 65 per cent possession (67 per cent in favour of Al Duhail at final whistle), but they could not convert the opportunities.</p>\n<p>Al Duhail’s Paulo Edmilson, Ali Afif and Almoez Ali all made attempts at the rival goal. At the other end, Al Rayyan’s Abdelaziz Hazaa skied his shot over the bar.</p>\n<p>Al Duhail kept attacking and Ahmed Yasser provided them with the winner in the 66th minute when he headed in a free-kick by Ali Afif into the top right corner of the net, leaving goalkeeper Fahd Younis rooted at the goal.</p>\n<p>Not long after, Al Rayyan equalised, Cameroonian Kom banging home a rebound from distance off goalkeeper Amine Lecomte after he punched away a shot from Abdelaziz Hatem, who joined Al Rayyan from Al Gharafa this season.</p>\n<p>At the end of the third round, Al Arabi are at the top of the standings with two wins and one draw.</p>\n<p>Defending champions Al Sadd who are occupying the third spot, will meet Al Sailiya in their third round fixture on September 24. The match was postponed due to the latter’s AFC Champions League second-leg quarter-final against Saudi Arabia’s Al Nassr which takes place in Doha today.</p>',
                ),
              ),
            ]),
          )
        ],
      ),
    );
  }
}
