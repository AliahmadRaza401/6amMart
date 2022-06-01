import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Model/CategoryModel.dart';
import 'package:news_flutter/Model/PostModel.dart';
import 'package:news_flutter/Network/rest_apis.dart';
import 'package:news_flutter/Utils/Colors.dart';
import 'package:news_flutter/Utils/Common.dart';
import 'package:news_flutter/Utils/appWidgets.dart';
import 'package:news_flutter/components/LoadingDotWidget.dart';
import 'package:news_flutter/components/NewsItemWidget.dart';
import 'package:news_flutter/components/NoDataWidget.dart';

import '../main.dart';

class NewsListScreen extends StatefulWidget {
  static String tag = '/NewsListScreen';

  final String? title;
  final int? id;
  final List? recentPost;
  final CategoryModel? categoryModel;

  NewsListScreen({this.id, this.title, this.recentPost, this.categoryModel});

  @override
  NewsListScreenState createState() => NewsListScreenState();
}

class NewsListScreenState extends State<NewsListScreen> with SingleTickerProviderStateMixin {
  ScrollController scrollController = ScrollController();
  late AnimationController _controller;
  late Animation _iconTweenColor;

  List<PostModel> categoriesWiseNewListing = [];
  List<CategoryModel> mSubCategory = [];
  List<String> subCategories = [];

  int page = 1;
  int numPages = 0;
  int selectedIndex = 0;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 0));
    _iconTweenColor = ColorTween(begin: Colors.white, end: appStore.isDarkMode ? Colors.white : Colors.black).animate(_controller);

    setStatusBarColor(Colors.transparent, statusBarIconBrightness: Brightness.light);

    super.initState();
    afterBuildCreated(() => init());

    scrollController.addListener(() {
      if ((scrollController.position.pixels - 100) == (scrollController.position.maxScrollExtent - 100)) {
        if (numPages > page) {
          page++;
          appStore.setLoading(true);
          fetchCategoriesWiseNewsData(widget.id);
        }
      }
    });
  }

  Future<void> init() async {
    fetchCategoriesWiseNewsData(widget.id);
    fetchSubCategoriesData();
  }

  void fetchSubCategoriesData() {
    getCategories(parent: widget.id.validate()).then((res) {
      if (!mounted) return;
      mSubCategory = res;

      if (mSubCategory.length > 0) {
        subCategories.clear();
        subCategories.add('All');

        mSubCategory.forEach((element) {
          subCategories.add(element.name.toString());
        });

        setState(() {});
      }
    }).catchError((error) {
      if (!mounted) return;
      toast(error.toString());
    });
  }

  void fetchCategoriesWiseNewsData(int? id, {int? subCatId}) {
    appStore.setLoading(true);

    Map req = {
      'category': id,
      'filter': 'by_category',
      'paged': page,
    };

    if (subCatId != null) {
      req.putIfAbsent('subcategory', () => subCatId);
    }

    getBlogList(req).then((res) {
      if (!mounted) return;
      appStore.setLoading(false);

      numPages = res.num_pages!.toInt();

      categoriesWiseNewListing.addAll(res.posts!);
      setState(() {});
    }).catchError((error) {
      if (!mounted) return;
      appStore.setLoading(false);
      toast(error.toString());
    });
  }

  @override
  void dispose() {
    scrollController.dispose();
    setStatusBarColor(
      appStore.isDarkMode ? scaffoldBackgroundDarkColor : Colors.white,
      statusBarBrightness: appStore.isDarkMode ? Brightness.light : Brightness.dark,
    );
    super.dispose();
  }

  bool _scrollListener(ScrollNotification scrollInfo) {
    if (scrollInfo.metrics.axis == Axis.vertical) {
      _controller.animateTo(scrollInfo.metrics.pixels / 200);

      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: NotificationListener(
        onNotification: _scrollListener,
        child: CustomScrollView(
          controller: scrollController,
          slivers: <Widget>[
            AnimatedBuilder(
              animation: _controller,
              builder: (_, child) {
                return SliverAppBar(
                  pinned: true,
                  onStretchTrigger: () async {},
                  systemOverlayStyle: SystemUiOverlayStyle(statusBarColor: Colors.transparent),
                  leading: IconButton(
                    icon: Icon(Icons.arrow_back_ios, size: 20),
                    onPressed: () => finish(context),
                    color: _iconTweenColor.value,
                  ),
                  expandedHeight: 200.0,
                  backgroundColor: context.cardColor,
                  flexibleSpace: FlexibleSpaceBar(
                    collapseMode: CollapseMode.parallax,
                    title: Text(parseHtmlString(widget.categoryModel!.name.validate()), style: boldTextStyle(color: _iconTweenColor.value)),
                    background: DecoratedBox(
                      position: DecorationPosition.foreground,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0.0, 1.0],
                          colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                        ),
                      ),
                      child: Hero(
                        tag: widget.categoryModel!,
                        child: cachedImage(widget.categoryModel!.image.validate(), width: context.width(), height: 200, fit: BoxFit.cover),
                      ),
                    ),
                  ),
                );
              },
            ),
            SliverToBoxAdapter(
              child: HorizontalList(
                itemCount: subCategories.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      setState(() {
                        selectedIndex = index;
                        page = 1;
                        if (index == 0) {
                          categoriesWiseNewListing.clear();
                          fetchCategoriesWiseNewsData(widget.id);
                        } else {
                          categoriesWiseNewListing.clear();
                          fetchCategoriesWiseNewsData(widget.id, subCatId: mSubCategory[index - 1].cat_ID);
                        }
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 12),
                      margin: EdgeInsets.only(right: 8),
                      decoration: BoxDecoration(
                        color: selectedIndex == index ? primaryColor : null,
                        borderRadius: BorderRadius.all(Radius.circular(30)),
                        border: Border.all(color: context.dividerColor, width: 0.5),
                      ),
                      clipBehavior: Clip.antiAliasWithSaveLayer,
                      child: Text(
                        parseHtmlString(subCategories[index]),
                        style: boldTextStyle(color: selectedIndex == index ? Colors.white : Theme.of(context).textTheme.headline6!.color),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ).visible(subCategories.isNotEmpty),
            ),
            if (categoriesWiseNewListing.isEmpty)
              SliverFillRemaining(child: Observer(builder: (context) {
                return appStore.isLoading ? LoadingDotsWidget() : NoDataWidget();
              }))
            else
              SliverPadding(
                padding: EdgeInsets.all(8),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, i) {
                      PostModel post = categoriesWiseNewListing[i];

                      return NewsItemWidget(post, data: categoriesWiseNewListing, index: i);
                    },
                    childCount: categoriesWiseNewListing.length,
                    addAutomaticKeepAlives: true,
                    addRepaintBoundaries: false,
                  ),
                ),
              ),
            SliverFillRemaining(
              fillOverscroll: false,
              hasScrollBody: false,
              child: Observer(
                builder: (_) => LoadingDotsWidget().paddingSymmetric(vertical: 16).visible(appStore.isLoading),
              ),
            )
          ],
        ),
      ),
    );
  }
}
