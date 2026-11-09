/// 自作ブログ記事（`content/posts/*.md` を frontmatter 付きで読み込んだもの）。
/// 本文 `content` は Markdown のまま保持し、描画側で HTML 化する。
class Post {
  const Post({
    required this.slug,
    required this.title,
    required this.date,
    required this.excerpt,
    required this.tags,
    required this.content,
    this.cover,
  });

  final String slug;
  final String title;
  final String date;
  final String excerpt;
  final List<String> tags;
  final String content;
  final String? cover;
}
