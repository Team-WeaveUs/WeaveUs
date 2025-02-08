import 'package:flutter/cupertino.dart';

class HeavySwipePhysics extends ScrollPhysics {
  const HeavySwipePhysics({ScrollPhysics? parent}) : super(parent: parent);

  @override
  HeavySwipePhysics applyTo(ScrollPhysics? ancestor) {
    return HeavySwipePhysics(parent: buildParent(ancestor));
  }

  @override
  double get minFlingVelocity => 1000.0; // 너무 약한 스와이프 방지

  @override
  double carriedMomentum(double existingVelocity) {
    return existingVelocity.sign * 0.1; // 추가적인 이동 제한
  }
}