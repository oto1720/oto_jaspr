// dart format off
// ignore_for_file: type=lint

// GENERATED FILE, DO NOT MODIFY
// Generated with jaspr_builder

import 'package:jaspr/client.dart';

import 'package:oto_jaspr/components/navigation.dart' deferred as _navigation;
import 'package:oto_jaspr/components/theme_toggle.dart'
    deferred as _theme_toggle;
import 'package:oto_jaspr/pages/portfolio.dart' deferred as _portfolio;
import 'package:oto_jaspr/pages/profile.dart' deferred as _profile;

/// Default [ClientOptions] for use with your Jaspr project.
///
/// Use this to initialize Jaspr **before** calling [runApp].
///
/// Example:
/// ```dart
/// import 'main.client.options.dart';
///
/// void main() {
///   Jaspr.initializeApp(
///     options: defaultClientOptions,
///   );
///
///   runApp(...);
/// }
/// ```
ClientOptions get defaultClientOptions => ClientOptions(
  clients: {
    'navigation': ClientLoader(
      (p) => _navigation.Navigation(),
      loader: _navigation.loadLibrary,
    ),
    'theme_toggle': ClientLoader(
      (p) => _theme_toggle.ThemeToggle(),
      loader: _theme_toggle.loadLibrary,
    ),
    'portfolio': ClientLoader(
      (p) => _portfolio.PortfolioPage(),
      loader: _portfolio.loadLibrary,
    ),
    'profile': ClientLoader(
      (p) => _profile.ProfilePage(),
      loader: _profile.loadLibrary,
    ),
  },
);
