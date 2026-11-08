import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// スクロール発火フェードイン用のラッパー。
/// 中身を `.reveal` でラップするだけ。可視時に `.is-visible` を付与するのは
/// Navigation island の初期化で呼ぶ [initReveal]（IntersectionObserver）。
/// framer-motion の `whileInView` 相当。
class Reveal extends StatelessComponent {
  const Reveal(this.children, {this.delayMs = 0, this.tag = 'div', this.classes, super.key});

  final List<Component> children;
  final int delayMs;
  final String tag;
  final String? classes;

  @override
  Component build(BuildContext context) {
    return Component.element(
      tag: tag,
      classes: 'reveal${classes != null ? ' $classes' : ''}',
      styles: delayMs > 0
          ? Styles(raw: {'transition-delay': '${delayMs}ms'})
          : null,
      children: children,
    );
  }
}
