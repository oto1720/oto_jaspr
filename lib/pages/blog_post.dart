import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';
import 'package:markdown/markdown.dart' as md;

import '../components/icons.dart';
import '../components/layout.dart';
import '../content/posts_loader.dart';
import '../models/post.dart';
import '../util/format.dart';

/// ブログ記事詳細。frontmatter（日付/タグ/カバー）+ Markdown 本文。
/// SSG では全 slug 分を静的生成する（app.dart 参照）。記事が無ければ 404 表示。
class BlogPostPage extends StatelessComponent {
  const BlogPostPage({super.key, required this.slug});

  final String slug;

  @override
  Component build(BuildContext context) {
    final post = getPostBySlug(slug);
    if (post == null) return _notFound();
    return _article(post);
  }

  Component _notFound() {
    return Layout([
      div(classes: 'container blog-404', [
        h1(classes: 'blog-404-title', [Component.text('記事が見つかりませんでした')]),
        Link(
          to: '/blog',
          child: span(classes: 'blog-404-link', [Component.text('← Blog 一覧に戻る')]),
        ),
      ]),
    ]);
  }

  Component _article(Post post) {
    final html = md.markdownToHtml(
      post.content,
      extensionSet: md.ExtensionSet.gitHubFlavored,
    );
    return Layout([
      article(
        classes: 'container blog-article',
        [
          Link(
            to: '/blog',
            child: span(classes: 'back-link', [
              icon('arrow-left', size: 16),
              Component.text('Blog 一覧'),
            ]),
          ),
          div(classes: 'blog-article-meta', [
            span(classes: 'blog-article-date', [Component.text(formatJaDate(post.date))]),
            for (final tag in post.tags)
              span(classes: 'blog-article-tag', [Component.text(tag)]),
          ]),
          h1(classes: 'blog-article-title', [Component.text(post.title)]),
          if (post.cover != null)
            img(src: post.cover!, alt: post.title, classes: 'blog-article-cover'),
          div(classes: 'markdown-body', [RawText(html)]),
        ],
      ),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.blog-article').styles(raw: {'padding': '8rem 1rem 5rem', 'max-width': '48rem'}),
        css('.back-link').styles(
          display: Display.inlineFlex,
          alignItems: AlignItems.center,
          gap: Gap.all(0.375.rem),
          color: Color('var(--color-text-muted)'),
          raw: {'font-size': '0.875rem', 'margin-bottom': '2rem', 'transition': 'color .3s'},
        ),
        css('.back-link:hover').styles(color: Color('var(--color-text)')),
        css('.blog-article-meta').styles(
          display: Display.flex,
          alignItems: AlignItems.center,
          gap: Gap.all(0.75.rem),
          color: Color('var(--color-text-muted)'),
          raw: {'font-size': '0.875rem', 'margin-bottom': '1rem', 'flex-wrap': 'wrap'},
        ),
        css('.blog-article-tag').styles(
          backgroundColor: Color('var(--color-surface)'),
          border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
          radius: BorderRadius.circular(6.px),
          padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
        ),
        css('.blog-article-title').styles(
          color: Color('var(--color-text)'),
          fontWeight: FontWeight.bold,
          raw: {'font-size': 'clamp(1.75rem,5vw,2.5rem)', 'letter-spacing': '-0.02em', 'margin': '0 0 2rem'},
        ),
        css('.blog-article-cover').styles(
          width: 100.percent,
          border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
          radius: BorderRadius.circular(12.px),
          raw: {'margin-bottom': '2.5rem'},
        ),
        css('.blog-404').styles(raw: {'padding': '10rem 1rem', 'text-align': 'center'}),
        css('.blog-404-title').styles(color: Color('var(--color-text)'), fontWeight: FontWeight.bold, raw: {'font-size': '1.5rem', 'margin': '0 0 1rem'}),
        css('.blog-404-link').styles(color: Color('var(--color-accent)'), raw: {'text-decoration': 'underline'}),
      ];
}
