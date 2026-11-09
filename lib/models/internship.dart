/// インターン詳細モーダル内のリンク。
class DetailLink {
  const DetailLink({required this.label, required this.url});

  final String label;
  final String url;
}

/// インターンの詳細（モーダルに表示）。埋めた会社だけ「詳細を見る」が出る。
class InternshipDetail {
  const InternshipDetail({
    this.overview,
    this.challenge,
    this.work,
    this.techReason,
    this.outcome,
    this.learned,
    this.links,
  });

  /// どんなインターンか。
  final String? overview;

  /// 課題・お題。
  final String? challenge;

  /// やったこと（箇条書き）。
  final List<String>? work;

  /// 技術選定の理由。
  final String? techReason;

  /// 成果（受賞・数値・完成物）。
  final String? outcome;

  /// 学んだこと。
  final String? learned;

  final List<DetailLink>? links;
}

/// インターン・業務経験の1件。
class Internship {
  const Internship({
    required this.company,
    required this.period,
    required this.role,
    required this.description,
    required this.technologies,
    this.image,
    this.detail,
  });

  final String company;
  final String period;
  final String role;
  final String description;
  final List<String> technologies;
  final String? image;
  final InternshipDetail? detail;
}
