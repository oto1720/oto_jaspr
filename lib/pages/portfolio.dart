import 'package:jaspr/dom.dart';
import 'package:jaspr/jaspr.dart';

import '../components/icons.dart';
import '../components/layout.dart';
import '../components/modal.dart';
import '../data/projects.dart';
import '../models/project.dart';

/// 制作物一覧（island）。グリッド + 詳細モーダル（概要/担当・取り組み/学んだこと の3タブ）。
@client
class PortfolioPage extends StatefulComponent {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();

  @css
  static List<StyleRule> get styles => _portfolioStyles;
}

enum _Tab { overview, role, learnings }

class _PortfolioPageState extends State<PortfolioPage> {
  Project? _selected;
  _Tab _tab = _Tab.overview;

  // 表示は id の降順（新しい作品を先頭に）。
  List<Project> get _sorted =>
      [...projects]..sort((x, y) => y.id.compareTo(x.id));

  void _open(Project p) {
    setState(() {
      _selected = p;
      _tab = _Tab.overview;
    });
  }

  void _close() => setState(() => _selected = null);

  @override
  Component build(BuildContext context) {
    return Layout([
      div(classes: 'container portfolio', [
        div(classes: 'page-head', [
          h1(classes: 'page-title', [Component.text('Portfolio')]),
          p(classes: 'page-note', [Component.text('制作物一覧')]),
        ]),
        div(classes: 'portfolio-grid', [
          for (final project in _sorted) _card(project),
        ]),
      ]),
      if (_selected != null)
        Modal(
          onClose: _close,
          panelClasses: 'portfolio-modal',
          child: _detail(_selected!),
        ),
    ]);
  }

  Component _card(Project project) {
    return div(
      classes: 'proj-card card',
      events: events(onClick: () => _open(project)),
      [
        div(classes: 'proj-thumb', [
          img(src: project.image, alt: project.title, attributes: {'loading': 'lazy', 'decoding': 'async'}),
        ]),
        div(classes: 'proj-body', [
          h3(classes: 'proj-title', [Component.text(project.title)]),
          p(classes: 'proj-desc', [Component.text(project.description)]),
          div(classes: 'proj-tags', [
            for (final tech in project.technologies.take(3))
              span(classes: 'tag', [Component.text(tech)]),
            if (project.technologies.length > 3)
              span(classes: 'tag tag-more', [
                Component.text('+${project.technologies.length - 3}'),
              ]),
          ]),
        ]),
      ],
    );
  }

  Component _detail(Project proj) {
    final hasRole = (proj.role?.isNotEmpty ?? false) || (proj.challenges?.isNotEmpty ?? false);
    final hasLearnings = proj.learnings?.isNotEmpty ?? false;
    return div(classes: 'proj-detail', [
      img(src: proj.image, alt: proj.title, classes: 'proj-detail-img', attributes: {'loading': 'lazy', 'decoding': 'async'}),
      div(classes: 'proj-detail-body', [
        h2(classes: 'proj-detail-title', [Component.text(proj.title)]),
        div(classes: 'proj-tabs', [
          _tabButton(_Tab.overview, '概要'),
          if (hasRole) _tabButton(_Tab.role, '担当・取り組み'),
          if (hasLearnings) _tabButton(_Tab.learnings, '学んだこと'),
        ]),
        if (_tab == _Tab.overview) _overviewTab(proj),
        if (_tab == _Tab.role && hasRole) _roleTab(proj),
        if (_tab == _Tab.learnings && hasLearnings) _learningsTab(proj),
      ]),
    ]);
  }

  Component _tabButton(_Tab tab, String label) {
    return button(
      classes: _tab == tab ? 'proj-tab active' : 'proj-tab',
      onClick: () => setState(() => _tab = tab),
      [Component.text(label)],
    );
  }

  Component _overviewTab(Project proj) {
    return div([
      p(classes: 'proj-detail-desc', [Component.text(proj.description)]),
      div(classes: 'proj-section', [
        h3(classes: 'proj-section-label', [Component.text('Technologies')]),
        div(classes: 'proj-tags', [
          for (final tech in proj.technologies) span(classes: 'tag', [Component.text(tech)]),
        ]),
      ]),
      div(classes: 'proj-links', [
        if (proj.github.isNotEmpty)
          a(href: proj.github, target: Target.blank, classes: 'btn btn-outline', attributes: {'rel': 'noopener noreferrer'}, [
            icon('github', size: 18),
            span([Component.text('GitHub')]),
          ]),
        if (proj.liveDemo.isNotEmpty)
          a(href: proj.liveDemo, target: Target.blank, classes: 'btn btn-primary', attributes: {'rel': 'noopener noreferrer'}, [
            icon('external-link', size: 18),
            span([Component.text('Live Demo')]),
          ]),
      ]),
    ]);
  }

  Component _roleTab(Project proj) {
    return div(classes: 'proj-role', [
      if (proj.role?.isNotEmpty ?? false) ...[
        h3(classes: 'proj-section-label', [Component.text('担当したこと')]),
        _bullets(proj.role!),
      ],
      if (proj.challenges?.isNotEmpty ?? false) ...[
        h3(classes: 'proj-section-label', [Component.text('苦労したこと・頑張ったこと')]),
        _bullets(proj.challenges!),
      ],
    ]);
  }

  Component _learningsTab(Project proj) => _bullets(proj.learnings!);

  Component _bullets(List<String> items) {
    return ul(classes: 'proj-bullets', [
      for (final item in items)
        li([
          span(classes: 'proj-bullet-dot', [Component.text('●')]),
          span([Component.text(item)]),
        ]),
    ]);
  }
}

