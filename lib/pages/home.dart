import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/icons.dart';
import '../components/layout.dart';
import '../components/reveal.dart';

/// トップページ。ヒーロー + 各セクションへの導線。
/// （フェーズ3で Works/Profile/Contact プレビューを肉付け予定）
class HomePage extends StatelessComponent {
  const HomePage({super.key});

  @override
  Component build(BuildContext context) {
    return Layout([
      section(classes: 'hero', [
        div(classes: 'hero-inner', [
          h1(classes: 'hero-title', [Component.text('Portfolio')]),
          p(classes: 'hero-sub', [Component.text('こちらがotoのポートフォリオです。')]),
          div(classes: 'hero-name', [
            p(classes: 'name', [Component.text('乙津孝太朗')]),
            p(classes: 'affil', [Component.text('福岡大学工学部電子情報工学科')]),
          ]),
          div(classes: 'hero-actions', [
            Link(
              to: '/portfolio',
              child: span(classes: 'btn btn-primary', [
                Component.text('Works を見る'),
                icon('arrow-right', size: 16),
              ]),
            ),
            Link(
              to: '/profile',
              child: span(classes: 'btn btn-outline', [Component.text('Profile')]),
            ),
          ]),
          div(classes: 'hero-arrow', [icon('arrow-down', size: 28)]),
        ]),
      ]),
      Reveal([
        section(classes: 'home-section', [
          div(classes: 'container', [
            h2(classes: 'section-title', [Component.text('Profile')]),
            p(classes: 'section-lead', [Component.text('使える技術や経験が見れます！')]),
            Link(
              to: '/profile',
              child: span(classes: 'btn btn-primary', [
                Component.text('プロフィールを見る'),
                icon('arrow-right', size: 16),
              ]),
            ),
          ]),
        ]),
      ]),
      Reveal([
        section(classes: 'home-section alt', [
          div(classes: 'container', [
            h2(classes: 'section-title', [Component.text('Contact')]),
            p(classes: 'section-lead', [Component.text('SNSリンクやお問い合わせはこちら')]),
            Link(
              to: '/contact',
              child: span(classes: 'btn btn-primary', [
                Component.text('お問い合わせ'),
                icon('arrow-right', size: 16),
              ]),
            ),
          ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.hero').styles(
          width: 100.percent,
          minHeight: 100.vh,
          display: Display.flex,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.center,
          raw: {
            'background':
                'linear-gradient(135deg, rgba(59,130,246,0.05), transparent, rgba(168,85,247,0.05))',
          },
        ),
        css('.hero-inner').styles(
          display: Display.flex,
          flexDirection: FlexDirection.column,
          alignItems: AlignItems.center,
          raw: {'text-align': 'center', 'padding': '0 1rem'},
        ),
        css('.hero-title').styles(
          fontWeight: FontWeight.bold,
          color: Color('var(--color-text)'),
          raw: {
            'font-size': 'clamp(3rem, 10vw, 7rem)',
            'letter-spacing': '-0.03em',
            'margin': '0 0 1.5rem',
          },
        ),
        css('.hero-sub').styles(
          color: Color('var(--color-text-muted)'),
          raw: {
            'font-size': 'clamp(1.1rem,3vw,1.5rem)',
            'font-weight': '300',
            'margin': '0 0 1rem',
            'max-width': '42rem',
          },
        ),
        css('.hero-name').styles(raw: {'margin-bottom': '3rem'}),
        css('.hero-name .name').styles(
            color: Color('var(--color-text)'), raw: {'font-weight': '500', 'margin': '0'}),
        css('.hero-name .affil').styles(
            color: Color('var(--color-text-muted)'),
            raw: {'font-size': '0.875rem', 'margin': '0.25rem 0 0'}),
        css('.hero-actions').styles(
          display: Display.flex,
          gap: Gap.all(1.rem),
          justifyContent: JustifyContent.center,
          raw: {'flex-wrap': 'wrap', 'margin-bottom': '4rem'},
        ),
        css('.hero-arrow').styles(
            color: Color('var(--color-text-muted)'),
            raw: {'animation': 'bounce 1.5s infinite', 'opacity': '0.6'}),
        css('.home-section').styles(
          backgroundColor: Color('var(--color-bg)'),
          raw: {'padding': '6rem 0'},
        ),
        css('.home-section.alt')
            .styles(backgroundColor: Color('var(--color-surface)')),
        css('.section-title').styles(
          color: Color('var(--color-text)'),
          fontWeight: FontWeight.bold,
          raw: {
            'font-size': 'clamp(2rem,5vw,3.5rem)',
            'letter-spacing': '-0.02em',
            'margin': '0 0 1rem'
          },
        ),
        css('.section-lead').styles(
            color: Color('var(--color-text-muted)'),
            raw: {'margin': '0 0 2rem', 'font-size': '1.1rem'}),
      ];
}
