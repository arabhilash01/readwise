import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class MarqueeWidget extends StatefulWidget {
  final Widget child;
  final Axis direction;
  final Duration animationDuration, pauseDuration;
  final ScrollPhysics physics;

  const MarqueeWidget({
    super.key,
    required this.child,
    this.direction = Axis.horizontal,
    this.animationDuration = const Duration(seconds: 4),
    this.pauseDuration = const Duration(milliseconds: 800),
    this.physics = const NeverScrollableScrollPhysics(),
  });

  @override
  State<MarqueeWidget> createState() => _MarqueeWidgetState();
}

class _MarqueeWidgetState extends State<MarqueeWidget> {
  late ScrollController scrollController;
  late Timer scrollAnimationTimer;

  @override
  void initState() {
    scrollController = ScrollController(initialScrollOffset: 0.0);
    WidgetsBinding.instance.addPostFrameCallback(scroll);
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    scrollAnimationTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: widget.physics,
      scrollDirection: widget.direction,
      controller: scrollController,
      child: widget.child,
    );
  }

  void scroll(_) async {
    try {
      scrollAnimationTimer = Timer.periodic(widget.pauseDuration + widget.animationDuration, (timer) async {
        if (scrollController.hasClients && scrollController.position.hasContentDimensions) {
          await scrollController.animateTo(
            timer.tick.isOdd ? scrollController.position.maxScrollExtent : 0.0,
            duration: widget.animationDuration,
            curve: Curves.ease,
          );
        }
      });
    } catch (e) {
      if (kDebugMode) {
        print('\x1B[31mMarqueeWidget error\x1B[0m');
      }
    }
  }
}
