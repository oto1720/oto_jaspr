import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/layout.dart';

/// プロフィール。Skills / インターン / 受賞 / タイムライン（タグフィルタ・モーダル）。
/// フェーズ4で実装予定。
class ProfilePage extends StatelessComponent {
  const ProfilePage({super.key});

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container page-head', [
        h1(classes: 'page-title', [Component.text('Profile')]),
        p(classes: 'page-note', [Component.text('Skills・インターン・受賞歴・経歴（準備中：フェーズ4）')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => pageHeadStyles;
}

/// 各スケルトンページ共通の見出しスタイル。
final List<StyleRule> pageHeadStyles = [
  css('.page-head').styles(raw: {'padding': '8rem 1rem 4rem'}),
  css('.page-title').styles(
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.bold,
    raw: {'font-size': 'clamp(2.2rem,6vw,3.2rem)', 'letter-spacing': '-0.02em', 'margin': '0'},
  ),
  css('.page-note').styles(
      color: Color('var(--color-text-muted)'), raw: {'margin-top': '0.75rem'}),
];
