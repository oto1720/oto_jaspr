import 'package:jaspr/dom.dart';

import 'tokens.dart';

/// アプリ全体のグローバルスタイル。
/// `main.server.dart` の `Document(styles: globalStyles)` に渡して
/// `<head>` に出力する。CSS 変数・リセット・スクロールバー・選択色・
/// キーフレーム・`.markdown-body`・スクロール発火(reveal)用クラス・
/// 共通ユーティリティ(container/btn/card/tag など)をまとめている。
final List<StyleRule> globalStyles = [
  // --- CSS 変数（ダーク/ライト） ---
  css(':root').styles(raw: lightVars),
  css('.dark').styles(raw: darkVars),

  // --- リセット & ベース ---
  css('*').styles(raw: {'box-sizing': 'border-box'}),
  css('html, body').styles(
    width: 100.percent,
    minHeight: 100.vh,
    margin: Margin.zero,
    padding: Padding.zero,
    backgroundColor: colorBg,
    color: colorText,
    fontFamily: const FontFamily.list([FontFamily('Inter'), FontFamilies.sansSerif]),
    raw: {
      'overflow-x': 'hidden',
      '-webkit-font-smoothing': 'antialiased',
      'transition': 'background-color 0.3s ease, color 0.3s ease',
    },
  ),
  css('a').styles(raw: {'color': 'inherit', 'text-decoration': 'none'}),
  css('img').styles(raw: {'display': 'block', 'max-width': '100%'}),
  css('button').styles(raw: {'font-family': 'inherit', 'cursor': 'pointer'}),

  // --- スクロールバー ---
  css('::-webkit-scrollbar').styles(width: 8.px),
  css('::-webkit-scrollbar-track').styles(backgroundColor: colorSurface),
  css('::-webkit-scrollbar-thumb').styles(
    backgroundColor: colorBorder,
    radius: BorderRadius.circular(4.px),
  ),
  css('::-webkit-scrollbar-thumb:hover').styles(backgroundColor: colorTextMuted),
  css('::selection').styles(raw: {
    'background-color': 'rgba(59, 130, 246, 0.3)',
    'color': 'var(--color-text)',
  }),

  // --- キーフレーム ---
  css.keyframes('fadeInUp', {
    'from': Styles(raw: {'opacity': '0', 'transform': 'translateY(20px)'}),
    'to': Styles(raw: {'opacity': '1', 'transform': 'translateY(0)'}),
  }),
  css.keyframes('float', {
    '0%, 100%': Styles(raw: {'transform': 'translateY(0px) translateX(0px)'}),
    '33%': Styles(raw: {'transform': 'translateY(-20px) translateX(10px)'}),
    '66%': Styles(raw: {'transform': 'translateY(10px) translateX(-15px)'}),
  }),
  css.keyframes('bounce', {
    '0%, 100%': Styles(raw: {'transform': 'translateY(-25%)', 'animation-timing-function': 'cubic-bezier(0.8,0,1,1)'}),
    '50%': Styles(raw: {'transform': 'translateY(0)', 'animation-timing-function': 'cubic-bezier(0,0,0.2,1)'}),
  }),

  // --- スクロール発火アニメ（reveal.dart が .is-visible を付与） ---
  css('.reveal').styles(raw: {
    'opacity': '0',
    'transform': 'translateY(24px)',
    'transition': 'opacity 0.6s ease, transform 0.6s ease',
  }),
  css('.reveal.is-visible').styles(raw: {'opacity': '1', 'transform': 'none'}),

  // --- 共通ユーティリティ ---
  css('.container').styles(
    width: 100.percent,
    maxWidth: 1152.px,
    margin: Margin.symmetric(horizontal: Unit.auto),
    padding: Padding.symmetric(horizontal: 1.rem),
  ),
  css('.btn').styles(
    display: Display.inlineFlex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.5.rem),
    padding: Padding.symmetric(horizontal: 1.5.rem, vertical: 0.75.rem),
    radius: BorderRadius.circular(9999.px),
    fontWeight: FontWeight.w500,
    raw: {'transition': 'opacity .3s, background-color .3s, transform .3s'},
  ),
  css('.btn-primary').styles(
    backgroundColor: colorAccent,
    color: Colors.white,
  ),
  css('.btn-primary:hover').styles(raw: {'opacity': '0.9'}),
  css('.btn-outline').styles(
    border: Border.all(style: BorderStyle.solid, color: colorBorder, width: 1.px),
    color: colorText,
  ),
  css('.btn-outline:hover').styles(backgroundColor: colorSurface),
  css('.tag').styles(
    display: Display.inlineBlock,
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    radius: BorderRadius.circular(9999.px),
    fontSize: 0.75.rem,
    raw: {
      'background-color': 'color-mix(in srgb, var(--color-accent) 10%, transparent)',
      'color': 'var(--color-accent)',
    },
  ),
  css('.card').styles(
    backgroundColor: colorSurface,
    border: Border.all(style: BorderStyle.solid, color: colorBorder, width: 1.px),
    radius: BorderRadius.circular(12.px),
    raw: {'overflow': 'hidden', 'transition': 'border-color .3s, box-shadow .3s, transform .3s'},
  ),

  // ページ共通の見出し（各ページの .container 内で使用。水平パディングは
  // .container 側が持つので縦のみ。上 8rem で固定ナビを避ける）
  css('.page-head').styles(raw: {'padding': '8rem 0 4rem'}),
  css('.page-title').styles(
    color: colorText,
    fontWeight: FontWeight.bold,
    raw: {'font-size': 'clamp(2.2rem,6vw,3.2rem)', 'letter-spacing': '-0.02em', 'margin': '0'},
  ),
  css('.page-note').styles(color: colorTextMuted, raw: {'margin-top': '0.75rem'}),

  // --- Markdown 本文スタイル（blog 記事用） ---
  ...markdownStyles,
];

