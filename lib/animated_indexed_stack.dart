library animated_indexed_stack;

import 'package:flutter/material.dart';
import 'package:animated_indexed_stack/stack_page.dart';

class AnimatedIndexedStack extends StatefulWidget {
  @required
  final List<Widget> children;
  @required
  final int selectedIndex;
  final Duration duration;
  final RouteTransitionsBuilder transitionBuilder;
  final SORT_TIME sortTime;

  const AnimatedIndexedStack({
    Key key,
    this.children,
    this.selectedIndex,
    this.transitionBuilder,
    this.sortTime,
    this.duration,
  }) : super(key: key);

  @override
  _AnimatedIndexedStackState createState() => _AnimatedIndexedStackState();
}

class _AnimatedIndexedStackState extends State<AnimatedIndexedStack>
    with TickerProviderStateMixin {
  Map<int, Key> _pageIndexToKeyMap = new Map<int, Key>();
  List<Widget> _pages;
  int _prevPage = 1;
  Map<Key, AnimationController> _animationControllerList =
      new Map<Key, AnimationController>();
  Map<Key, AnimationController> _secondaryAnimationControllerList =
      new Map<Key, AnimationController>();

  @override
  void initState() {
    final _duration = widget.duration ?? const Duration(milliseconds: 500);
    _pages = widget.children.asMap().entries.map((entry) {
      final _index = entry.key;
      final _child = entry.value;

      // Gerate Unique keys
      final _uniqueKey = UniqueKey();
      // Store initial index order
      _pageIndexToKeyMap[_index] = _uniqueKey;
      print(_pageIndexToKeyMap);

      AnimationController animation = new AnimationController(
        vsync: this,
        duration: _duration,
      );
      AnimationController animationSecondary = new AnimationController(
        vsync: this,
        duration: _duration,
      );

      _animationControllerList[_uniqueKey] = animation;
      _secondaryAnimationControllerList[_uniqueKey] = animationSecondary;

      return StackPage(
        key: _uniqueKey,
        child: _child,
        animation: animation,
        animationSecondary: animationSecondary,
      );
    }).toList();

    // for (int i = 0; i < _pages.length; i++) {
    //   _pagesKeyMap[i] = _pages[i].key;
    // }
    super.initState();
  }

  @override
  void dispose() {
    _animationControllerList.forEach((_, controller) {
      controller.dispose();
    });
    _secondaryAnimationControllerList.forEach((_, controller) {
      controller.dispose();
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: Add selected Index guard.
    if (_prevPage != widget.selectedIndex) {
      final currKey = _pageIndexToKeyMap[widget.selectedIndex];
      final prevKey = _pageIndexToKeyMap[_prevPage];
      Function s = (a, b) {
        if (a.key == currKey) return 2;
        if (b.key == currKey) return -2;
        if (a.key == prevKey) return 1;
        if (b.key == prevKey) return -1;
        return 0;
      };
      final _sortTime = widget.sortTime ?? SORT_TIME.after;

      if (_sortTime == SORT_TIME.before) _pages.sort(s);

      print(_prevPage);
      print(widget.selectedIndex);

      _secondaryAnimationControllerList[currKey].reset();
      if (!_animationControllerList[currKey].isAnimating)
        _animationControllerList[currKey].reset();

      _secondaryAnimationControllerList[prevKey].forward().orCancel;
      _animationControllerList[currKey].forward().orCancel.whenComplete(() {
        if (_sortTime == SORT_TIME.after)
          setState(() {
            _pages.sort(s);
          });
      });
      // print(_pages);
      // print(_map);
      // print(widget.selectedIndex);
      _prevPage = widget.selectedIndex;
    }
    return Container(
      color: Colors.grey,
      child: GestureDetector(
        child: Stack(
          children: _pages,
        ),
      ),
    );
  }
}

enum SORT_TIME {
  before,
  after,
}
