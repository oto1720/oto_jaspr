import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import 'page_transition.dart';

/// 各ページ共通のラッパー。`<main>` + ページ遷移フェードを提供する。
/// ナビゲーションは [App] 側で全ページ共通に描画している。
class Layout extends StatelessComponent {
  const Layout(this.children, {super.key});

  final List<Component> children;

  @override
  Component build(BuildContext context) {
    return PageTransition([
      main_(classes: 'page', children),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.page').styles(
          width: 100.percent,
          minHeight: 100.vh,
          backgroundColor: Color('var(--color-bg)'),
          color: Color('var(--color-text)'),
        ),
      ];
}
