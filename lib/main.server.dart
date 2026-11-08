/// サーバー(pre-render)環境のエントリポイント。
/// SSG ビルド時に各ルートを静的 HTML として出力する。
library;

import 'package:jaspr/dom.dart';
import 'package:jaspr/server.dart';

import 'app.dart';
import 'theme/app_styles.dart';

// Jaspr が自動生成するオプション（編集しない）。
import 'main.server.options.dart';

/// FOUC（ちらつき）防止: ペイント前に localStorage / prefers-color-scheme を見て
/// `<html>` に `dark` クラスを付ける先行スクリプト。
const _themeInitScript = "(function(){try{var t=localStorage.getItem('theme');"
    "var d=t?t==='dark':window.matchMedia('(prefers-color-scheme: dark)').matches;"
    "if(d){document.documentElement.classList.add('dark');}}"
    "catch(e){document.documentElement.classList.add('dark');}})();";

void main() {
  Jaspr.initializeApp(options: defaultServerOptions);

  runApp(Document(
    title: 'oto | Portfolio',
    lang: 'ja',
    viewport: 'width=device-width, initial-scale=1.0',
    meta: const {
      'description': '乙津孝太朗のポートフォリオサイト。制作物・経歴・ブログ。',
    },
    styles: [
      css.import(
          'https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap'),
      ...globalStyles,
    ],
    head: [
      script(content: _themeInitScript),
    ],
    body: App(),
  ));
}
