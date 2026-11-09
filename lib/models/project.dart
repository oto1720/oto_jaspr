/// Portfolio の制作物1件。`role` / `challenges` / `learnings` は
/// 詳細モーダルのタブ表示用で、埋まっている作品だけタブが出る。
class Project {
  const Project({
    required this.id,
    required this.title,
    required this.description,
    required this.image,
    required this.technologies,
    required this.github,
    required this.liveDemo,
    this.role,
    this.challenges,
    this.learnings,
  });

  final int id;
  final String title;
  final String description;
  final String image;
  final List<String> technologies;
  final String github;
  final String liveDemo;
  final List<String>? role;
  final List<String>? challenges;
  final List<String>? learnings;
}
