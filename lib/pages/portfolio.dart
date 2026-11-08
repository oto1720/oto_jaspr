import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/layout.dart';

/// 制作物一覧。グリッド + 詳細モーダル（3タブ）。フェーズ4で実装予定。
class PortfolioPage extends StatelessComponent {
  const PortfolioPage({super.key});

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container page-head', [
        h1(classes: 'page-title', [Component.text('Portfolio')]),
        p(classes: 'page-note', [Component.text('制作物一覧（準備中：フェーズ4）')]),
      ]),
    ]);
  }
}
