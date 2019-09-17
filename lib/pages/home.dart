import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
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
                image: AssetImage(
                  'assets/images/test_image.jpg',
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
                      'DFI to screen 6 award-winning musical films at MIA',
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
      itemCount: 2,
      itemBuilder: (BuildContext context, int index) {
        return _buildLatestPostItem(context, index);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
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
      ],
    );
  }
}
