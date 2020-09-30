library animated_indexed_stack;

import 'package:flutter/material.dart';
import 'package:animated_indexed_stack/stack_page.dart';

class AnimatedIndexedStack extends StatefulWidget {
  @required
  final int selectedIndex;
  final List<Widget> children;
  final List<RoutePageBuilder> pageBuilderList;
  final Duration duration;
  final RouteTransitionsBuilder transitionBuilder;
  final SORT_TIME sortTime;

  const AnimatedIndexedStack({
    Key key,
    this.pageBuilderList,
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
  List<dynamic> _list;
  int _selectedIndex;

  int _prevPage = 1;
  Map<Key, AnimationController> _animationControllerList =
      new Map<Key, AnimationController>();
  Map<Key, AnimationController> _secondaryAnimationControllerList =
      new Map<Key, AnimationController>();

  @override
  void initState() {
    final _duration = widget.duration ?? const Duration(milliseconds: 500);
    //Guards: Check if one of required property children or pageBuilder is not null and exactly one is given
    if (widget.children == null && widget.pageBuilderList == null) {
      throw Exception("Either children or pageBuilderList must be provided");
    }
    if (widget.children != null && widget.pageBuilderList != null) {
      throw Exception(
          "Only one property is allowed, either children or pageBuilderList");
    }
    if (widget.children != null) {
      _list = widget.children;
    } else {
      _list = widget.pageBuilderList;
    }
    _pages = _list.asMap().entries.map((entry) {
      final _index = entry.key;

      // Gerate Unique keys
      final _uniqueKey = UniqueKey();
      // Store initial index order
      _pageIndexToKeyMap[_index] = _uniqueKey;
      // print(_pageIndexToKeyMap);

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
      final _child = entry.value is RoutePageBuilder
          ? (entry.value as RoutePageBuilder)(
              context, animation, animationSecondary)
          : entry.value as Widget;

      return StackPage(
        key: _uniqueKey,
        child: _child,
        transitionsBuilder: widget.transitionBuilder,
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
    _selectedIndex = widget.selectedIndex ?? 0;

    /// Guards
    if (_list.length < 2) {
      throw Exception("Atleast 2 children must be provided.");
    }
    if (_selectedIndex >= _list.length || _selectedIndex < 0) {
      throw Exception(
          "Index out of bounds. Selected index must be between index of length of children i.e 0..${_list.length - 1}");
    }

    ///

    if (_prevPage != _selectedIndex) {
      final currKey = _pageIndexToKeyMap[_selectedIndex];
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

      // print(_prevPage);
      // print(_selectedIndex);

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
      // print(_selectedIndex);
      _prevPage = _selectedIndex;
    }
    return GestureDetector(
      child: Stack(
        children: _pages,
      ),
    );
  }
}

enum SORT_TIME {
  before,
  after,
}
