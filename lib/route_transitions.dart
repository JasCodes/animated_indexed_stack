import 'package:flutter/material.dart';

final RouteTransitionsBuilder materialTabTransition = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  Widget appear = FadeTransition(
    opacity: animation.drive(
      Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
    ),
    child: ScaleTransition(
      scale: animation.drive(
        Tween<double>(
          begin: 0.8,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
      ),
      child: child,
    ), // child is the value returned by pageBuilder
  );

  Widget disappear = FadeTransition(
    opacity: secondaryAnimation.drive(
      Tween<double>(
        begin: 1.0,
        end: 0.0,
      ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
    ),
    child: ScaleTransition(
      scale: secondaryAnimation.drive(
        Tween<double>(
          begin: 1.0,
          end: 1.4,
        ).chain(CurveTween(curve: Curves.fastOutSlowIn)),
      ),
      child: appear,
    ), // child is the value returned by pageBuilder
  );
  return disappear;
};

final RouteTransitionsBuilder fadeTransition = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  Widget appear = FadeTransition(
    opacity: Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(animation),
    child: child, // child is the value returned by pageBuilder
  );

  Widget disappear = FadeTransition(
    opacity: Tween<double>(
      begin: 1.0,
      end: 0.0,
    ).animate(secondaryAnimation),
    child: appear,
  );
  return disappear;
};

final RouteTransitionsBuilder slideTransition = (
  BuildContext context,
  Animation<double> animation,
  Animation<double> secondaryAnimation,
  Widget child,
) {
  Widget appear = SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(-1.0, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(animation),
    child: child, // child is the value returned by pageBuilder
  );

  Widget disappear = SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 0.0),
      end: const Offset(1.0, 0.0),
    ).animate(secondaryAnimation),
    child: appear,
  );
  return disappear;
};
