import 'dart:async';
import 'dart:html';

Future<Null> awaitAnimationFrame() async {
  await window.animationFrame;
}

Future<Null> awaitIdleCallback() async {
  // TODO: actually use window.requestIdleCallback() when available
  await window.animationFrame;
  await new Future.delayed(const Duration(milliseconds: 5));
}
