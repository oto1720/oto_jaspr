# oto_jaspr

乙津孝太朗のポートフォリオサイト。[Jaspr](https://github.com/schultek/jaspr)（Dart製Webフレームワーク）で **静的サイト生成（SSG）** します。
`oto_web`（React + Vite）からの移行プロジェクト。移行計画は `oto_jaspr_migration_plan.md` を参照。

## 必要環境

- Flutter 3.47+（Dart 3.13+ 同梱）
- jaspr CLI: `dart pub global activate jaspr_cli`

### ⚠️ Dart SDK の PATH について

`jaspr` コマンドは「Flutter のラッパー経由の dart」を SDK として認識できません。
実体の Dart SDK を PATH 先頭に通してから実行してください。

```bash
export PATH="/opt/homebrew/share/flutter/bin/cache/dart-sdk/bin:$PATH:$HOME/.pub-cache/bin"
```

（`.zshrc` に入れておくと毎回不要です）

## 開発サーバー

```bash
jaspr serve   # http://localhost:8080
```

## ビルド

```bash
jaspr build   # 出力: build/jaspr/
```

## 構成（MS1 時点）

```
lib/
├── main.server.dart      # Document（head/meta/font/FOUCテーマスクリプト/グローバルCSS）
├── app.dart              # Router（5ルート）+ 共通Navigation
├── theme/                # tokens(CSS変数) / app_styles(グローバル・markdown)
├── browser/              # DOMアクセス（条件付きimport: server stub / web実装）
├── components/           # navigation(@client) / theme_toggle(@client) /
│                         # reveal / page_transition / layout / icons(lucide SVG)
└── pages/                # home / profile / portfolio / blog / blog_post / contact
```

### 実装状況

- ✅ フェーズ0-2（MS1「骨格」）: ルーティング・共通レイアウト・ナビ・ダーク/ライト切替・
  スクロール発火(reveal)・ヒーロー・Contact・各ページのスケルトン
- ⬜ フェーズ3-5: Home/Profile/Portfolio の肉付け、モーダル、Blog + Qiita、Markdown記事
  （`/blog/:slug` は SSG のパスパラメータ非対応のため、記事ごとに静的Routeを生成して対応予定）
