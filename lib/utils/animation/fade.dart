import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum _AniProps { opacity, translateX, scale }

class FadeInUp extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInUp(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.0.tweenTo(1.0))..add(_AniProps.translateX, 250.0.tweenTo(0.0))..add(_AniProps.scale, 0.0.tweenTo(1.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(_AniProps.translateX)),
          child: Transform.scale(
            scale: value.get(_AniProps.scale),
            child: child,
          ),
        ),
      ),
    );
  }
}

class PopUp extends StatelessWidget {
  final double delay;
  final Widget child;

  PopUp(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.0.tweenTo(1.0))..add(_AniProps.scale, 0.0.tweenTo(1.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.scale(
          scale: value.get(_AniProps.scale),
          child: child,
        ),
      ),
    );
  }
}

class SlideUp extends StatelessWidget {
  final double delay;
  final Widget child;

  SlideUp(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.translateX, MediaQuery.of(context).size.height.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Transform.translate(
        offset: Offset(0, value.get(_AniProps.translateX)),
        child: child,
      ),
    );
  }
}

class SlideUpKomentar extends StatelessWidget {
  final double delay;
  final Widget child;

  SlideUpKomentar(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.translateX, MediaQuery.of(context).size.height.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 200.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Transform.translate(
        offset: Offset(0, value.get(_AniProps.translateX)),
        child: child,
      ),
    );
  }
}

class FadeInUpBack extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInUpBack(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 1.0.tweenTo(0.0))..add(_AniProps.translateX, 0.0.tweenTo(130.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(0, value.get(_AniProps.translateX)),
          child: child,
        ),
      ),
    );
  }
}

class FadeInLeft extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInLeft(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.0.tweenTo(1.0))..add(_AniProps.translateX, 130.0.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(value.get(_AniProps.translateX), 0),
          child: child,
        ),
      ),
    );
  }
}

class FadeInRight extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInRight(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 0.0.tweenTo(1.0))..add(_AniProps.translateX, 130.0.tweenTo(0.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(-value.get(_AniProps.translateX), 0),
          child: child,
        ),
      ),
    );
  }
}

class FadeInLeftBack extends StatelessWidget {
  final double delay;
  final Widget child;

  FadeInLeftBack(this.delay, this.child);

  @override
  Widget build(BuildContext context) {
    final tween = MultiTween<_AniProps>()..add(_AniProps.opacity, 1.0.tweenTo(0.0))..add(_AniProps.translateX, 0.0.tweenTo(-130.0));

    return PlayAnimation<MultiTweenValues<_AniProps>>(
      delay: (300 * delay).round().milliseconds,
      duration: 500.milliseconds,
      tween: tween,
      child: child,
      builder: (context, child, value) => Opacity(
        opacity: value.get(_AniProps.opacity),
        child: Transform.translate(
          offset: Offset(value.get(_AniProps.translateX), 0),
          child: child,
        ),
      ),
    );
  }
}
