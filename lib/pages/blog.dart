import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/layout.dart';

/// ブログ一覧。自作記事 + Qiita をマージ、フィルタタブ。フェーズ5で実装予定。
class BlogPage extends StatelessComponent {
  const BlogPage({super.key});

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container page-head', [
        h1(classes: 'page-title', [Component.text('Blog')]),
        p(classes: 'page-note', [Component.text('自作記事と Qiita の投稿（準備中：フェーズ5）')]),
      ]),
    ]);
  }
}
