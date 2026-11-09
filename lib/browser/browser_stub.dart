/// サーバー(pre-render)用スタブ。DOM が無いので全て no-op。
bool themeIsDark() => true;

void themeSetDark(bool dark) {}

/// スクロール追従: しきい値を超えたら [onChange] に true を渡す想定。
void initNavScroll(void Function(bool scrolled) onChange, {double threshold = 10}) {}

/// `.reveal` 要素を IntersectionObserver で監視し、可視時に `is-visible` を付与。
void initReveal() {}

/// 背景スクロールのロック/解除（モーダル表示中に使用）。
void setBodyScrollLocked(bool locked) {}

/// Escape キー押下で [handler] を呼ぶ。サーバーでは no-op（解除関数も空）。
void Function() onEscapeKey(void Function() handler) => () {};
