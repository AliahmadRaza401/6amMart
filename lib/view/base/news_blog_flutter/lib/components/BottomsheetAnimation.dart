import 'package:flutter/material.dart';

class BottomSheetAnimation extends StatefulWidget {
  final Widget? child;
  final Offset? beginOffset;
  final Offset? endOffset;
  final Duration startDuration;
  final Duration endDuration;

  BottomSheetAnimation({
    required this.child,
    required this.beginOffset,
    required this.endOffset,
    this.startDuration = const Duration(milliseconds: 800),
    this.endDuration = const Duration(milliseconds: 500),
  });

  @override
  BottomSheetAnimationState createState() => BottomSheetAnimationState();
}

class BottomSheetAnimationState extends State<BottomSheetAnimation> with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _animationController = AnimationController(
      duration: widget.startDuration,
      reverseDuration: widget.endDuration,
      vsync: this,
    );
    _animation = Tween<Offset>(begin: widget.beginOffset, end: widget.endOffset).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOutBack,
      ),
    );
    _animationController.forward();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black54,
      body: SlideTransition(
        position: _animation,
        child: widget.child,
      ),
    );
  }
}
