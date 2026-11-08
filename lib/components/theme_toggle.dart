import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../browser/browser.dart';
import 'icons.dart';

/// ダーク/ライト切り替えボタン（island）。
/// `<html>` の `dark` クラスを付け外しし、localStorage に保存する。
/// 初期適用は head の先行スクリプトが FOUC を防ぐので、
/// ここでは現在状態の読み取りとトグルのみ行う。
@client
class ThemeToggle extends StatefulComponent {
  const ThemeToggle({super.key});

  @override
  State<ThemeToggle> createState() => _ThemeToggleState();

  @css
  static List<StyleRule> get styles => [
        css('.theme-toggle').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.center,
          padding: Padding.all(0.5.rem),
          radius: BorderRadius.circular(9999.px),
          border: Border.all(
              style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
          color: Color('var(--color-text)'),
          backgroundColor: Colors.transparent,
          raw: {'transition': 'background-color .3s'},
        ),
        css('.theme-toggle:hover')
            .styles(backgroundColor: Color('var(--color-surface)')),
      ];
}

class _ThemeToggleState extends State<ThemeToggle> {
  bool _isDark = true;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _isDark = themeIsDark();
    }
  }

  void _toggle() {
    final next = !_isDark;
    setState(() => _isDark = next);
    themeSetDark(next);
  }

  @override
  Component build(BuildContext context) {
    return button(
      classes: 'theme-toggle',
      attributes: {
        'aria-label': _isDark ? 'Switch to light mode' : 'Switch to dark mode',
      },
      onClick: _toggle,
      [icon(_isDark ? 'sun' : 'moon', size: 18)],
    );
  }
}
