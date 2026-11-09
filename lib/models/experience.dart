/// 経歴タイムラインのタグ。フィルタバーの選択肢にもなる。
enum ExperienceTag {
  hackathon('ハッカソン'),
  circle('サークル'),
  event('イベント'),
  personal('個人開発'),
  talk('講座・登壇'),
  internship('インターン');

  const ExperienceTag(this.label);

  /// 表示ラベル（日本語）。
  final String label;
}

/// フィルタバーに並べるタグ一覧（宣言順）。
const List<ExperienceTag> allExperienceTags = ExperienceTag.values;

/// 経歴タイムラインの1件。
///
/// React 側では `icon` が JSX 要素だったが、実データは全て `Circle` なので
/// アイコン名（`icons.dart` のキー）を文字列で保持する。
class Experience {
  const Experience({
    required this.id,
    required this.title,
    required this.period,
    required this.description,
    required this.tags,
    this.iconName = 'circle',
    this.subtitle,
    this.institution,
    this.image,
    this.link,
  });

  final int id;
  final String title;
  final String period;
  final String description;
  final List<ExperienceTag> tags;
  final String iconName;
  final String? subtitle;
  final String? institution;
  final String? image;
  final String? link;
}
