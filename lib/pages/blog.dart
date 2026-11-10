import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/article_card.dart';
import '../components/icons.dart';
import '../components/layout.dart';
import '../content/posts_loader.dart';
import '../models/qiita_article.dart';
import '../services/qiita_service.dart';

/// ブログ一覧（island）。自作記事 + Qiita をマージし、all/own/qiita で
/// フィルタする。Qiita はクライアント実行時に取得（ローディング/エラー対応）。
@client
class BlogPage extends StatefulComponent {
  const BlogPage({super.key});

  @override
  State<BlogPage> createState() => _BlogPageState();

  @css
  static List<StyleRule> get styles => _blogStyles;
}

enum _Filter { all, own, qiita }

class _BlogPageState extends State<BlogPage> {
  _Filter _filter = _Filter.all;
  List<QiitaArticle> _qiita = const [];
  bool _loading = true;
  bool _error = false;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      _loadQiita();
    } else {
      _loading = false; // サーバー側は自作記事のみ描画
    }
  }

  Future<void> _loadQiita() async {
    try {
      final articles = await QiitaService.fetchArticles();
      if (!mounted) return;
      setState(() {
        _qiita = articles;
        _loading = false;
        _error = false;
      });
    } catch (_) {
      if (!mounted) return;
      setState(() {
        _qiita = const [];
        _loading = false;
        _error = true;
      });
    }
  }

  List<ArticleCardData> get _items {
    final own = getAllPosts().map((post) => ArticleCardData(
          key: 'own-${post.slug}',
          source: ArticleSource.own,
          title: post.title,
          date: post.date,
          excerpt: post.excerpt,
          tags: post.tags,
          cover: post.cover,
          to: '/blog/${post.slug}',
        ));
    final qiita = _qiita.map((art) => ArticleCardData(
          key: 'qiita-${art.id}',
          source: ArticleSource.qiita,
          title: art.title,
          date: art.date,
          excerpt: art.excerpt,
          tags: art.tags,
          likesCount: art.likesCount,
          href: art.url,
        ));
    return [...own, ...qiita].where((item) {
      switch (_filter) {
        case _Filter.all:
          return true;
        case _Filter.own:
          return item.source == ArticleSource.own;
        case _Filter.qiita:
          return item.source == ArticleSource.qiita;
      }
    }).toList()
      ..sort((x, y) => y.date.compareTo(x.date));
  }

  @override
  Component build(BuildContext context) {
    final items = _items;
    final showSkeleton = _loading && _filter != _Filter.own && items.isEmpty;
    return Layout([
      div(classes: 'container', [
        div(classes: 'page-head blog-head', [
          h1(classes: 'page-title', [Component.text('Blog')]),
          p(classes: 'page-note', [Component.text('自分で書いた記事と Qiita の投稿')]),
        ]),
        div(classes: 'blog-tabs', [
          _tab(_Filter.all, 'すべて'),
          _tab(_Filter.own, 'Blog'),
          _tab(_Filter.qiita, 'Qiita'),
        ]),
        if (_error && _filter != _Filter.own)
          div(classes: 'blog-error', [
            icon('alert-circle', size: 16),
            Component.text('Qiita の記事を取得できませんでした。時間をおいて再度お試しください。'),
          ]),
        if (showSkeleton)
          div(classes: 'blog-grid', [
            for (var i = 0; i < 6; i++) div(classes: 'blog-skeleton', const []),
          ])
        else if (items.isEmpty)
          p(classes: 'blog-empty', [Component.text('記事がまだありません。')])
        else
          div(classes: 'blog-grid', [
            for (final item in items) ArticleCard(item, key: Key(item.key)),
          ]),
      ]),
    ]);
  }

  Component _tab(_Filter filter, String label) {
    return button(
      classes: _filter == filter ? 'blog-tab active' : 'blog-tab',
      onClick: () => setState(() => _filter = filter),
      [Component.text(label)],
    );
  }
}

final List<StyleRule> _blogStyles = [
  css('.blog-head').styles(raw: {'padding-bottom': '2rem'}),
  css('.blog-tabs').styles(display: Display.flex, gap: Gap.all(0.5.rem), raw: {'margin-bottom': '2.5rem', 'flex-wrap': 'wrap'}),
  css('.blog-tab').styles(
    color: Color('var(--color-text-muted)'),
    backgroundColor: Colors.transparent,
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(9999.px),
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
    raw: {'font-size': '0.875rem', 'transition': 'all .3s'},
  ),
  css('.blog-tab:hover').styles(raw: {'color': 'var(--color-text)'}),
  css('.blog-tab.active').styles(raw: {
    'background-color': 'var(--color-text)',
    'color': 'var(--color-bg)',
    'border-color': 'var(--color-text)',
  }),
  css('.blog-error').styles(
    display: Display.flex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.5.rem),
    color: Color('var(--color-text-muted)'),
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(8.px),
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.75.rem),
    raw: {'font-size': '0.875rem', 'margin-bottom': '2rem'},
  ),
  css('.blog-empty').styles(color: Color('var(--color-text-muted)')),
  css('.blog-grid').styles(
    display: Display.grid,
    gap: Gap.all(1.5.rem),
    raw: {'grid-template-columns': 'repeat(1, minmax(0,1fr))', 'margin-bottom': '4rem'},
  ),
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.blog-grid').styles(raw: {'grid-template-columns': 'repeat(2, minmax(0,1fr))'}),
  ]),
  css.media(MediaQuery.screen(minWidth: 1024.px), [
    css('.blog-grid').styles(raw: {'grid-template-columns': 'repeat(3, minmax(0,1fr))'}),
  ]),
  css('.blog-skeleton').styles(
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    raw: {'height': '12rem', 'animation': 'pulse 1.5s ease-in-out infinite'},
  ),
  css.keyframes('pulse', {
    '0%, 100%': Styles(raw: {'opacity': '1'}),
    '50%': Styles(raw: {'opacity': '0.5'}),
  }),
];
