import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../util/format.dart';
import 'icons.dart';

/// Blog 一覧のカード1件分のデータ。自作記事（own）と Qiita（qiita）を共通化する。
class ArticleCardData {
  const ArticleCardData({
    required this.key,
    required this.source,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.tags,
    this.cover,
    this.likesCount,
    this.href,
    this.to,
  });

  final String key;
  final ArticleSource source;
  final String title;
  final String date;
  final String excerpt;
  final List<String> tags;
  final String? cover;
  final int? likesCount; // Qiita のみ
  final String? href; // Qiita: 外部リンク
  final String? to; // own: 内部リンク
}

enum ArticleSource { qiita, own }

/// 記事カード。own は内部 Link、qiita は外部 `a` で開く。
class ArticleCard extends StatelessComponent {
  const ArticleCard(this.data, {super.key});

  final ArticleCardData data;

  @override
  Component build(BuildContext context) {
    final inner = _inner();
    if (data.source == ArticleSource.own && data.to != null) {
      return Link(to: data.to!, child: div(classes: 'article-card', inner));
    }
    return a(
      href: data.href ?? '#',
      target: Target.blank,
      classes: 'article-card',
      attributes: {'rel': 'noopener noreferrer'},
      inner,
    );
  }

  List<Component> _inner() {
    final isQiita = data.source == ArticleSource.qiita;
    return [
      if (data.cover != null)
        div(classes: 'article-cover', [
          img(src: data.cover!, alt: data.title, attributes: {'loading': 'lazy', 'decoding': 'async'}),
        ]),
      div(classes: 'article-body', [
        div(classes: 'article-meta', [
          span(classes: isQiita ? 'article-badge qiita' : 'article-badge own', [
            icon(isQiita ? 'external-link' : 'pen-line', size: 12),
            Component.text(isQiita ? 'Qiita' : 'Blog'),
          ]),
          span(classes: 'article-date', [Component.text(formatJaDate(data.date))]),
        ]),
        h3(classes: 'article-title', [Component.text(data.title)]),
        if (data.excerpt.isNotEmpty)
          p(classes: 'article-excerpt', [Component.text(data.excerpt)]),
        div(classes: 'article-foot', [
          div(classes: 'article-tags', [
            for (final tag in data.tags.take(3))
              span(classes: 'article-tag', [Component.text(tag)]),
          ]),
          if (data.likesCount != null)
            span(classes: 'article-likes', [
              icon('heart', size: 13),
              Component.text(' ${data.likesCount}'),
            ]),
        ]),
      ]),
    ];
  }

  @css
  static List<StyleRule> get styles => _articleCardStyles;
}

final List<StyleRule> _articleCardStyles = [
  css('.article-card').styles(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    height: 100.percent,
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    raw: {'overflow': 'hidden', 'transition': 'box-shadow .3s, transform .3s, border-color .3s'},
  ),
  css('.article-card:hover').styles(raw: {
    'transform': 'translateY(-4px)',
    'box-shadow': '0 20px 25px -5px rgba(0,0,0,0.15)',
    'border-color': 'var(--color-accent)',
  }),
  css('.article-cover').styles(raw: {'aspect-ratio': '16 / 9', 'overflow': 'hidden'}),
  css('.article-cover img').styles(width: 100.percent, height: 100.percent, raw: {'object-fit': 'cover', 'transition': 'transform .5s'}),
  css('.article-card:hover .article-cover img').styles(raw: {'transform': 'scale(1.05)'}),
  css('.article-body').styles(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    padding: Padding.all(1.25.rem),
    raw: {'flex': '1', 'height': '100%'},
  ),
  css('.article-meta').styles(display: Display.flex, alignItems: AlignItems.center, justifyContent: JustifyContent.spaceBetween, raw: {'margin-bottom': '0.75rem'}),
  css('.article-badge').styles(
    display: Display.inlineFlex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.25.rem),
    radius: BorderRadius.circular(9999.px),
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.25.rem),
    fontWeight: FontWeight.w500,
    raw: {'font-size': '0.75rem'},
  ),
  css('.article-badge.qiita').styles(raw: {'color': '#55c500', 'background-color': 'color-mix(in srgb, #55c500 10%, transparent)'}),
  css('.article-badge.own').styles(raw: {'color': 'var(--color-accent)', 'background-color': 'color-mix(in srgb, var(--color-accent) 10%, transparent)'}),
  css('.article-date').styles(color: Color('var(--color-text-muted)'), raw: {'font-size': '0.75rem'}),
  css('.article-title').styles(
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.w600,
    raw: {
      'font-size': '1.125rem',
      'line-height': '1.4',
      'margin': '0 0 0.5rem',
      'transition': 'color .3s',
      'display': '-webkit-box',
      '-webkit-line-clamp': '2',
      '-webkit-box-orient': 'vertical',
      'overflow': 'hidden',
    },
  ),
  css('.article-card:hover .article-title').styles(color: Color('var(--color-accent)')),
  css('.article-excerpt').styles(
    color: Color('var(--color-text-muted)'),
    raw: {
      'font-size': '0.875rem',
      'margin': '0 0 1rem',
      'display': '-webkit-box',
      '-webkit-line-clamp': '3',
      '-webkit-box-orient': 'vertical',
      'overflow': 'hidden',
    },
  ),
  css('.article-foot').styles(display: Display.flex, alignItems: AlignItems.center, justifyContent: JustifyContent.spaceBetween, raw: {'margin-top': 'auto', 'gap': '0.5rem'}),
  css('.article-tags').styles(display: Display.flex, gap: Gap.all(0.375.rem), raw: {'flex-wrap': 'wrap'}),
  css('.article-tag').styles(
    color: Color('var(--color-text-muted)'),
    backgroundColor: Color('var(--color-bg)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(6.px),
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    raw: {'font-size': '11px'},
  ),
  css('.article-likes').styles(
    display: Display.inlineFlex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.25.rem),
    color: Color('var(--color-text-muted)'),
    raw: {'font-size': '0.75rem', 'flex-shrink': '0'},
  ),
];
