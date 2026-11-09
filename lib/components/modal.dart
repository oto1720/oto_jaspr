import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../browser/browser.dart';
import 'icons.dart';

/// 共用モーダル（Portfolio / Profile で使用）。
///
/// 開閉 state は親 island が持ち、表示中だけこのコンポーネントを描画する。
/// マウント中は背景スクロールをロックし、ESC キーで閉じる。親が island なので
/// ここの [State] ライフサイクルはクライアントで走る。
/// framer-motion の `AnimatePresence` 相当の出入りは CSS アニメーションで近似。
class Modal extends StatefulComponent {
  const Modal({
    required this.onClose,
    required this.child,
    this.panelClasses,
    this.align = ModalAlign.center,
    super.key,
  });

  /// 背景クリック・閉じるボタン・ESC で呼ばれる。
  final void Function() onClose;

  /// パネル内に描画する中身。
  final Component child;

  /// パネルに追加するクラス（最大幅の調整など）。
  final String? panelClasses;

  /// パネルの縦位置。長い内容は [ModalAlign.start] でスクロール可能にする。
  final ModalAlign align;

  @override
  State<Modal> createState() => _ModalState();

  @css
  static List<StyleRule> get styles => _modalStyles;
}

enum ModalAlign { center, start }

class _ModalState extends State<Modal> {
  void Function()? _removeEsc;

  @override
  void initState() {
    super.initState();
    if (kIsWeb) {
      setBodyScrollLocked(true);
      _removeEsc = onEscapeKey(component.onClose);
    }
  }

  @override
  void dispose() {
    if (kIsWeb) {
      setBodyScrollLocked(false);
      _removeEsc?.call();
    }
    super.dispose();
  }

  @override
  Component build(BuildContext context) {
    final overlayClass =
        component.align == ModalAlign.start ? 'modal-overlay start' : 'modal-overlay';
    final panelClass =
        'modal-panel${component.panelClasses != null ? ' ${component.panelClasses}' : ''}';
    return div(classes: overlayClass, [
      div(
        classes: 'modal-backdrop',
        events: events(onClick: component.onClose),
        const [],
      ),
      div(
        classes: panelClass,
        attributes: {'role': 'dialog', 'aria-modal': 'true'},
        [
          button(
            classes: 'modal-close',
            attributes: {'aria-label': '閉じる'},
            onClick: component.onClose,
            [icon('x', size: 20)],
          ),
          component.child,
        ],
      ),
    ]);
  }
}

final List<StyleRule> _modalStyles = [
  css('.modal-overlay').styles(
    position: Position.fixed(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
    zIndex: ZIndex(50),
    display: Display.flex,
    alignItems: AlignItems.center,
    justifyContent: JustifyContent.center,
    padding: Padding.all(1.rem),
    raw: {'animation': 'modalFade .25s ease'},
  ),
  css('.modal-overlay.start').styles(
    alignItems: AlignItems.start,
    raw: {'overflow-y': 'auto'},
  ),
  css('.modal-backdrop').styles(
    position: Position.absolute(top: Unit.zero, left: Unit.zero, right: Unit.zero, bottom: Unit.zero),
    raw: {
      'background-color': 'rgba(0,0,0,0.6)',
      'backdrop-filter': 'blur(4px)',
      '-webkit-backdrop-filter': 'blur(4px)',
    },
  ),
  css('.modal-panel').styles(
    position: Position.relative(),
    zIndex: ZIndex(10),
    width: 100.percent,
    maxWidth: 56.rem,
    backgroundColor: Color('var(--color-bg)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    raw: {
      'max-height': '90vh',
      'overflow-y': 'auto',
      'box-shadow': '0 25px 50px -12px rgba(0,0,0,0.5)',
      'animation': 'modalPop .25s cubic-bezier(0.34,1.56,0.64,1)',
    },
  ),
  css('.modal-overlay.start .modal-panel').styles(
    raw: {'margin': 'auto', 'max-height': 'none'},
  ),
  css('.modal-close').styles(
    position: Position.absolute(top: 1.rem, right: 1.rem),
    zIndex: ZIndex(10),
    display: Display.flex,
    alignItems: AlignItems.center,
    justifyContent: JustifyContent.center,
    padding: Padding.all(0.5.rem),
    radius: BorderRadius.circular(9999.px),
    color: Color('var(--color-text)'),
    border: Border.unset,
    raw: {'background-color': 'var(--color-surface)', 'transition': 'background-color .3s'},
  ),
  css('.modal-close:hover').styles(backgroundColor: Color('var(--color-border)')),
  css.keyframes('modalFade', {
    'from': Styles(raw: {'opacity': '0'}),
    'to': Styles(raw: {'opacity': '1'}),
  }),
  css.keyframes('modalPop', {
    'from': Styles(raw: {'opacity': '0', 'transform': 'scale(0.92) translateY(20px)'}),
    'to': Styles(raw: {'opacity': '1', 'transform': 'none'}),
  }),
];
