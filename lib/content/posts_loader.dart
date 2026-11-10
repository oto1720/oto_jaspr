import '../models/post.dart';

/// 自作ブログ記事（Markdown）の読み込み・パース。
///
/// SSG + island の制約（@client 側で dart:io が使えない／パスパラメータ非対応）
/// を避けるため、記事の生 Markdown は Dart 側に埋め込み、frontmatter を
/// パースして [Post] 化する。新規記事は `content/posts/` に .md を追加した上で
/// [_rawPosts] に `ファイル名 -> 生テキスト` を追記する。
/// frontmatter パーサは oto_web の `src/lib/posts.ts` のロジックを移植したもの。

/// ファイル名（拡張子なし）-> 生 Markdown。
const Map<String, String> _rawPosts = {
  '2026-07-22-hello-blog': _helloBlog,
};

final List<Post> _allPosts = _rawPosts.entries
    .map((e) => _parsePost(e.key, e.value))
    .toList()
  ..sort((a, b) => b.date.compareTo(a.date)); // 日付降順

/// 全記事（日付降順）。
List<Post> getAllPosts() => _allPosts;

/// slug から記事を取得（無ければ null）。
Post? getPostBySlug(String slug) {
  for (final p in _allPosts) {
    if (p.slug == slug) return p;
  }
  return null;
}

Post _parsePost(String fileName, String raw) {
  final (data, content) = _parseFrontmatter(raw);
  final slug = _stringValue(data['slug'], fileName);
  final cover = _stringValue(data['cover'], '');
  return Post(
    slug: slug,
    title: _stringValue(data['title'], slug),
    date: _stringValue(data['date'], ''),
    excerpt: _stringValue(data['excerpt'], ''),
    tags: _arrayValue(data['tags']),
    cover: cover.isEmpty ? null : cover,
    content: content,
  );
}

/// 軽量 frontmatter パーサ。`---\n ... \n---\n` を切り出して key: value を読む。
(Map<String, Object>, String) _parseFrontmatter(String raw) {
  final match = RegExp(r'^---\s*\n([\s\S]*?)\n---\s*\n?([\s\S]*)$').firstMatch(raw);
  if (match == null) {
    return (<String, Object>{}, raw.trim());
  }

  final frontmatter = match.group(1)!;
  final content = match.group(2)!;
  final data = <String, Object>{};

  for (final line in frontmatter.split('\n')) {
    final idx = line.indexOf(':');
    if (idx == -1) continue;
    final key = line.substring(0, idx).trim();
    var value = line.substring(idx + 1).trim();
    if (key.isEmpty) continue;

    if (value.startsWith('[') && value.endsWith(']')) {
      data[key] = value
          .substring(1, value.length - 1)
          .split(',')
          .map((v) => _stripQuotes(v.trim()))
          .where((v) => v.isNotEmpty)
          .toList();
    } else {
      data[key] = _stripQuotes(value);
    }
  }

  return (data, content.trim());
}

String _stripQuotes(String v) =>
    v.replaceAll(RegExp(r'''^["']|["']$'''), '');

String _stringValue(Object? v, String fallback) {
  if (v is List) return v.isNotEmpty ? v.first.toString() : fallback;
  if (v is String) return v;
  return fallback;
}

List<String> _arrayValue(Object? v) {
  if (v is List) return v.cast<String>();
  if (v is String && v.isNotEmpty) return [v];
  return [];
}

// --- 記事本文（content/posts/*.md と同一内容を埋め込み） ---

const String _helloBlog = r'''---
title: このポートフォリオにブログ機能を追加しました
date: 2026-07-22
excerpt: Markdown ファイルを追加するだけで記事を公開できるブログ機能を作りました。この記事はその最初の投稿です。
tags: [Jaspr, Dart, Markdown]
---

## はじめに

このポートフォリオサイトに、**自分で記事を書いて公開できるブログ機能**を追加しました。
`content/posts/` に Markdown ファイルを置いて git に push するだけで、ビルド時に静的ページとして生成されます。

## 記事の書き方

1. `content/posts/` に `YYYY-MM-DD-好きな名前.md` を作成する
2. 先頭に frontmatter を書く（下記参照）
3. 本文を Markdown で書く
4. `lib/content/posts_loader.dart` の一覧に追記する
5. `git commit` して `git push` する

### frontmatter の例

```yaml
---
title: 記事のタイトル
date: 2026-07-22
excerpt: 一覧に表示される短い説明文
tags: [Dart, Jaspr]
cover: /assets/images/example.png   # 任意（省略可）
---
```

## 対応している記法

GitHub Flavored Markdown に対応しています。

- リスト
- **太字** と *斜体*
- [リンク](https://qiita.com/oto1720)
- `インラインコード`

> 引用もこのように表示されます。

コードブロックも表示されます。

```dart
String greet(String name) {
  return 'Hello, $name!';
}
```

| 項目 | 内容 |
| --- | --- |
| 記法 | GFM |
| レンダリング | package:markdown |

## おわりに

Qiita の記事一覧も同じ Blog ページに統合表示しています。ぜひご覧ください。
''';
