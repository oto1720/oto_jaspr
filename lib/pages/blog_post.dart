import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import '../components/icons.dart';
import '../components/layout.dart';

/// ブログ記事詳細。Markdown 描画。フェーズ5で実装予定（SSG で全 slug 生成）。
class BlogPostPage extends StatelessComponent {
  const BlogPostPage({super.key, required this.slug});

  final String slug;

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container page-head', [
        Link(
          to: '/blog',
          child: span(classes: 'back-link', [
            icon('arrow-left', size: 16),
            Component.text('Blog 一覧'),
          ]),
        ),
        h1(classes: 'page-title', [Component.text('記事: $slug')]),
        p(classes: 'page-note', [Component.text('Markdown 本文（準備中：フェーズ5）')]),
      ]),
    ]);
  }

  @css
  static List<StyleRule> get styles => [
        css('.back-link').styles(
          display: Display.inlineFlex,
          alignItems: AlignItems.center,
          gap: Gap.all(0.375.rem),
          color: Color('var(--color-text-muted)'),
          raw: {'font-size': '0.875rem', 'margin-bottom': '1.5rem'},
        ),
      ];
}
