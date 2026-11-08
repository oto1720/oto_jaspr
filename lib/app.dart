import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';
import 'package:jaspr_router/jaspr_router.dart';

import 'components/navigation.dart';
import 'pages/blog.dart';
import 'pages/contact.dart';
import 'pages/home.dart';
import 'pages/portfolio.dart';
import 'pages/profile.dart';

/// ルートコンポーネント。全ページ共通のナビゲーションと Router を配置する。
/// multi-page routing のため、この App はサーバーの pre-render 時のみ構築され、
/// クライアントでは各ページ（および @client な島）が個別に mount される。
class App extends StatelessComponent {
  const App({super.key});

  @override
  Component build(BuildContext context) {
    return div(classes: 'app', [
      const Navigation(),
      Router(routes: [
        Route(path: '/', title: 'Home | oto', builder: (context, state) => const HomePage()),
        Route(path: '/profile', title: 'Profile | oto', builder: (context, state) => const ProfilePage()),
        Route(path: '/portfolio', title: 'Works | oto', builder: (context, state) => const PortfolioPage()),
        Route(path: '/blog', title: 'Blog | oto', builder: (context, state) => const BlogPage()),
        // NOTE: /blog/:slug はSSGでパスパラメータ非対応のためフェーズ5で
        // 記事ごとに静的Route（/blog/<slug>）を生成して登録する。
        Route(path: '/contact', title: 'Contact | oto', builder: (context, state) => const ContactPage()),
      ]),
    ]);
  }
}
