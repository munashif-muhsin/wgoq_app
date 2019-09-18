import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:wgoq_app/modals/post.dart';
import 'package:wgoq_app/services/categories.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> with AutomaticKeepAliveClientMixin {
  CategoryService _categoryService = CategoryService();
  int currentPage = 1;
  bool isNewPageLoading = false;
  List<Map> categories = [];
  bool isLoaded;
  ScrollController _scrollController;
  final _scrollThreshold = 200.0;

  Widget _buildListItem(BuildContext context, int index, Post item) {
    return Container(
      width: 200,
      margin: EdgeInsets.only(right: 10, left: 20),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: Stack(
          overflow: Overflow.clip,
          children: <Widget>[
            Positioned(
              child: Hero(
                tag: item.thumbnail,
                child: FadeInImage(
                  width: 200,
                  alignment: Alignment.center,
                  fit: BoxFit.cover,
                  placeholder: AssetImage('assets/images/placeholder.png'),
                  image: NetworkImage(item.thumbnail),
                ),
              ),
            ),
            Positioned(
              child: Container(
                width: 200,
                padding: EdgeInsets.all(10),
                color: Colors.black45,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    ConstrainedBox(
                      constraints: BoxConstraints(maxHeight: 55),
                      child: Text(
                        item.title,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
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

  Widget _buildCategoryView(BuildContext context, int index) {
    return index != categories.length
        ? (categories[index]['posts'].length > 0
            ? Container(
                margin: EdgeInsets.symmetric(vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        categories[index]['category'].name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      margin: EdgeInsets.only(top: 10),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: categories[index]['posts'].length > 5 ? 5 : categories[index]['posts'].length,
                        itemBuilder: (BuildContext context, int postIndex) {
                          return _buildListItem(context, index,
                              categories[index]['posts'][postIndex]);
                        },
                        scrollDirection: Axis.horizontal,
                      ),
                    )
                  ],
                ),
              )
            : Container())
        : isNewPageLoading
            ? Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(vertical: 15),
                child: SpinKitWave(
                  color: Colors.black87,
                  size: 20,
                ),
              )
            : Container();
  }

  void _onScroll() {
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    if (maxScroll - currentScroll <= _scrollThreshold) {
      loadNextPage();
    }
  }

  loadNextPage() async {
    if (isNewPageLoading) {
      return;
    }
    setState(() {
      isNewPageLoading = true;
    });
    print('loading new page');
    List<Map> newCategories =
        await _categoryService.getCategoryPageContent(currentPage + 1);
    currentPage++;
    setState(() {
      categories.addAll(newCategories);
      isNewPageLoading = false;
    });
  }

  _loadData() async {
    categories = await _categoryService.getCategoryPageContent();
    isLoaded = true;
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
      body: !isLoaded
          ? Center(
              child: SpinKitChasingDots(
                color: Colors.black87,
                size: 50,
              ),
            )
          : ListView.builder(
              controller: _scrollController,
              itemCount: categories.length + 1,
              itemBuilder: (BuildContext context, int index) {
                return _buildCategoryView(context, index);
              },
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
