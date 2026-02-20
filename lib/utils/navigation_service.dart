import 'package:flutter/material.dart';

/// Holds GlobalKeys for each section so any widget can scroll to them.
class NavigationService {
  NavigationService._();

  static NavigationService? _instance;

  static NavigationService get instance {
    _instance ??= NavigationService._();
    return _instance!;
  }

  final GlobalKey aboutKey = GlobalKey();
  final GlobalKey projectsKey = GlobalKey();
  final GlobalKey contactKey = GlobalKey();

  /// Smoothly scrolls the given [ScrollController] to the widget identified
  /// by [key].
  void scrollTo(GlobalKey key, ScrollController controller) {
    final context = key.currentContext;
    if (context == null) return;

    final box = context.findRenderObject() as RenderBox?;
    if (box == null) return;

    // Walk up to find the scroll-view's render object so we can compute the
    // offset relative to the scroll viewport.
    final scrollable = Scrollable.of(context);
    final scrollBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;

    final offset =
        box.localToGlobal(Offset.zero, ancestor: scrollBox).dy +
        controller.offset -
        80; // 80 px for the nav-bar height

    controller.animateTo(
      offset.clamp(0.0, controller.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }
}
