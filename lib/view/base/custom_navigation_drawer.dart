import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sixam_mart/controller/splash_controller.dart';
import 'package:sixam_mart/helper/responsive_helper.dart';
import 'package:sixam_mart/util/dimensions.dart';
import 'package:sixam_mart/view/base/custom_image.dart';

class CustomNavigationDrawer extends StatefulWidget {
  final Color selectedColor;
  final Color backgroundColor;
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final Widget child;
  CustomNavigationDrawer({
    this.selectedColor = const Color(0xFF4AC8EA), this.backgroundColor,
    @required this.child,
    this.defaultTextStyle = const TextStyle(color: Colors.white70, fontSize: 14, fontWeight: FontWeight.w600),
    this.selectedTextStyle = const TextStyle(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w600),
  });

  @override
  CustomNavigationDrawerState createState() {
    return new CustomNavigationDrawerState(
      selectedColor: selectedColor, backgroundColor: backgroundColor,
      defaultTextStyle: defaultTextStyle, selectedTextStyle: selectedTextStyle, child: child,
    );
  }
}

class CustomNavigationDrawerState extends State<CustomNavigationDrawer>
    with SingleTickerProviderStateMixin {
  final Color selectedColor;
  final Color backgroundColor;
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final Widget child;
  CustomNavigationDrawerState({
    @required this.selectedColor, @required this.backgroundColor,
    @required this.selectedTextStyle, @required this.defaultTextStyle, @required this.child,
  });

  double maxWidth = 200;
  double minWidth = 45;
  bool isCollapsed = true;
  AnimationController _animationController;
  Animation<double> widthAnimation;
  int currentSelectedIndex = -1;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 300));
    _animationController.forward();
    widthAnimation = Tween<double>(begin: maxWidth, end: minWidth)
        .animate(_animationController);
    if(Get.find<SplashController>().moduleList == null && !mounted ? ResponsiveHelper.isDesktop(context) : true) {
      Get.find<SplashController>().getModules();
    }
  }

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(builder: (splashController) {
      return Stack(children: [
        child,
        splashController.moduleList != null ? Positioned(
          top: 100, right: 0,
          child: AnimatedBuilder(
            animation: _animationController,
            builder: (context, widget) => getWidget(context, widget, backgroundColor, splashController),
          ),
        ) : SizedBox(),
      ]);
    });
  }

  Widget getWidget(context, widget, Color backgroundColor, SplashController splashController) {
    return MouseRegion(
      onEnter: (event) {
        setState(() {
          isCollapsed = false;
          _animationController.reverse();
        });
      },
      onExit: (event) {
        setState(() {
          isCollapsed = true;
          _animationController.forward();
        });
      },
      child: Material(
        elevation: 80.0,
        color: Colors.transparent,
        child: Container(
          width: widthAnimation.value,
          decoration: BoxDecoration(
            color: backgroundColor == null ? Theme.of(context).primaryColor : backgroundColor,
            borderRadius: BorderRadius.horizontal(left: Radius.circular(Dimensions.RADIUS_DEFAULT)),
          ),
          padding: EdgeInsets.symmetric(vertical: Dimensions.PADDING_SIZE_SMALL),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListView.separated(
                separatorBuilder: (context, counter) {
                  return Divider(height: 12.0);
                },
                shrinkWrap: true, physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, counter) {
                  return CollapsingListTile(
                    onTap: () {},
                    isSelected: currentSelectedIndex == counter,
                    title: splashController.moduleList[counter].moduleName,
                    icon: splashController.moduleList[counter].icon,
                    animationController: _animationController,
                    selectedColor: selectedColor,
                    defaultTextStyle: defaultTextStyle,
                    selectedTextStyle: selectedTextStyle,
                  );
                },
                itemCount: splashController.moduleList.length,
              ),
              // InkWell(
              //   onTap: () {
              //     setState(() {
              //       isCollapsed = !isCollapsed;
              //       isCollapsed
              //           ? _animationController.forward()
              //           : _animationController.reverse();
              //     });
              //   },
              //   child: AnimatedIcon(
              //     icon: AnimatedIcons.close_menu,
              //     progress: _animationController,
              //     color: selectedColor,
              //     size: 25,
              //   ),
              // ),
              // SizedBox(
              //   height: 20,
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

class CollapsingListTile extends StatefulWidget {
  final String title;
  final String icon;
  final Color selectedColor;
  final TextStyle defaultTextStyle;
  final TextStyle selectedTextStyle;
  final AnimationController animationController;
  final bool isSelected;
  final Function onTap;

  CollapsingListTile(
      {@required this.title,
        @required this.icon,
        @required this.selectedColor,
        @required this.animationController,
        @required this.defaultTextStyle,
        @required this.selectedTextStyle,
        this.isSelected = false,
        this.onTap});

  @override
  _CollapsingListTileState createState() => _CollapsingListTileState();
}

class _CollapsingListTileState extends State<CollapsingListTile> {
  Animation<double> widthAnimation, sizedBoxAnimation;

  @override
  void initState() {
    super.initState();
    widthAnimation =
        Tween<double>(begin: 200, end: 70).animate(widget.animationController);
    sizedBoxAnimation =
        Tween<double>(begin: 10, end: 0).animate(widget.animationController);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: widget.isSelected
              ? Colors.transparent.withOpacity(0.3)
              : Colors.transparent,
        ),
        width: widthAnimation.value,
        margin: EdgeInsets.symmetric(horizontal: Dimensions.PADDING_SIZE_EXTRA_SMALL),
        padding: EdgeInsets.all(Dimensions.PADDING_SIZE_EXTRA_SMALL),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.RADIUS_SMALL),
              child: CustomImage(
                image: '${Get.find<SplashController>().configModel.baseUrls.moduleImageUrl}/${widget.icon}',
                // color: widget.isSelected ? widget.selectedColor : Colors.white30,
                width: 25, height: 25,
              ),
            ),
            SizedBox(width: sizedBoxAnimation.value),
            (widthAnimation.value >= 190)
                ? Text(widget.title,
                style: widget.isSelected ? widget.selectedTextStyle : widget.defaultTextStyle)
                : Container()
          ],
        ),
      ),
    );
  }
}

class NavigationModel {
  String title;
  IconData icon;
  Function onTap;

  NavigationModel({this.title, this.icon, this.onTap});
}