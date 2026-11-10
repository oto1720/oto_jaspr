import 'dart:convert';

import 'package:http/http.dart' as http;

import '../browser/browser.dart';
import '../models/qiita_article.dart';

/// Qiita API から記事一覧を取得する（Blog island からクライアント実行時に呼ぶ）。
/// oto_web の `useQiitaArticles` フックのロジックを移植。
/// sessionStorage に 30 分キャッシュして API 制限（60req/h）を避ける。
class QiitaService {
  static const _user = 'oto1720';
  static const _cacheKey = 'qiita:$_user';
  static const _cacheTtlMs = 1000 * 60 * 30; // 30分

  /// 記事を取得。キャッシュが新しければそれを返す。失敗時は例外を投げる。
  static Future<List<QiitaArticle>> fetchArticles() async {
    final cached = _readCache();
    if (cached != null) return cached;

    final res = await http.get(
      Uri.parse('https://qiita.com/api/v2/users/$_user/items?per_page=100'),
      headers: {'Accept': 'application/json'},
    );
    if (res.statusCode != 200) {
      throw Exception('Qiita API ${res.statusCode}');
    }

    final items = jsonDecode(utf8.decode(res.bodyBytes)) as List;
    final articles = items.map((item) {
      final m = item as Map<String, dynamic>;
      return QiitaArticle(
        id: m['id'] as String,
        title: m['title'] as String,
        url: m['url'] as String,
        date: m['created_at'] as String,
        likesCount: (m['likes_count'] as num?)?.toInt() ?? 0,
        tags: ((m['tags'] as List?) ?? [])
            .map((t) => (t as Map<String, dynamic>)['name'] as String)
            .toList(),
        excerpt: makeExcerpt(m['body'] as String? ?? ''),
      );
    }).toList();

    _writeCache(articles);
    return articles;
  }

  static List<QiitaArticle>? _readCache() {
    final cached = sessionGet(_cacheKey);
    if (cached == null) return null;
    try {
      final parsed = jsonDecode(cached) as Map<String, dynamic>;
      final at = (parsed['at'] as num).toInt();
      if (DateTime.now().millisecondsSinceEpoch - at >= _cacheTtlMs) return null;
      return (parsed['articles'] as List)
          .map((e) => _fromJson(e as Map<String, dynamic>))
          .toList();
    } catch (_) {
      return null; // キャッシュ破損時は無視して取得へ
    }
  }

  static void _writeCache(List<QiitaArticle> articles) {
    final payload = jsonEncode({
      'at': DateTime.now().millisecondsSinceEpoch,
      'articles': articles.map(_toJson).toList(),
    });
    sessionSet(_cacheKey, payload);
  }

  static Map<String, dynamic> _toJson(QiitaArticle a) => {
        'id': a.id,
        'title': a.title,
        'url': a.url,
        'date': a.date,
        'likesCount': a.likesCount,
        'tags': a.tags,
        'excerpt': a.excerpt,
      };

  static QiitaArticle _fromJson(Map<String, dynamic> m) => QiitaArticle(
        id: m['id'] as String,
        title: m['title'] as String,
        url: m['url'] as String,
        date: m['date'] as String,
        likesCount: (m['likesCount'] as num).toInt(),
        tags: (m['tags'] as List).cast<String>(),
        excerpt: m['excerpt'] as String,
      );
}

/// 本文からコードブロック・画像・記号を除いて先頭 [length] 文字の抜粋を作る。
String makeExcerpt(String body, {int length = 100}) {
  final text = body
      .replaceAll(RegExp(r'```[\s\S]*?```'), '') // コードブロック除去
      .replaceAll(RegExp(r'!\[[^\]]*\]\([^)]*\)'), '') // 画像除去
      .replaceAll(RegExp(r'[#>*`_\-]'), '') // 記号除去
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
  return text.length > length ? '${text.substring(0, length)}…' : text;
}
