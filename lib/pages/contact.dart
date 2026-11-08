import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/layout.dart';

const _links = [
  (name: 'Email', iconName: 'mail', url: 'mailto:kotaro17206@gmail.com', display: 'kotaro17206@gmail.com'),
  (name: 'GitHub', iconName: 'github', url: 'https://github.com/oto1720', display: 'github.com/oto1720'),
  (name: 'Qiita', iconName: 'link-2', url: 'https://qiita.com/oto1720', display: 'qiita.com/oto1720'),
  (name: 'Twitter', iconName: 'twitter', url: 'https://x.com/ot6217', display: 'x.com/ot6217'),
];

/// お問い合わせ。SNS リンク一覧。
class ContactPage extends StatelessComponent {
  const ContactPage({super.key});

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container contact', [
        div(classes: 'contact-head', [
          h1(classes: 'page-title', [Component.text('Contact')]),
          p(classes: 'page-note', [Component.text('お気軽にご連絡ください')]),
        ]),
        div(classes: 'contact-card card', [
          h2(classes: 'contact-card-title', [Component.text('Connect With Me')]),
          for (final l in _links)
            a(href: l.url, target: Target.blank, classes: 'contact-link', [
              div(classes: 'contact-icon', [icon(l.iconName, size: 22)]),
              div([
                p(classes: 'contact-name', [Component.text(l.name)]),
                p(classes: 'contact-display', [Component.text(l.display)]),
              ]),
            ]),
        ]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.contact').styles(raw: {'padding': '8rem 1rem 4rem', 'max-width': '32rem'}),
        css('.contact-head').styles(raw: {'text-align': 'center', 'margin-bottom': '3rem'}),
        css('.contact-card').styles(raw: {'padding': '2rem'}),
        css('.contact-card-title').styles(
          color: Color('var(--color-text)'),
          fontWeight: FontWeight.w600,
          raw: {'font-size': '1.25rem', 'text-align': 'center', 'margin': '0 0 1.5rem'},
        ),
        css('.contact-link').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          gap: Gap.all(1.rem),
          backgroundColor: Color('var(--color-bg)'),
          border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
          radius: BorderRadius.circular(8.px),
          raw: {'padding': '1rem', 'margin-bottom': '1rem', 'transition': 'border-color .3s, transform .3s'},
        ),
        css('.contact-link:hover').styles(raw: {
          'border-color': 'var(--color-accent)',
          'transform': 'translateX(6px)',
        }),
        css('.contact-icon').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          justifyContent: JustifyContent.center,
          width: 2.5.rem,
          height: 2.5.rem,
          radius: BorderRadius.circular(9999.px),
          color: Color('var(--color-accent)'),
          raw: {'background-color': 'color-mix(in srgb, var(--color-accent) 10%, transparent)', 'flex-shrink': '0'},
        ),
        css('.contact-name').styles(color: Color('var(--color-text)'), raw: {'font-size': '0.875rem', 'font-weight': '600', 'margin': '0'}),
        css('.contact-display').styles(color: Color('var(--color-text-muted)'), raw: {'font-size': '0.75rem', 'margin': '0.125rem 0 0'}),
      ];
}
