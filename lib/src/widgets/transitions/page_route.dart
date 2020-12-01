import 'package:design_app/src/widgets/transitions/clipper.dart';
import 'package:flutter/material.dart';

class ConcentricPageRoute<T> extends PageRoute<T> {
  ConcentricPageRoute({
    @required this.builder,
    RouteSettings settings,
    this.maintainState = true,
    bool fullscreenDialog = false,
  })  : assert(builder != null),
        assert(maintainState != null),
        assert(fullscreenDialog != null),
        super(settings: settings, fullscreenDialog: fullscreenDialog);

  /// Builds the primary contents of the route.
  final WidgetBuilder builder;

  @override
  final bool maintainState;

  @override
  Duration get transitionDuration => const Duration(milliseconds: 1000);

  @override
  bool get opaque => false;

  @override
  Color get barrierColor => Color(0xffEE6B42);

  @override
  String get barrierLabel => null;

/*  @override
  bool canTransitionFrom(TransitionRoute<dynamic> previousRoute) {
    return previousRoute is ConcentricPageRoute;
  }

  @override
  bool canTransitionTo(TransitionRoute<dynamic> nextRoute) {
    // Don't perform outgoing animation if the next route is a fullscreen dialog.
    return (nextRoute is ConcentricPageRoute && !nextRoute.fullscreenDialog);
  }
  */

  @override
  Widget buildPage(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
  ) {
    final Widget result = builder(context);
    assert(() {
      if (result == null) {
        throw FlutterError('The builder for route "${settings.name}" returned null.\n'
            'Route builders must never return null.');
      }
      return true;
    }());
    return Semantics(
      scopesRoute: true,
      explicitChildNodes: true,
      child: result,
    );
  }

  @override
  Widget buildTransitions(
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    //    final PageTransitionsTheme theme = Theme.of(context).pageTransitionsTheme;
    return _FadeInPageTransition(routeAnimation: animation, child: child);
  }

  @override
  String get debugLabel => '${super.debugLabel}(${settings.name})';
}

class _FadeInPageTransition extends StatelessWidget {
  _FadeInPageTransition({
    Key key,
    @required Animation<double> routeAnimation, // The route's linear 0.0 - 1.0 animation.
    @required this.child,
  })  : _opacityAnimation = routeAnimation.drive(_easeInTween),
        super(key: key);

//  // Fractional offset from 1/4 screen below the top to fully on screen.
//  static final Tween<Offset> _bottomUpTween = Tween<Offset>(
//    begin: const Offset(0.0, 0.25),
//    end: Offset.zero,
//  );
//  static final Animatable<double> _fastOutSlowInTween =
//      CurveTween(curve: Curves.fastOutSlowIn);
  static final Animatable<double> _easeInTween = CurveTween(curve: Curves.easeIn);

  final Animation<double> _opacityAnimation;
  final Widget child;

  @override
  Widget build(BuildContext context) {
//    return FadeTransition(
//      opacity: _opacityAnimation,
//      child: child,
//    );
    return Container(
      child: ClipPath(
        clipper: ConcentricClipper(progress: _opacityAnimation.value, radius: 0.0 - 1.0, verticalPosition: 0.82),
        child: child,
      ),
    );
  }
}
