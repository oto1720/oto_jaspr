// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/server.dart';
import 'package:oto_jaspr/components/layout.dart' as _layout;
import 'package:oto_jaspr/components/modal.dart' as _modal;
import 'package:oto_jaspr/components/navigation.dart' as _navigation;
import 'package:oto_jaspr/components/page_transition.dart' as _page_transition;
import 'package:oto_jaspr/components/theme_toggle.dart' as _theme_toggle;
import 'package:oto_jaspr/pages/contact.dart' as _contact;
import 'package:oto_jaspr/pages/home.dart' as _home;
import 'package:oto_jaspr/pages/portfolio.dart' as _portfolio;
import 'package:oto_jaspr/pages/profile.dart' as _profile;

/// Default [ServerOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.server.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultServerOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ServerOptions get defaultServerOptions => ServerOptions(
  clientId: 'main.client.dart.js',
  clients: {
    _navigation.Navigation: ClientTarget<_navigation.Navigation>('navigation'),
    _theme_toggle.ThemeToggle: ClientTarget<_theme_toggle.ThemeToggle>(
      'theme_toggle',
    ),
    _portfolio.PortfolioPage: ClientTarget<_portfolio.PortfolioPage>(
      'portfolio',
    ),
    _profile.ProfilePage: ClientTarget<_profile.ProfilePage>('profile'),
  },
  styles: () => [
    ..._layout.Layout.styles,
    ..._modal.Modal.styles,
    ..._navigation.Navigation.styles,
    ..._page_transition.PageTransition.styles,
    ..._theme_toggle.ThemeToggle.styles,
    ..._contact.ContactPage.styles,
    ..._home.HomePage.styles,
    ..._portfolio.PortfolioPage.styles,
    ..._profile.ProfilePage.styles,
  ],
);
