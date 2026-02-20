import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';

class ProjectCard extends StatefulWidget {
  final String title;
  final String description;
  final String category;
  final IconData icon;
  final List<String> tags;
  final int index;
  final String? projectUrl;

  const ProjectCard({
    super.key,
    required this.title,
    this.description =
        'A beautifully crafted application with modern UI and seamless user experience.',
    this.category = 'Mobile App',
    this.icon = Icons.phone_android,
    this.tags = const ['Flutter', 'Firebase', 'UI/UX'],
    this.index = 0,
    this.projectUrl,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard>
    with TickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _shimmerController;
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _shimmerController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.97).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    _pressController.dispose();
    super.dispose();
  }

  Future<void> _openProject() async {
    final url = widget.projectUrl;
    if (url == null || url.isEmpty) return;
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          _openProject();
        },
        onTapCancel: () => _pressController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child:
              AnimatedContainer(
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeOutCubic,
                    transform: _hovered
                        ? (Matrix4.identity()..translate(0.0, -12.0))
                        : Matrix4.identity(),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(24),
                        gradient: const LinearGradient(
                          colors: [AppColors.cardSurface, AppColors.glassCard],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        border: Border.all(
                          color: _hovered
                              ? AppColors.primaryPurple.withOpacity(0.6)
                              : AppColors.primaryPurple.withOpacity(0.15),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _hovered
                                ? AppColors.primaryPurple.withOpacity(0.25)
                                : Colors.black.withOpacity(0.3),
                            blurRadius: _hovered ? 40 : 20,
                            spreadRadius: _hovered ? 2 : 0,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(24),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Project image/preview area
                            _buildPreviewArea(),

                            // Content
                            Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Category + arrow
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 12,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: AppColors.primaryPurple
                                              .withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(
                                            20,
                                          ),
                                          border: Border.all(
                                            color: AppColors.primaryPurple
                                                .withOpacity(0.3),
                                          ),
                                        ),
                                        child: Text(
                                          widget.category,
                                          style: const TextStyle(
                                            color: AppColors.lightPurple,
                                            fontSize: 11,
                                            fontWeight: FontWeight.w600,
                                            letterSpacing: 1,
                                          ),
                                        ),
                                      ),
                                      AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 250,
                                        ),
                                        width: 36,
                                        height: 36,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: _hovered
                                              ? AppColors.primaryPurple
                                              : AppColors.primaryPurple
                                                    .withOpacity(0.1),
                                          border: Border.all(
                                            color: AppColors.primaryPurple
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                        child: AnimatedSlide(
                                          offset: _hovered
                                              ? const Offset(0.15, -0.15)
                                              : Offset.zero,
                                          duration: const Duration(
                                            milliseconds: 250,
                                          ),
                                          child: Icon(
                                            Icons.arrow_outward_rounded,
                                            color: _hovered
                                                ? Colors.white
                                                : AppColors.primaryPurple,
                                            size: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  const SizedBox(height: 14),

                                  // Title
                                  Text(
                                    widget.title,
                                    style: const TextStyle(
                                      color: AppColors.textMain,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),

                                  const SizedBox(height: 8),

                                  // Description
                                  Text(
                                    widget.description,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 13,
                                      height: 1.6,
                                    ),
                                  ),

                                  const SizedBox(height: 16),

                                  // Tags
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 8,
                                    children: widget.tags
                                        .map((tag) => _TagChip(tag: tag))
                                        .toList(),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .animate()
                  .fadeIn(
                    delay: Duration(milliseconds: 150 * widget.index),
                    duration: 600.ms,
                  )
                  .slideY(
                    begin: 0.3,
                    delay: Duration(milliseconds: 150 * widget.index),
                    curve: Curves.easeOut,
                  ),
        ),
      ),
    );
  }

  Widget _buildPreviewArea() {
    final List<Color> gradients = [
      AppColors.primaryPurple,
      AppColors.deepPurple,
      AppColors.neonPurple,
    ];
    final color = gradients[widget.index % gradients.length];

    return Container(
      height: 180,
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.3), AppColors.darkBackground],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Stack(
        children: [
          // Decorative circles
          Positioned(
            right: -20,
            top: -20,
            child: Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            left: 20,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: color.withOpacity(0.08),
              ),
            ),
          ),
          // Main icon
          Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: _hovered ? 76 : 70,
              height: _hovered ? 76 : 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.3), color.withOpacity(0.1)],
                ),
                border: Border.all(
                  color: color.withOpacity(_hovered ? 0.8 : 0.4),
                  width: 1.5,
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Icon(widget.icon, color: color, size: 32),
            ),
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Tag chip with hover
// ─────────────────────────────────────────────────────────────────────────────

class _TagChip extends StatefulWidget {
  final String tag;

  const _TagChip({required this.tag});

  @override
  State<_TagChip> createState() => _TagChipState();
}

class _TagChipState extends State<_TagChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: _hovered
              ? AppColors.primaryPurple.withOpacity(0.15)
              : AppColors.surface,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: _hovered
                ? AppColors.primaryPurple.withOpacity(0.4)
                : Colors.transparent,
          ),
        ),
        child: Text(
          widget.tag,
          style: TextStyle(
            color: _hovered ? AppColors.lightPurple : AppColors.textSecondary,
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
