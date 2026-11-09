/// スキルの習熟度。バッジの色分けに使う。
enum SkillLevel {
  advanced('Advanced'),
  intermediate('Intermediate'),
  beginner('Beginner');

  const SkillLevel(this.label);

  /// バッジに表示するラベル。
  final String label;
}

/// Skills セクションの1件。`image` が無い場合は名前の先頭2文字で代替表示する。
class Skill {
  const Skill({
    required this.name,
    required this.level,
    this.image,
  });

  final String name;
  final SkillLevel level;
  final String? image;
}
