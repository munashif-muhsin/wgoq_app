import 'package:flutter/material.dart';
import 'package:wgoq_app/pages/bookmarks.dart';
import 'package:wgoq_app/pages/categories.dart';
import 'package:wgoq_app/pages/home.dart';
import 'package:wgoq_app/pages/search.dart';

class TabsPage extends StatefulWidget {
  @override
  _TabsPageState createState() => _TabsPageState();
}

class _TabsPageState extends State<TabsPage>
    with SingleTickerProviderStateMixin{
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  void switchTabs(int index) {
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: TabBarView(
        physics: NeverScrollableScrollPhysics(),
        controller: _tabController,
        children: <Widget>[HomePage(switchTabs), CategoriesPage(), BookmarksPage(), SearchPage()],
      ),
      bottomNavigationBar: SafeArea(
        child: SafeArea(
          child: TabBar(
            labelColor: Colors.black,
            unselectedLabelColor: Colors.black38,
            indicatorColor: Colors.black,
            indicator: UnderlineTabIndicator(
              borderSide: BorderSide(color: Colors.black, width: 1.0),
              insets: EdgeInsets.fromLTRB(25.0, 0.0, 25.0, 50.0),
            ),
            controller: _tabController,
            tabs: <Widget>[
              Tab(
                icon: Icon(
                  Icons.home,
                  size: 22,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.category,
                  size: 22,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.bookmark,
                  size: 22,
                ),
              ),
              Tab(
                icon: Icon(
                  Icons.search,
                  size: 22,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
