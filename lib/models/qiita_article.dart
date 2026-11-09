/// Qiita API から取得した記事1件（Blog ページで自作記事とマージして表示）。
class QiitaArticle {
  const QiitaArticle({
    required this.id,
    required this.title,
    required this.url,
    required this.date,
    required this.likesCount,
    required this.tags,
    required this.excerpt,
  });

  final String id;
  final String title;
  final String url;
  final String date;
  final int likesCount;
  final List<String> tags;
  final String excerpt;
}
