import '../models/internship.dart';

/// インターン・業務経験（Profile）。`detail` を持つものだけ詳細モーダルを開ける。
const List<Internship> internships = [
  Internship(
    company: '株式会社サイバーエージェント',
    period: '2026年3月',
    role: 'CA Tech Dojo - Android エンジニア（1week インターン）',
    description:
        'Android開発をテーマに、1週間で1人でアプリを開発・リリースできるようになることを目指す育成型インターン。設計を第一に据え、AIを活用した開発スタイルを実践し、最優秀賞を獲得。',
    technologies: ['Kotlin', 'Jetpack Compose', 'Room', 'Qiita API', 'Gemini API'],
    image: '/assets/images/cainternandroid.png',
    detail: InternshipDetail(
      overview:
          'サイバーエージェント主催の学生向け育成型インターン。「Android開発をテーマに、1週間でアプリ開発の基礎スキルを身につける」ことが目的で、全体ゴールは「1人でアプリを開発しリリースできるようになる」こと。',
      challenge:
          'お題は「コンテンツポータルアプリ」。ここから、技術記事の「読んだつもり」をなくす“理解完了アプリ”を企画・開発した。',
      work: [
        'ポータル画面：Qiita API からトレンド記事を取得して一覧表示',
        '積読リスト画面：Gemini API で記事を要約し、積んだ記事を管理',
        '消化フロー：AI が記事内容に即した問いを生成し、理解度をチェック',
        '完了リスト画面：消化し切った記事を蓄積',
        'データ管理は Room + Repository 層、状態管理は Flow、ViewModel 中心のアーキテクチャで構築',
      ],
      techReason:
          '「設計を第一に考える」方針で、公式のベストプラクティスを参考にアーキテクチャを構築。AI活用では「テスト駆動AI開発」「仕様駆動開発」を取り入れ、AIに任せる部分と自分が責任を持つ部分を明確に分けて進めた。',
      outcome: '参加者の中で最優秀賞を獲得。',
      learned:
          'ネイティブアプリ開発ならではの考え方や設計を学べた。Figma MCP を使ったUI開発では開発のスピードと精度が大きく変わる可能性を感じ、AIを活用したこれからの開発スタイルを考える良いきっかけになった。',
      links: [
        DetailLink(
          label: '参加記（Qiita）',
          url: 'https://qiita.com/oto1720/items/910598fe80cf49739317',
        ),
      ],
    ),
  ),
  Internship(
    company: 'TrueNest',
    period: '2026年4-7月',
    role: '兄の会社の業務委託（サイトのシステム作り）',
    description:
        'レンタルスペース事業を行う兄の会社でのレンタルスペースの予約サイトのシステム作りを行った。要件定義、設計、実装、テスト、デプロイ、運用までを担当。',
    technologies: ['React', 'TypeScript', 'echo', 'Go', 'PostgreSQL', 'Neon', 'Docker', 'Cloud Run'],
    image: '/assets/images/truenest.png',
    detail: InternshipDetail(
      overview:
          'レンタルスペース事業を営む兄の会社から業務委託を受け、予約サイトを個人で一気通貫で開発。要件定義から運用までを一人で担当した。',
      challenge:
          '実際に事業で使う予約システムを、実運用に耐える品質・コストで構築する必要があった。空き状況の管理や予約フローの整合性が要件の中心。',
      work: [
        '事業側とヒアリングして要件定義・画面設計を実施',
        'フロントを React + TypeScript、バックエンドを Go（echo）で REST API として実装',
        'PostgreSQL（Neon）でデータ設計、予約・空き状況を管理',
        'Docker でコンテナ化し、Cloud Run にデプロイして運用まで担当',
      ],
      techReason:
          'Go（echo）は軽量で起動が速く Cloud Run のスケール・課金と相性が良いため採用。DB はサーバーレスでコストを抑えられる Neon を選び、個人運用でも管理負荷を最小化した。',
      outcome: '要件定義から実装・デプロイ・運用まで一人で完了し、実事業で稼働するシステムを構築した。',
      learned:
          '個人で全工程を担うことで、技術選定をコスト・運用まで含めて判断する力がついた。事業要件を仕様に落とし込む難しさも学んだ。',
    ),
  ),
  Internship(
    company: '株式会社サイバーエージェント',
    period: '2026年8月',
    role: 'CA Job Lite - Flutter エンジニア（2week インターン）',
    description:
        '大規模プロダクト開発チームに2週間配属され、実務のアジャイル開発フローで機能開発を担当。実務と学生開発の差を1日1個ずつ言語化し、成長の道標を持ち帰った。',
    technologies: ['Flutter', 'Dart', 'Riverpod', 'flutter_hooks', 'Freezed', 'Melos'],
    image: '/assets/images/cainternflutter.png',
    detail: InternshipDetail(
      overview:
          '現場の大規模プロダクト開発チームに2週間配属される実務型インターン。実際のアジャイル開発フロー（チケット → Draft PR → CI・VRT → 多視点レビュー → マージ＝リリース）に入って機能開発を担当した。目標は「実務と自分の経験の差を1日1個探し、成長の道標を3つ立てて持ち帰る」こと。',
      challenge:
          '既存の大規模プロダクトを理解した上で、実運用の品質基準（小さい単位のPR・多視点レビュー・自動テスト / VRT）に沿って機能を実装しきること。',
      work: [
        '機能追加のPRを複数出し、うち一つをレビュー往復を経てマージ・リリースまで到達させた',
        '影響範囲の大きい共通基盤には手を入れず機能側で実装するなど、影響範囲を意識した設計判断を行った',
        'APIのデータを表示用のモデルに再構成し、UI層に結合ロジックを散らさない設計にした',
        '分岐ロジックを enum に集約してユニットテストを追加するなど、判断ロジックを一箇所にまとめた',
        'Feature Flag を前提に、段階的リリース・切り戻しを織り込んで実装した',
      ],
      techReason:
          '状態管理は Riverpod + flutter_hooks、モデルは Freezed、モノレポ管理は Melos。「動く」は前提として「なぜこの形にしたか」を説明できる状態を重視して設計した。',
      outcome:
          '複数のPRを出し、人間とAIによる多視点レビューの往復を経て一つをマージ・リリースまで到達。実務と学生開発の差を12個言語化し、成長の道標を3本立てて持ち帰った。',
      learned:
          '一番の学びは「実装はタスクの一部でしかない」こと。要件の背景理解・レビュー往復・将来の変更（Feature Flag / Legacy 切り）まで含めて見積もる必要があると実感した。また、判断を記録に残す（design doc・PR説明・コミット）のは丁寧さではなく、自分がいなくても引き継げるための成立要件だと学んだ。2週間の見積もりの甘さも痛感し、限られた期間で何を学ぶかを最優先に据えるシフトチェンジの重要性に気づいた。',
    ),
  ),
  Internship(
    company: '株式会社MIXI',
    period: '2026年9-10月',
    role: 'Dive into MIXI インターン androidエンジニア',
    description: '',
    technologies: ['Android'],
    image: '/assets/images/mixi.webp',
  ),
];
