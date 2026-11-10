/// ISO 日付文字列を「YYYY年M月D日」に整形する。
/// React 側の `toLocaleDateString('ja-JP', {year, month, day})` 相当。
/// パースできない場合は元の文字列を返す。
String formatJaDate(String iso) {
  if (iso.isEmpty) return '';
  final d = DateTime.tryParse(iso);
  if (d == null) return iso;
  return '${d.year}年${d.month}月${d.day}日';
}
