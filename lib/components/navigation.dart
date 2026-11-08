import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../browser/browser.dart';
import 'icons.dart';
import 'theme_toggle.dart';

const _navLinks = [
  (path: '/', label: 'Home'),
  (path: '/profile', label: 'Profile'),
  (path: '/portfolio', label: 'Works'),
  (path: '/blog', label: 'Blog'),
  (path: '/contact', label: 'Contact'),
];

/// 上部固定ナビ（island）。
/// - スクロールで背景 blur（`.scrolled`）
/// - モバイルメニュー開閉
/// - テーマトグル内包
/// - reveal の IntersectionObserver もここで初期化（全ページに存在するため）
@client
class Navigation extends StatefulComponent {
  const Navigation({super.key});

  @override
  State<Navigation> createState() => _NavigationState();

  @css
  static List<StyleRule> get styles => _navStyles;
}

class _NavigationState extends State<Navigation> {
  bool _scrolled = false;
  bool _menuOpen = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      initNavScroll((scrolled) {
        if (scrolled != _scrolled) setState(() => _scrolled = scrolled);
      });
      initReveal();
    }
  }

  void _toggleMenu() => setState(() => _menuOpen = !_menuOpen);

  String get _activePath => context.url;

  @override
  Component build(BuildContext context) {
    return Component.fragment([
      nav(id: 'site-nav', classes: _scrolled ? 'nav scrolled' : 'nav', [
        div(classes: 'nav-inner', [
          Link(to: '/', child: span(classes: 'nav-brand', [Component.text('oto')])),
          // デスクトップ
          div(classes: 'nav-links', [
            for (final l in _navLinks)
              Link(
                to: l.path,
                child: span(
                  classes: _activePath == l.path ? 'nav-link active' : 'nav-link',
                  [Component.text(l.label)],
                ),
              ),
            const ThemeToggle(),
          ]),
          // モバイル
          div(classes: 'nav-mobile-actions', [
            const ThemeToggle(),
            button(
              classes: 'nav-menu-btn',
              attributes: {'aria-label': _menuOpen ? 'Close menu' : 'Open menu'},
              onClick: _toggleMenu,
              [icon(_menuOpen ? 'x' : 'menu', size: 24)],
            ),
          ]),
        ]),
      ]),
      // モバイルメニュー オーバーレイ
      if (_menuOpen)
        div(classes: 'mobile-menu', [
          for (final l in _navLinks)
            Link(
              to: l.path,
              child: span(
                classes: _activePath == l.path ? 'mobile-link active' : 'mobile-link',
                [Component.text(l.label)],
              ),
            ),
        ]),
    ]);
  }

}

final List<StyleRule> _navStyles = [
        css('.nav').styles(
          position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero),
          zIndex: ZIndex(40),
          padding: Padding.symmetric(horizontal: 1.5.rem, vertical: 1.rem),
          backgroundColor: Colors.transparent,
          raw: {'transition': 'background-color .3s, border-color .3s, backdrop-filter .3s'},
        ),
        css('.nav.scrolled').styles(raw: {
          'background-color': 'color-mix(in srgb, var(--color-bg) 80%, transparent)',
          'backdrop-filter': 'blur(12px)',
          '-webkit-backdrop-filter': 'blur(12px)',
          'border-bottom': '1px solid var(--color-border)',
        }),
        css('.nav-inner').styles(
          width: 100.percent,
          maxWidth: 1280.px,
          margin: Margin.symmetric(horizontal: Unit.auto),
          display: Display.flex,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.spaceBetween,
        ),
        css('.nav-brand').styles(
          color: Color('var(--color-text)'),
          fontWeight: FontWeight.w600,
          fontSize: 1.25.rem,
        ),
        css('.nav-links').styles(
          display: Display.none,
          alignItems: AlignItems.center,
          gap: Gap.all(2.rem),
        ),
        css('.nav-link').styles(
          color: Color('var(--color-text)'),
          fontSize: 0.875.rem,
          raw: {
            'text-transform': 'uppercase',
            'letter-spacing': '0.05em',
            'opacity': '0.7',
            'transition': 'opacity .3s',
            'padding-bottom': '2px',
            'border-bottom': '1px solid transparent',
          },
        ),
        css('.nav-link:hover').styles(raw: {'opacity': '1'}),
        css('.nav-link.active').styles(raw: {
          'opacity': '1',
          'font-weight': '600',
          'border-bottom-color': 'var(--color-accent)',
        }),
        css('.nav-mobile-actions').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          gap: Gap.all(0.75.rem),
        ),
        css('.nav-menu-btn').styles(
          display: Display.flex,
          color: Color('var(--color-text)'),
          backgroundColor: Colors.transparent,
          border: Border.unset,
        ),
        // モバイルメニュー
        css('.mobile-menu').styles(
          position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
          zIndex: ZIndex(30),
          backgroundColor: Color('var(--color-bg)'),
          display: Display.flex,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.center,
          gap: Gap.all(1.5.rem),
        ),
        css('.mobile-link').styles(
          color: Color('var(--color-text)'),
          fontSize: 1.5.rem,
          raw: {'font-weight': '300'},
        ),
        css('.mobile-link.active').styles(raw: {'font-weight': '600'}),
        // レスポンシブ: md 以上でデスクトップnav表示、モバイルアクション非表示
        css.media(MediaQuery.screen(minWidth: 768.px), [
          css('.nav-links').styles(display: Display.flex),
          css('.nav-mobile-actions').styles(display: Display.none),
        ]),
      ];
