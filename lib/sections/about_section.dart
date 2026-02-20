import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/section_label.dart';

class AboutSection extends StatefulWidget {
  const AboutSection({super.key});

  @override
  State<AboutSection> createState() => _AboutSectionState();
}

class _AboutSectionState extends State<AboutSection>
    with SingleTickerProviderStateMixin {
  final List<Map<String, dynamic>> _skills = [
    {'name': 'Flutter / Dart', 'level': 0.92, 'icon': Icons.phone_android},
    {'name': 'UI/UX Design', 'level': 0.85, 'icon': Icons.design_services},
    {'name': 'React / Next.js', 'level': 0.78, 'icon': Icons.web},
    {'name': 'Node.js / Backend', 'level': 0.72, 'icon': Icons.storage},
    {'name': 'Firebase / Cloud', 'level': 0.80, 'icon': Icons.cloud},
  ];

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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.darkBackground,
            AppColors.darkSurface,
            AppColors.darkBackground,
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: _buildLeftContent(isMobile)),
                const SizedBox(width: 80),
                Expanded(child: _buildSkillsContent()),
              ],
            )
          : Column(
              children: [
                _buildLeftContent(isMobile),
                const SizedBox(height: 60),
                _buildSkillsContent(),
              ],
            ),
    );
  }

  Widget _buildLeftContent(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SectionLabelLeft(label: 'About Me'),
        const SizedBox(height: 20),
        Text(
              'Passionate developer\ncrafting digital magic.',
              style: TextStyle(
                color: AppColors.textMain,
                fontSize: isMobile ? 32 : 44,
                fontWeight: FontWeight.w800,
                height: 1.2,
              ),
            )
            .animate()
            .fadeIn(duration: 700.ms)
            .slideY(begin: 0.3, curve: Curves.easeOut),
        const SizedBox(height: 24),
        Text(
          'I\'m a full-stack developer with 5+ years of experience building beautiful, performant applications. I specialize in Flutter for mobile and web, with a strong eye for design and user experience.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isMobile ? 14 : 16,
            height: 1.8,
          ),
        ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
        const SizedBox(height: 16),
        Text(
          'When I\'m not coding, you\'ll find me exploring new design trends, contributing to open source, or mentoring aspiring developers.',
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isMobile ? 14 : 16,
            height: 1.8,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 700.ms),
        const SizedBox(height: 40),
        Wrap(
          spacing: 20,
          runSpacing: 20,
          children: [
            _StatCard(value: '5+', label: 'Years Exp.'),
            _StatCard(value: '50+', label: 'Projects'),
            _StatCard(value: '30+', label: 'Clients'),
          ],
        ).animate().fadeIn(delay: 600.ms, duration: 700.ms),
      ],
    );
  }

  Widget _buildSkillsContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Technical Skills',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(duration: 700.ms),
        const SizedBox(height: 32),
        ...List.generate(
          _skills.length,
          (i) => Padding(
            padding: const EdgeInsets.only(bottom: 24),
            child: _AnimatedSkillBar(
              name: _skills[i]['name'],
              level: _skills[i]['level'],
              icon: _skills[i]['icon'],
              delay: Duration(milliseconds: 200 * i),
            ),
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatefulWidget {
  final String value;
  final String label;

  const _StatCard({required this.value, required this.label});

  @override
  State<_StatCard> createState() => _StatCardState();
}

class _StatCardState extends State<_StatCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          gradient: _hovered
              ? AppColors.primaryGradient
              : const LinearGradient(
                  colors: [AppColors.cardSurface, AppColors.glassCard],
                ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: _hovered
                ? AppColors.primaryPurple
                : AppColors.primaryPurple.withOpacity(0.2),
          ),
          boxShadow: _hovered
              ? [
                  BoxShadow(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ]
              : [],
        ),
        child: Column(
          children: [
            Text(
              widget.value,
              style: TextStyle(
                color: _hovered ? Colors.white : AppColors.primaryPurple,
                fontSize: 32,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              widget.label,
              style: TextStyle(
                color: _hovered ? Colors.white70 : AppColors.textSecondary,
                fontSize: 13,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedSkillBar extends StatefulWidget {
  final String name;
  final double level;
  final IconData icon;
  final Duration delay;

  const _AnimatedSkillBar({
    required this.name,
    required this.level,
    required this.icon,
    required this.delay,
  });

  @override
  State<_AnimatedSkillBar> createState() => _AnimatedSkillBarState();
}

class _AnimatedSkillBarState extends State<_AnimatedSkillBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _animation = Tween<double>(
      begin: 0,
      end: widget.level,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    Future.delayed(widget.delay, () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(widget.icon, color: AppColors.primaryPurple, size: 18),
                    const SizedBox(width: 10),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        color: AppColors.textMain,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                AnimatedBuilder(
                  animation: _animation,
                  builder: (context, _) => Text(
                    '${(_animation.value * 100).toInt()}%',
                    style: const TextStyle(
                      color: AppColors.primaryPurple,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              height: 6,
              width: double.infinity,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(3),
              ),
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, _) => FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: _animation.value,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: AppColors.primaryGradient,
                      borderRadius: BorderRadius.circular(3),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.5),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        )
        .animate()
        .fadeIn(delay: widget.delay, duration: 600.ms)
        .slideX(begin: -0.2, delay: widget.delay, curve: Curves.easeOut);
  }
}
