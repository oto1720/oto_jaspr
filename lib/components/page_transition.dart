import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

/// ページ表示時のフェードイン。framer-motion の `PageTransition` 相当。
/// マウント時に `fadeInUp` を一度再生する。
class PageTransition extends StatelessComponent {
  const PageTransition(this.children, {super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return div(classes: 'page-fade', children);
  }

  @css
  static List<StyleRule> get styles => [
        css('.page-fade').styles(raw: {
          'animation': 'fadeInUp 0.6s ease both',
        }),
      ];
}
