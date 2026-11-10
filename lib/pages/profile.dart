import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/layout.dart';
import '../components/modal.dart';
import '../data/awards.dart';
import '../data/experiences.dart';
import '../data/internships.dart';
import '../data/skills.dart';
import '../models/experience.dart';
import '../models/internship.dart';
import '../models/skill.dart';

/// プロフィール（island）。Skills / インターン（詳細モーダル）/ 受賞 /
/// タイムライン（タグフィルタ・左右交互レイアウト）。
@client
class ProfilePage extends StatefulComponent {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();

  @css
  static List<StyleRule> get styles => _profileStyles;
}

class _ProfilePageState extends State<ProfilePage> {
  ExperienceTag? _tag;
  Internship? _openIntern;

  List<Experience> get _sorted =>
      [...experiences]..sort((x, y) => y.id.compareTo(x.id));

  List<Experience> get _filtered => _tag == null
      ? _sorted
      : _sorted.where((e) => e.tags.contains(_tag)).toList();

  void _selectTag(ExperienceTag? tag) => setState(() => _tag = tag);
  void _closeIntern() => setState(() => _openIntern = null);

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container', [
        div(classes: 'page-head', [
          h1(classes: 'page-title', [Component.text('Profile')]),
        ]),
        _skillsSection(),
        _internSection(),
        _awardsSection(),
        _timelineSection(),
      ]),
      if (_openIntern?.detail != null)
        Modal(
          onClose: _closeIntern,
          align: ModalAlign.start,
          panelClasses: 'intern-modal',
          child: _internDetail(_openIntern!),
        ),
    ]);
  }

  // --- Skills ---
  Component _skillsSection() {
    return section(classes: 'profile-section', [
      h2(classes: 'profile-heading', [icon('code', size: 24), Component.text('Skills')]),
      div(classes: 'skills-grid', [
        for (final skill in skills) _skillCard(skill),
      ]),
    ]);
  }

  Component _skillCard(Skill skill) {
    return div(classes: 'skill-card', [
      if (skill.image != null)
        img(src: skill.image!, alt: skill.name, classes: 'skill-img')
      else
        div(classes: 'skill-placeholder', [
          Component.text(skill.name.length >= 2 ? skill.name.substring(0, 2) : skill.name),
        ]),
      span(classes: 'skill-name', [Component.text(skill.name)]),
      span(classes: 'skill-badge ${skill.level.name}', [Component.text(skill.level.label)]),
    ]);
  }

  // --- Internships ---
  Component _internSection() {
    return section(classes: 'profile-section', [
      h2(classes: 'profile-heading', [icon('building-2', size: 24), Component.text('インターン・業務経験')]),
      div(classes: 'intern-grid', [
        for (final intern in internships) _internCard(intern),
      ]),
    ]);
  }

  Component _internCard(Internship intern) {
    return div(classes: 'intern-card card', [
      if (intern.image != null)
        img(src: intern.image!, alt: intern.company, classes: 'intern-img', attributes: {'loading': 'lazy', 'decoding': 'async'}),
      div(classes: 'intern-body', [
        div(classes: 'intern-top', [
          span(classes: 'intern-company', [Component.text(intern.company)]),
          span(classes: 'intern-period', [Component.text(intern.period)]),
        ]),
        p(classes: 'intern-role', [Component.text(intern.role)]),
        if (intern.description.isNotEmpty)
          p(classes: 'intern-desc', [Component.text(intern.description)]),
        div(classes: 'proj-tags', [
          for (final tech in intern.technologies) span(classes: 'tag', [Component.text(tech)]),
        ]),
        if (intern.detail != null)
          button(
            classes: 'intern-more',
            onClick: () => setState(() => _openIntern = intern),
            [Component.text('詳細を見る'), icon('arrow-right', size: 16)],
          ),
      ]),
    ]);
  }

  Component _internDetail(Internship intern) {
    final d = intern.detail!;
    return div(classes: 'intern-detail', [
      if (intern.image != null)
        img(src: intern.image!, alt: intern.company, classes: 'intern-detail-img'),
      div(classes: 'intern-detail-body', [
        div(classes: 'intern-top', [
          h3(classes: 'intern-detail-company', [Component.text(intern.company)]),
          span(classes: 'intern-period', [Component.text(intern.period)]),
        ]),
        p(classes: 'intern-role', [Component.text(intern.role)]),
        div(classes: 'proj-tags intern-detail-tags', [
          for (final tech in intern.technologies) span(classes: 'tag', [Component.text(tech)]),
        ]),
        if (d.overview != null) _detailBlock('概要', d.overview!),
        if (d.challenge != null) _detailBlock('課題・お題', d.challenge!),
        if (d.work?.isNotEmpty ?? false) ...[
          h4(classes: 'detail-label', [Component.text('やったこと')]),
          ul(classes: 'detail-bullets', [
            for (final w in d.work!)
              li([span(classes: 'detail-dot', const []), span([Component.text(w)])]),
          ]),
        ],
        if (d.techReason != null) _detailBlock('技術選定の理由', d.techReason!),
        if (d.outcome != null) _detailBlock('成果', d.outcome!),
        if (d.learned != null) _detailBlock('学んだこと', d.learned!),
        if (d.links?.isNotEmpty ?? false)
          div(classes: 'detail-links', [
            for (final l in d.links!)
              a(href: l.url, target: Target.blank, classes: 'detail-link', attributes: {'rel': 'noopener noreferrer'}, [
                Component.text(l.label),
                icon('arrow-right', size: 14),
              ]),
          ]),
      ]),
    ]);
  }

  Component _detailBlock(String label, String text) {
    return div(classes: 'detail-block', [
      h4(classes: 'detail-label', [Component.text(label)]),
      p(classes: 'detail-text', [Component.text(text)]),
    ]);
  }

  // --- Awards ---
  Component _awardsSection() {
    return section(classes: 'profile-section', [
      h2(classes: 'profile-heading', [icon('trophy', size: 24), Component.text('実績・受賞歴')]),
      div(classes: 'awards-grid', [
        for (final award in awards)
          div(classes: 'award-card', [
            div(classes: 'award-bar', const []),
            div(classes: 'award-body', [
              span(classes: 'award-event', [Component.text(award.event)]),
              span(classes: 'award-prize', [Component.text(award.prize)]),
            ]),
          ]),
      ]),
    ]);
  }

  // --- Timeline ---
  Component _timelineSection() {
    return section(classes: 'profile-section', [
      h2(classes: 'profile-heading', [icon('briefcase', size: 24), Component.text('経歴紹介')]),
      div(classes: 'tl-filter', [
        _filterButton(null, 'すべて'),
        for (final tag in allExperienceTags) _filterButton(tag, tag.label),
      ]),
      div(classes: 'timeline', [
        div(classes: 'tl-line', const []),
        for (var i = 0; i < _filtered.length; i++) _timelineItem(_filtered[i], i),
      ]),
    ]);
  }

  Component _filterButton(ExperienceTag? tag, String label) {
    final active = _tag == tag;
    return button(
      classes: active ? 'tl-chip active' : 'tl-chip',
      onClick: () => _selectTag(tag),
      [Component.text(label)],
    );
  }

  Component _timelineItem(Experience item, int index) {
    final side = index.isEven ? 'even' : 'odd';
    final inner = [
      if (item.image != null)
        img(src: item.image!, alt: item.title, classes: 'tl-img', attributes: {'loading': 'lazy', 'decoding': 'async'}),
      h3(classes: 'tl-title', [Component.text(item.title)]),
      if (item.subtitle != null || item.institution != null)
        p(classes: 'tl-sub', [Component.text(item.subtitle ?? item.institution ?? '')]),
      p(classes: 'tl-period', [Component.text(item.period)]),
      p(classes: 'tl-desc', [Component.text(item.description)]),
    ];
    return div(classes: 'tl-item $side', [
      div(classes: 'tl-node', [icon(item.iconName, size: 20)]),
      if (item.link != null)
        a(href: item.link!, target: Target.blank, classes: 'tl-card', attributes: {'rel': 'noopener noreferrer'}, inner)
      else
        div(classes: 'tl-card', inner),
    ]);
  }
}

