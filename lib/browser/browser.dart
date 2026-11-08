// ブラウザ(DOM)アクセスの入口。
// `@client` コンポーネントはサーバー(pre-render)とクライアント両方で
// コンパイルされるため、`package:web` を直接 import せず、
// 条件付き import でサーバーはスタブ、クライアントは実装を使う。
export 'browser_stub.dart' if (dart.library.js_interop) 'browser_web.dart';