/// `.markdown-body` 配下の記事本文スタイル。
final List<StyleRule> markdownStyles = [
  css('.markdown-body').styles(
    color: colorText,
    lineHeight: 1.85.em,
    raw: {'font-size': '1.02rem'},
  ),
  css('.markdown-body h2').styles(
    fontSize: 1.6.rem,
    fontWeight: FontWeight.bold,
    raw: {'margin': '2.4rem 0 1rem', 'padding-bottom': '0.4rem', 'border-bottom': '1px solid var(--color-border)'},
  ),
  css('.markdown-body h3').styles(
    fontSize: 1.3.rem,
    fontWeight: FontWeight.w600,
    raw: {'margin': '2rem 0 0.8rem'},
  ),
  css('.markdown-body h4').styles(
    fontSize: 1.1.rem,
    fontWeight: FontWeight.w600,
    raw: {'margin': '1.6rem 0 0.6rem'},
  ),
  css('.markdown-body p').styles(raw: {'margin': '1rem 0'}),
  css('.markdown-body a').styles(
    color: colorAccent,
    raw: {'text-decoration': 'underline', 'text-underline-offset': '2px'},
  ),
  css('.markdown-body ul, .markdown-body ol').styles(raw: {'margin': '1rem 0', 'padding-left': '1.5rem'}),
  css('.markdown-body ul').styles(raw: {'list-style': 'disc'}),
  css('.markdown-body ol').styles(raw: {'list-style': 'decimal'}),
  css('.markdown-body li').styles(raw: {'margin': '0.4rem 0'}),
  css('.markdown-body blockquote').styles(
    backgroundColor: colorSurface,
    color: colorTextMuted,
    raw: {
      'margin': '1.2rem 0',
      'padding': '0.4rem 1rem',
      'border-left': '3px solid var(--color-accent)',
      'border-radius': '0 6px 6px 0',
    },
  ),
  css('.markdown-body code').styles(raw: {
    'background': 'var(--color-surface)',
    'border': '1px solid var(--color-border)',
    'border-radius': '4px',
    'padding': '0.1rem 0.4rem',
    'font-size': '0.9em',
    'font-family': 'ui-monospace, SFMono-Regular, Menlo, Consolas, monospace',
  }),
  css('.markdown-body pre').styles(raw: {
    'margin': '1.4rem 0',
    'border-radius': '10px',
    'overflow-x': 'auto',
    'border': '1px solid var(--color-border)',
  }),
  css('.markdown-body pre code').styles(raw: {
    'display': 'block',
    'padding': '1rem 1.2rem',
    'background': 'transparent',
    'border': 'none',
    'border-radius': '0',
    'font-size': '0.88rem',
    'line-height': '1.6',
  }),
  css('.markdown-body img').styles(raw: {'max-width': '100%', 'border-radius': '10px', 'margin': '1.4rem 0'}),
  css('.markdown-body table').styles(raw: {'width': '100%', 'border-collapse': 'collapse', 'margin': '1.4rem 0', 'font-size': '0.92rem'}),
  css('.markdown-body th, .markdown-body td').styles(raw: {'border': '1px solid var(--color-border)', 'padding': '0.5rem 0.8rem', 'text-align': 'left'}),
  css('.markdown-body th').styles(raw: {'background': 'var(--color-surface)', 'font-weight': '600'}),
  css('.markdown-body hr').styles(raw: {'margin': '2rem 0', 'border': 'none', 'border-top': '1px solid var(--color-border)'}),
];
