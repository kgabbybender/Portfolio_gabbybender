import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/project_card.dart';
import '../widgets/section_label.dart';

// Replace with your real GitHub / portfolio URL
const _kAllProjectsUrl = 'https://github.com/';

class ProjectsSection extends StatefulWidget {
  const ProjectsSection({super.key});

  @override
  State<ProjectsSection> createState() => _ProjectsSectionState();
}

class _ProjectsSectionState extends State<ProjectsSection> {
  int _selectedFilter = 0;
  final List<String> _filters = ['All', 'Mobile', 'Web', 'Design'];

  final List<Map<String, dynamic>> _projects = [
    {
      'title': 'FinTrack Pro',
      'description':
          'A comprehensive finance tracking app with real-time analytics, budget planning, and AI-powered insights.',
      'category': 'Mobile App',
      'icon': Icons.account_balance_wallet,
      'tags': ['Flutter', 'Firebase', 'Charts'],
      'type': 'Mobile',
      'url': 'https://github.com/',
    },
    {
      'title': 'ArtSpace Gallery',
      'description':
          'An immersive digital art gallery platform with AR features and artist collaboration tools.',
      'category': 'Web App',
      'icon': Icons.palette,
      'tags': ['React', 'Three.js', 'AR'],
      'type': 'Web',
      'url': 'https://github.com/',
    },
    {
      'title': 'FitPulse',
      'description':
          'Smart fitness companion with personalized workout plans, nutrition tracking, and social challenges.',
      'category': 'Mobile App',
      'icon': Icons.fitness_center,
      'tags': ['Flutter', 'ML Kit', 'Health'],
      'type': 'Mobile',
      'url': 'https://github.com/',
    },
    {
      'title': 'TaskFlow',
      'description':
          'Elegant project management tool with Kanban boards, time tracking, and team collaboration.',
      'category': 'Web App',
      'icon': Icons.task_alt,
      'tags': ['Next.js', 'Supabase', 'TypeScript'],
      'type': 'Web',
      'url': 'https://github.com/',
    },
    {
      'title': 'Lumina UI Kit',
      'description':
          'A comprehensive design system with 200+ components, dark/light themes, and Figma integration.',
      'category': 'Design',
      'icon': Icons.design_services,
      'tags': ['Figma', 'Design System', 'UI Kit'],
      'type': 'Design',
      'url': 'https://github.com/',
    },
    {
      'title': 'EcoTrack',
      'description':
          'Environmental impact tracker helping users reduce their carbon footprint with gamification.',
      'category': 'Mobile App',
      'icon': Icons.eco,
      'tags': ['Flutter', 'GraphQL', 'Maps'],
      'type': 'Mobile',
      'url': 'https://github.com/',
    },
  ];

  List<Map<String, dynamic>> get _filteredProjects {
    if (_selectedFilter == 0) return _projects;
    final filter = _filters[_selectedFilter];
    return _projects.where((p) => p['type'] == filter).toList();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 120 : (isMobile ? 24 : 60),
        vertical: 100,
      ),
      color: AppColors.darkBackground,
      child: Column(
        children: [
          // Section header
          Column(
            children: [
              SectionLabel(label: 'Portfolio'),
              const SizedBox(height: 20),
              Text(
                    'Selected Works',
                    style: TextStyle(
                      color: AppColors.textMain,
                      fontSize: isDesktop ? 52 : (isMobile ? 32 : 42),
                      fontWeight: FontWeight.w800,
                      height: 1.1,
                    ),
                    textAlign: TextAlign.center,
                  )
                  .animate()
                  .fadeIn(duration: 700.ms)
                  .slideY(begin: 0.3, curve: Curves.easeOut),
              const SizedBox(height: 16),
              SizedBox(
                width: 500,
                child: Text(
                  'A collection of projects that showcase my skills in design, development, and problem-solving.',
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: isMobile ? 14 : 16,
                    height: 1.7,
                  ),
                  textAlign: TextAlign.center,
                ),
              ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
            ],
          ),

          const SizedBox(height: 48),

          // Filter tabs
          _buildFilterTabs(isMobile),

          const SizedBox(height: 48),

          // Projects grid
          _buildProjectsGrid(isDesktop, isMobile),

          const SizedBox(height: 60),

          // View all button
          _ViewAllButton(
            onTap: () => _launchUrl(_kAllProjectsUrl),
          ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
        ],
      ),
    );
  }

  Widget _buildFilterTabs(bool isMobile) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: AppColors.primaryPurple.withOpacity(0.2)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: List.generate(
          _filters.length,
          (i) => _FilterTab(
            label: _filters[i],
            selected: _selectedFilter == i,
            isMobile: isMobile,
            onTap: () => setState(() => _selectedFilter = i),
          ),
        ),
      ),
    ).animate().fadeIn(delay: 400.ms, duration: 600.ms);
  }

  Widget _buildProjectsGrid(bool isDesktop, bool isMobile) {
    final projects = _filteredProjects;
    final crossAxisCount = isDesktop ? 3 : (isMobile ? 1 : 2);

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: isDesktop ? 0.75 : (isMobile ? 0.9 : 0.8),
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) => ProjectCard(
        title: projects[index]['title'],
        description: projects[index]['description'],
        category: projects[index]['category'],
        icon: projects[index]['icon'],
        tags: List<String>.from(projects[index]['tags']),
        index: index,
        projectUrl: projects[index]['url'] as String?,
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Filter tab with press animation
// ─────────────────────────────────────────────────────────────────────────────

class _FilterTab extends StatefulWidget {
  final String label;
  final bool selected;
  final bool isMobile;
  final VoidCallback onTap;

  const _FilterTab({
    required this.label,
    required this.selected,
    required this.isMobile,
    required this.onTap,
  });

  @override
  State<_FilterTab> createState() => _FilterTabState();
}

class _FilterTabState extends State<_FilterTab>
    with SingleTickerProviderStateMixin {
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.92,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: EdgeInsets.symmetric(
              horizontal: widget.isMobile ? 16 : 24,
              vertical: 10,
            ),
            decoration: BoxDecoration(
              gradient: widget.selected ? AppColors.primaryGradient : null,
              borderRadius: BorderRadius.circular(50),
              boxShadow: widget.selected
                  ? [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                        blurRadius: 12,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: widget.selected ? Colors.white : AppColors.textSecondary,
                fontSize: widget.isMobile ? 13 : 14,
                fontWeight: widget.selected ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// View All button
// ─────────────────────────────────────────────────────────────────────────────

class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ViewAllButton({required this.onTap});

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pressCtrl;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(
      begin: 1.0,
      end: 0.94,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _pressCtrl.forward(),
        onTapUp: (_) {
          _pressCtrl.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressCtrl.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 16),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primaryPurple.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: _hovered
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withOpacity(0.4),
                width: 1.5,
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.2),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'View All Projects',
                  style: TextStyle(
                    color: AppColors.lightPurple,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  offset: _hovered ? const Offset(0.3, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    Icons.arrow_forward_rounded,
                    color: AppColors.lightPurple,
                    size: 18,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
