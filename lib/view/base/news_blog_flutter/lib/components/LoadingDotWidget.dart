import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:news_flutter/Utils/Colors.dart';

class LoadingDotsWidget extends StatefulWidget {
  @override
  _LoadingDotsWidgetState createState() => _LoadingDotsWidgetState();
}

class _LoadingDotsWidgetState extends State<LoadingDotsWidget> with TickerProviderStateMixin {
  late List<AnimationController> _animationControllers;
  List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    _initAnimation();
  }

  void _initAnimation() {
    _animationControllers = List.generate(3, (index) {
      return AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    }).toList();

    for (int i = 0; i < 3; i++) {
      _animations.add(Tween<double>(begin: 0, end: -8).animate(_animationControllers[i]));
    }

    for (int i = 0; i < 3; i++) {
      _animationControllers[i].addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _animationControllers[i].reverse();
          if (i != 3 - 1) {
            _animationControllers[i + 1].forward();
          }
        }
        if (i == 3 - 1 && status == AnimationStatus.dismissed) {
          _animationControllers[0].forward();
        }
      });
    }

    _animationControllers.first.forward();
  }

  @override
  void dispose() {
    for (var controller in _animationControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedBuilder(
          animation: _animationControllers[index],
          builder: (context, child) {
            return Transform.translate(
              offset: Offset(0, _animations[index].value),
              child: Container(
                decoration: BoxDecoration(shape: BoxShape.circle, color: primaryColor),
                height: 10,
                width: 10,
              ),
            ).paddingSymmetric(horizontal: 4);
          },
        );
      }).toList(),
    );
  }
}
