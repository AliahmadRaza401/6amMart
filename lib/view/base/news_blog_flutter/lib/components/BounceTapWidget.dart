import 'package:flutter/material.dart';

class BounceTapWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;

  BounceTapWidget({required this.child, this.onTap}) : super();

  @override
  BounceTapWidgetState createState() => BounceTapWidgetState();
}

class BounceTapWidgetState extends State<BounceTapWidget> with SingleTickerProviderStateMixin {
  double? _scale;
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 50),
      lowerBound: 0.0,
      upperBound: 0.1,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    _animationController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_animationController != null) {
      _scale = 1 - _animationController!.value;
    }

    return Listener(
      onPointerDown: (details) {
        _animationController?.forward();
      },
      onPointerUp: (details) {
        _animationController?.reverse();
      },
      child: InkWell(
        onTap: widget.onTap,
        child: Transform.scale(
          scale: _scale!,
          child: widget.child,
        ),
      ),
    );
  }
}