final List<StyleRule> _profileStyles = [
  css('.profile-section').styles(raw: {'margin-bottom': '6rem'}),
  css('.profile-heading').styles(
    display: Display.flex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.75.rem),
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.w600,
    raw: {'font-size': 'clamp(1.5rem,4vw,1.875rem)', 'margin': '0 0 2rem'},
  ),
  css('.profile-heading .icon').styles(color: Color('var(--color-accent)')),

  // Skills
  css('.skills-grid').styles(
    display: Display.grid,
    gap: Gap.all(1.rem),
    raw: {'grid-template-columns': 'repeat(2, minmax(0,1fr))'},
  ),
  css.media(MediaQuery.screen(minWidth: 640.px), [
    css('.skills-grid').styles(raw: {'grid-template-columns': 'repeat(3, minmax(0,1fr))'}),
  ]),
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.skills-grid').styles(raw: {'grid-template-columns': 'repeat(4, minmax(0,1fr))'}),
  ]),
  css.media(MediaQuery.screen(minWidth: 1024.px), [
    css('.skills-grid').styles(raw: {'grid-template-columns': 'repeat(6, minmax(0,1fr))'}),
  ]),
  css('.skill-card').styles(
    display: Display.flex,
    flexDirection: FlexDirection.column,
    alignItems: AlignItems.center,
    gap: Gap.all(0.5.rem),
    padding: Padding.all(1.rem),
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    raw: {'transition': 'border-color .3s'},
  ),
  css('.skill-card:hover').styles(raw: {'border-color': 'var(--color-accent)'}),
  css('.skill-img').styles(width: 3.rem, height: 3.rem, raw: {'object-fit': 'contain', 'border-radius': '8px'}),
  css('.skill-placeholder').styles(
    width: 3.rem,
    height: 3.rem,
    display: Display.flex,
    alignItems: AlignItems.center,
    justifyContent: JustifyContent.center,
    color: Color('var(--color-text-muted)'),
    radius: BorderRadius.circular(8.px),
    fontWeight: FontWeight.bold,
    raw: {'background-color': 'var(--color-bg)', 'font-size': '1.1rem'},
  ),
  css('.skill-name').styles(color: Color('var(--color-text)'), raw: {'font-size': '0.75rem', 'font-weight': '500', 'text-align': 'center'}),
  css('.skill-badge').styles(
    radius: BorderRadius.circular(9999.px),
    padding: Padding.symmetric(horizontal: 0.5.rem, vertical: 0.125.rem),
    fontWeight: FontWeight.w600,
    raw: {'font-size': '10px'},
  ),
  css('.skill-badge.advanced').styles(backgroundColor: Color('var(--color-accent)'), color: Colors.white),
  css('.skill-badge.intermediate').styles(backgroundColor: Color('#3b82f6'), color: Colors.white),
  css('.skill-badge.beginner').styles(
    color: Color('var(--color-text-muted)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    raw: {'background-color': 'var(--color-surface)'},
  ),

  // Internships
  css('.intern-grid').styles(
    display: Display.grid,
    gap: Gap.all(1.rem),
    raw: {'grid-template-columns': 'repeat(1, minmax(0,1fr))'},
  ),
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.intern-grid').styles(raw: {'grid-template-columns': 'repeat(2, minmax(0,1fr))'}),
  ]),
  css('.intern-card').styles(raw: {'border-radius': '16px'}),
  css('.intern-card:hover').styles(raw: {'border-color': 'var(--color-accent)', 'box-shadow': '0 10px 15px -3px rgba(0,0,0,0.12)'}),
  css('.intern-img').styles(width: 100.percent, raw: {'height': '10rem', 'object-fit': 'cover'}),
  css('.intern-body').styles(padding: Padding.all(1.25.rem)),
  css('.intern-top').styles(display: Display.flex, alignItems: AlignItems.center, justifyContent: JustifyContent.spaceBetween, raw: {'margin-bottom': '0.5rem', 'gap': '0.75rem'}),
  css('.intern-company').styles(color: Color('var(--color-text)'), fontWeight: FontWeight.w600, raw: {'font-size': '1rem'}),
  css('.intern-period').styles(color: Color('var(--color-accent)'), fontWeight: FontWeight.w500, raw: {'font-size': '0.75rem', 'white-space': 'nowrap'}),
  css('.intern-role').styles(color: Color('var(--color-text-muted)'), fontWeight: FontWeight.w500, raw: {'font-size': '0.875rem', 'margin': '0 0 0.5rem'}),
  css('.intern-desc').styles(color: Color('var(--color-text-muted)'), raw: {'font-size': '0.875rem', 'margin': '0 0 0.75rem'}),
  css('.intern-more').styles(
    display: Display.inlineFlex,
    alignItems: AlignItems.center,
    gap: Gap.all(0.25.rem),
    color: Color('var(--color-accent)'),
    backgroundColor: Colors.transparent,
    border: Border.unset,
    fontWeight: FontWeight.w500,
    raw: {'font-size': '0.875rem', 'margin-top': '1rem', 'padding': '0'},
  ),

  // Internship detail modal
  css('.intern-modal').styles(raw: {'max-width': '42rem'}),
  css('.intern-detail-img').styles(width: 100.percent, raw: {'height': '14rem', 'object-fit': 'cover', 'border-radius': '12px 12px 0 0'}),
  css('.intern-detail-body').styles(padding: Padding.all(2.rem)),
  css('.intern-detail-company').styles(color: Color('var(--color-text)'), fontWeight: FontWeight.bold, raw: {'font-size': '1.4rem', 'margin': '0'}),
  css('.intern-detail-tags').styles(raw: {'margin': '0 0 1.5rem'}),
  css('.detail-block').styles(raw: {'margin-bottom': '1.25rem'}),
  css('.detail-label').styles(color: Color('var(--color-accent)'), fontWeight: FontWeight.w600, raw: {'font-size': '0.875rem', 'margin': '1.25rem 0 0.5rem'}),
  css('.detail-text').styles(color: Color('var(--color-text)'), raw: {'font-size': '0.875rem', 'line-height': '1.7', 'margin': '0', 'white-space': 'pre-line'}),
  css('.detail-bullets').styles(raw: {'list-style': 'none', 'margin': '0', 'padding': '0'}),
  css('.detail-bullets li').styles(display: Display.flex, gap: Gap.all(0.5.rem), color: Color('var(--color-text)'), raw: {'align-items': 'flex-start', 'font-size': '0.875rem', 'margin': '0.4rem 0', 'line-height': '1.6'}),
  css('.detail-dot').styles(width: 6.px, height: 6.px, radius: BorderRadius.circular(9999.px), raw: {'background-color': 'var(--color-accent)', 'flex-shrink': '0', 'margin-top': '0.45rem'}),
  css('.detail-links').styles(display: Display.flex, gap: Gap.all(0.5.rem), raw: {'flex-wrap': 'wrap', 'padding-top': '0.25rem'}),
  css('.detail-link').styles(display: Display.inlineFlex, alignItems: AlignItems.center, gap: Gap.all(0.25.rem), color: Color('var(--color-accent)'), fontWeight: FontWeight.w500, raw: {'font-size': '0.875rem', 'text-decoration': 'underline'}),

  // Awards
  css('.awards-grid').styles(display: Display.grid, gap: Gap.all(1.rem), raw: {'grid-template-columns': 'repeat(1, minmax(0,1fr))'}),
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.awards-grid').styles(raw: {'grid-template-columns': 'repeat(2, minmax(0,1fr))'}),
  ]),
  css('.award-card').styles(
    display: Display.flex,
    gap: Gap.all(1.rem),
    padding: Padding.all(1.25.rem),
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(16.px),
    raw: {'transition': 'border-color .3s, box-shadow .3s'},
  ),
  css('.award-card:hover').styles(raw: {'border-color': 'var(--color-accent)', 'box-shadow': '0 10px 15px -3px rgba(0,0,0,0.12)'}),
  css('.award-bar').styles(width: 4.px, radius: BorderRadius.circular(9999.px), raw: {'background-color': 'var(--color-accent)', 'flex-shrink': '0'}),
  css('.award-body').styles(display: Display.flex, flexDirection: FlexDirection.column, gap: Gap.all(0.75.rem), raw: {'min-width': '0'}),
  css('.award-event').styles(color: Color('var(--color-text)'), fontWeight: FontWeight.w600, raw: {'font-size': '1rem', 'line-height': '1.4'}),
  css('.award-prize').styles(
    color: Colors.white,
    backgroundColor: Color('var(--color-accent)'),
    radius: BorderRadius.circular(9999.px),
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.375.rem),
    fontWeight: FontWeight.bold,
    raw: {'font-size': '0.875rem', 'align-self': 'flex-start'},
  ),

  // Timeline
  css('.tl-filter').styles(display: Display.flex, gap: Gap.all(0.5.rem), raw: {'flex-wrap': 'wrap', 'margin-bottom': '3rem'}),
  css('.tl-chip').styles(
    color: Color('var(--color-text-muted)'),
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(9999.px),
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.375.rem),
    fontWeight: FontWeight.w500,
    raw: {'font-size': '0.875rem', 'transition': 'all .2s'},
  ),
  css('.tl-chip:hover').styles(raw: {'border-color': 'var(--color-accent)', 'color': 'var(--color-text)'}),
  css('.tl-chip.active').styles(raw: {'background-color': 'var(--color-accent)', 'color': '#fff', 'border-color': 'var(--color-accent)'}),
  css('.timeline').styles(position: Position.relative(), raw: {'animation': 'fadeInUp .4s ease'}),
  css('.tl-line').styles(
    position: Position.absolute(top: Unit.zero, left: Unit.zero),
    raw: {'height': '100%', 'width': '1px', 'background-color': 'var(--color-border)'},
  ),
  css('.tl-item').styles(position: Position.relative(), raw: {'margin-bottom': '3rem', 'padding-left': '3.5rem'}),
  css('.tl-node').styles(
    position: Position.absolute(top: Unit.zero, left: Unit.zero),
    width: 2.5.rem,
    height: 2.5.rem,
    display: Display.flex,
    alignItems: AlignItems.center,
    justifyContent: JustifyContent.center,
    radius: BorderRadius.circular(9999.px),
    color: Color('var(--color-accent)'),
    raw: {'background-color': 'var(--color-bg)', 'border': '2px solid var(--color-accent)'},
  ),
  css('.tl-card').styles(
    display: Display.block,
    backgroundColor: Color('var(--color-surface)'),
    border: Border.all(style: BorderStyle.solid, color: Color('var(--color-border)'), width: 1.px),
    radius: BorderRadius.circular(12.px),
    padding: Padding.all(1.25.rem),
    raw: {'transition': 'border-color .3s'},
  ),
  css('.tl-card:hover').styles(raw: {'border-color': 'var(--color-accent)'}),
  css('.tl-img').styles(width: 100.percent, raw: {'height': '9rem', 'object-fit': 'cover', 'border-radius': '8px', 'margin-bottom': '1rem'}),
  css('.tl-title').styles(color: Color('var(--color-text)'), fontWeight: FontWeight.w600, raw: {'font-size': '1.125rem', 'margin': '0'}),
  css('.tl-sub').styles(color: Color('var(--color-text-muted)'), raw: {'font-size': '0.875rem', 'margin': '0.25rem 0 0'}),
  css('.tl-period').styles(color: Color('var(--color-accent)'), fontWeight: FontWeight.w500, raw: {'font-size': '0.75rem', 'margin': '0.25rem 0 0.75rem'}),
  css('.tl-desc').styles(color: Color('var(--color-text)'), raw: {'font-size': '0.875rem', 'margin': '0'}),
  // デスクトップ: 中央線 + 左右交互
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.tl-line').styles(raw: {'left': '50%', 'transform': 'translateX(-50%)'}),
    css('.tl-item').styles(raw: {'width': '50%', 'padding-left': '0'}),
    css('.tl-item.even').styles(raw: {'margin-left': 'auto', 'padding-left': '3rem'}),
    css('.tl-item.odd').styles(raw: {'padding-right': '3rem'}),
    css('.tl-item.even .tl-node').styles(raw: {'left': '-1.25rem'}),
    css('.tl-item.odd .tl-node').styles(raw: {'left': 'auto', 'right': '-1.25rem'}),
  ]),
];
