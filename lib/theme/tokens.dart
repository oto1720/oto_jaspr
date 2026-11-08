import 'package:jaspr/dom.dart';

/// カラートークン。実体は CSS 変数（`:root` / `.dark`）で定義し、
/// Dart 側はその変数を参照する [Color] として公開する。
/// これにより `theme_toggle` で `<html>` に `.dark` を付け外しするだけで
/// 全体の配色がダーク/ライト切り替わる。
const colorBg = Color('var(--color-bg)');
const colorSurface = Color('var(--color-surface)');
const colorText = Color('var(--color-text)');
const colorTextMuted = Color('var(--color-text-muted)');
const colorAccent = Color('var(--color-accent)');
const colorBorder = Color('var(--color-border)');

/// ライトモードの CSS 変数値。
const lightVars = <String, String>{
  '--color-bg': '#ffffff',
  '--color-surface': '#f5f5f5',
  '--color-text': '#111111',
  '--color-text-muted': '#666666',
  '--color-accent': '#3b82f6',
  '--color-border': '#e5e7eb',
};

/// ダークモードの CSS 変数値。
const darkVars = <String, String>{
  '--color-bg': '#0a0a0a',
  '--color-surface': '#1a1a1a',
  '--color-text': '#f0f0f0',
  '--color-text-muted': '#888888',
  '--color-accent': '#60a5fa',
  '--color-border': '#2a2a2a',
};