final List<StyleRule> _portfolioStyles = [
  css('.portfolio').styles(raw: {'padding': '8rem 1rem 4rem'}),
  css('.page-head').styles(raw: {'margin-bottom': '3rem'}),
  css('.page-title').styles(
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.bold,
    raw: {'font-size': 'clamp(2.25rem,5vw,3rem)', 'letter-spacing': '-0.02em', 'margin': '0'},
  ),
  css('.page-note').styles(color: Color('var(--color-text-muted)'), raw: {'margin': '0.75rem 0 0'}),

  // グリッド
  css('.portfolio-grid').styles(
    display: Display.grid,
    gap: Gap.all(1.5.rem),
    raw: {'grid-template-columns': 'repeat(1, minmax(0, 1fr))'},
  ),
  css.media(MediaQuery.screen(minWidth: 768.px), [
    css('.portfolio-grid').styles(raw: {'grid-template-columns': 'repeat(2, minmax(0, 1fr))'}),
  ]),
  css.media(MediaQuery.screen(minWidth: 1024.px), [
    css('.portfolio-grid').styles(raw: {'grid-template-columns': 'repeat(3, minmax(0, 1fr))'}),
  ]),

  // カード
  css('.proj-card').styles(raw: {'cursor': 'pointer'}),
  css('.proj-card:hover').styles(raw: {
    'transform': 'translateY(-4px)',
    'box-shadow': '0 20px 25px -5px rgba(0,0,0,0.15)',
    'border-color': 'var(--color-accent)',
  }),
  css('.proj-thumb').styles(raw: {'aspect-ratio': '16 / 9', 'overflow': 'hidden'}),
  css('.proj-thumb img').styles(
    width: 100.percent,
    height: 100.percent,
    raw: {'object-fit': 'cover', 'transition': 'transform .5s'},
  ),
  css('.proj-card:hover .proj-thumb img').styles(raw: {'transform': 'scale(1.05)'}),
  css('.proj-body').styles(padding: Padding.all(1.25.rem)),
  css('.proj-title').styles(
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.w600,
    raw: {'font-size': '1rem', 'margin': '0 0 0.5rem', 'transition': 'color .3s'},
  ),
  css('.proj-card:hover .proj-title').styles(color: Color('var(--color-accent)')),
  css('.proj-desc').styles(
    color: Color('var(--color-text-muted)'),
    raw: {
      'font-size': '0.875rem',
      'margin': '0 0 0.75rem',
      'display': '-webkit-box',
      '-webkit-line-clamp': '2',
      '-webkit-box-orient': 'vertical',
      'overflow': 'hidden',
    },
  ),
  css('.proj-tags').styles(display: Display.flex, gap: Gap.all(0.25.rem), raw: {'flex-wrap': 'wrap'}),
  css('.tag-more').styles(raw: {
    'background-color': 'var(--color-border)',
    'color': 'var(--color-text-muted)',
  }),

  // 詳細モーダル
  css('.portfolio-modal').styles(raw: {'max-width': '56rem'}),
  css('.proj-detail-img').styles(
    width: 100.percent,
    raw: {'height': '18rem', 'object-fit': 'cover', 'border-radius': '12px 12px 0 0'},
  ),
  css('.proj-detail-body').styles(padding: Padding.all(2.rem)),
  css('.proj-detail-title').styles(
    color: Color('var(--color-text)'),
    fontWeight: FontWeight.bold,
    raw: {'font-size': 'clamp(1.5rem,4vw,1.875rem)', 'margin': '0 0 1.25rem'},
  ),
  css('.proj-tabs').styles(
    display: Display.flex,
    raw: {'border-bottom': '1px solid var(--color-border)', 'margin-bottom': '1.5rem'},
  ),
  css('.proj-tab').styles(
    color: Color('var(--color-text-muted)'),
    backgroundColor: Colors.transparent,
    padding: Padding.symmetric(horizontal: 1.rem, vertical: 0.5.rem),
    fontWeight: FontWeight.w500,
    raw: {
      'font-size': '0.875rem',
      'border': 'none',
      'border-bottom': '2px solid transparent',
      'margin-bottom': '-1px',
      'transition': 'color .2s, border-color .2s',
    },
  ),
  css('.proj-tab:hover').styles(color: Color('var(--color-text)')),
  css('.proj-tab.active').styles(raw: {
    'color': 'var(--color-accent)',
    'border-bottom-color': 'var(--color-accent)',
  }),
  css('.proj-detail-desc').styles(color: Color('var(--color-text-muted)'), raw: {'margin': '0 0 1.5rem'}),
  css('.proj-section').styles(raw: {'margin-bottom': '1.5rem'}),
  css('.proj-section-label').styles(
    color: Color('var(--color-text-muted)'),
    fontWeight: FontWeight.w600,
    raw: {
      'font-size': '0.75rem',
      'text-transform': 'uppercase',
      'letter-spacing': '0.05em',
      'margin': '1.25rem 0 0.75rem',
    },
  ),
  css('.proj-links').styles(display: Display.flex, gap: Gap.all(0.75.rem), raw: {'flex-wrap': 'wrap', 'margin-top': '1.5rem'}),
  css('.proj-bullets').styles(raw: {'list-style': 'none', 'margin': '0', 'padding': '0'}),
  css('.proj-bullets li').styles(
    display: Display.flex,
    gap: Gap.all(0.5.rem),
    color: Color('var(--color-text-muted)'),
    raw: {'align-items': 'flex-start', 'margin': '0.5rem 0'},
  ),
  css('.proj-bullet-dot').styles(color: Color('var(--color-accent)'), raw: {'flex-shrink': '0', 'margin-top': '0.1rem'}),
];
