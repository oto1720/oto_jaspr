import 'dart:js_interop';

import 'package:web/web.dart' as web;

/// クライアント(ブラウザ)用の DOM 実装。

bool themeIsDark() =>
    web.document.documentElement?.classList.contains('dark') ?? true;

void themeSetDark(bool dark) {
  final el = web.document.documentElement;
  if (el == null) return;
  if (dark) {
    el.classList.add('dark');
  } else {
    el.classList.remove('dark');
  }
  web.window.localStorage.setItem('theme', dark ? 'dark' : 'light');
}

void initNavScroll(void Function(bool scrolled) onChange, {double threshold = 10}) {
  var last = false;
  void handler(web.Event _) {
    final scrolled = web.window.scrollY > threshold;
    if (scrolled != last) {
      last = scrolled;
      onChange(scrolled);
    }
  }

  web.window.addEventListener('scroll', handler.toJS);
  handler(web.Event('scroll'));
}

void initReveal() {
  final els = web.document.querySelectorAll('.reveal');
  if (els.length == 0) return;

  void callback(JSArray<web.IntersectionObserverEntry> entries,
      web.IntersectionObserver observer) {
    final list = entries.toDart;
    for (final entry in list) {
      if (entry.isIntersecting) {
        entry.target.classList.add('is-visible');
        observer.unobserve(entry.target);
      }
    }
  }

  final observer = web.IntersectionObserver(
    callback.toJS,
    web.IntersectionObserverInit(
      rootMargin: '0px 0px -80px 0px',
      threshold: 0.1.toJS,
    ),
  );

  for (var i = 0; i < els.length; i++) {
    final node = els.item(i);
    if (node != null) observer.observe(node as web.Element);
  }
}

void setBodyScrollLocked(bool locked) {
  web.document.body?.style.overflow = locked ? 'hidden' : '';
}

/// `Escape` キー押下で [handler] を呼ぶ。戻り値を呼ぶとリスナーを解除する。
/// モーダルの `initState` で登録し `dispose` で解除する想定。
void Function() onEscapeKey(void Function() handler) {
  void listener(web.Event e) {
    if ((e as web.KeyboardEvent).key == 'Escape') handler();
  }

  final jsListener = listener.toJS;
  web.document.addEventListener('keydown', jsListener);
  return () => web.document.removeEventListener('keydown', jsListener);
}
