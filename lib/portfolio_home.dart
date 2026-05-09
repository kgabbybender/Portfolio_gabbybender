import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'constants/app_colors.dart';
import 'sections/hero_section.dart';
import 'sections/about_section.dart';
import 'sections/projects_section.dart';
import 'sections/contact_section.dart';
import 'utils/responsive_helper.dart';

class PortfolioHome extends StatefulWidget {
  const PortfolioHome({super.key});

  @override
  State<PortfolioHome> createState() => _PortfolioHomeState();
}

class _PortfolioHomeState extends State<PortfolioHome> {
  final ScrollController _scrollController = ScrollController();
  bool _scrolled = false;

  // Section keys – owned here so they are always initialised before use.
  final _aboutKey = GlobalKey();
  final _projectsKey = GlobalKey();
  final _contactKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final scrolled = _scrollController.offset > 50;
      if (scrolled != _scrolled) {
        setState(() => _scrolled = scrolled);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // ── Scroll helpers ──────────────────────────────────────────────────────────

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToKey(GlobalKey key) {
    final ctx = key.currentContext;
    if (ctx == null) return;

    final box = ctx.findRenderObject() as RenderBox?;
    if (box == null) return;

    final scrollable = Scrollable.of(ctx);
    final scrollBox = scrollable.context.findRenderObject() as RenderBox?;
    if (scrollBox == null) return;

    final offset =
        box.localToGlobal(Offset.zero, ancestor: scrollBox).dy +
        _scrollController.offset -
        80; // nav-bar height

    _scrollController.animateTo(
      offset.clamp(0.0, _scrollController.position.maxScrollExtent),
      duration: const Duration(milliseconds: 700),
      curve: Curves.easeInOutCubic,
    );
  }

  void _scrollToAbout() => _scrollToKey(_aboutKey);
  void _scrollToProjects() => _scrollToKey(_projectsKey);
  void _scrollToContact() => _scrollToKey(_contactKey);

  // ── Build ───────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBackground,
      extendBodyBehindAppBar: true,
      appBar: _buildNavBar(context),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(
              onViewWork: _scrollToProjects,
              onContact: _scrollToContact,
            ),
            AboutSection(key: _aboutKey),
            ProjectsSection(key: _projectsKey),
            ContactSection(key: _contactKey),
            _buildFooter(context),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildNavBar(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return PreferredSize(
      preferredSize: const Size.fromHeight(72),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        decoration: BoxDecoration(
          color: _scrolled
              ? AppColors.darkSurface.withValues(alpha: 0.95)
              : Colors.transparent,
          border: _scrolled
              ? Border(
                  bottom: BorderSide(
                    color: AppColors.primaryPurple.withValues(alpha: 0.95),
                  ),
                )
              : null,
          boxShadow: _scrolled
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.95),
                    blurRadius: 20,
                  ),
                ]
              : [],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 24 : 60,
              vertical: 16,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Logo – tapping scrolls back to top
                GestureDetector(
                  onTap: _scrollToTop,
                  child: MouseRegion(
                    cursor: SystemMouseCursors.click,
                    child: ShaderMask(
                      shaderCallback: (bounds) =>
                          AppColors.primaryGradient.createShader(bounds),
                      child: Text(
                        'GB.',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isMobile ? 24 : 28,
                          fontWeight: FontWeight.w900,
                          letterSpacing: -1,
                        ),
                      ),
                    ),
                  ),
                ).animate().fadeIn(duration: 600.ms),

                // Nav links (desktop only)
                if (!isMobile)
                  Row(
                    children: [
                      _NavLink(label: 'About', onTap: _scrollToAbout),
                      _NavLink(label: 'Work', onTap: _scrollToProjects),
                      _NavLink(label: 'Contact', onTap: _scrollToContact),
                    ],
                  ).animate().fadeIn(delay: 200.ms, duration: 600.ms),

                // CTA button
                _NavCTAButton(
                  label: isMobile ? 'Hire Me' : "Let's Talk",
                  onTap: _scrollToContact,
                ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooter(BuildContext context) {
    final isMobile = Responsive.isMobile(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 24 : 120,
        vertical: 40,
      ),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(color: AppColors.primaryPurple.withOpacity(0.15)),
        ),
        color: AppColors.darkSurface,
      ),
      child: isMobile
          ? Column(
              children: [
                _buildFooterLogo(),
                const SizedBox(height: 16),
                _buildFooterCopyright(),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [_buildFooterLogo(), _buildFooterCopyright()],
            ),
    );
  }

  Widget _buildFooterLogo() {
    return GestureDetector(
      onTap: _scrollToTop,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        child: ShaderMask(
          shaderCallback: (bounds) =>
              AppColors.primaryGradient.createShader(bounds),
          child: const Text(
            'GB.',
            style: TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFooterCopyright() {
    return Text(
      '© 2026 Gabby Bender. Crafted with ❤️ & Flutter',
      style: TextStyle(color: AppColors.textMuted, fontSize: 13),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Nav link with animated underline + press scale
// ─────────────────────────────────────────────────────────────────────────────

class _NavLink extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavLink({required this.label, required this.onTap});

  @override
  State<_NavLink> createState() => _NavLinkState();
}

class _NavLinkState extends State<_NavLink>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.92).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 200),
                  style: TextStyle(
                    color: _hovered
                        ? AppColors.primaryPurple
                        : AppColors.textSecondary,
                    fontSize: 15,
                    fontWeight: _hovered ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(widget.label),
                ),
                const SizedBox(height: 2),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  height: 2,
                  width: _hovered ? 20 : 0,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(1),
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

// ─────────────────────────────────────────────────────────────────────────────
// Nav CTA button with ripple + glow
// ─────────────────────────────────────────────────────────────────────────────

class _NavCTAButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;

  const _NavCTAButton({required this.label, required this.onTap});

  @override
  State<_NavCTAButton> createState() => _NavCTAButtonState();
}

class _NavCTAButtonState extends State<_NavCTAButton>
    with SingleTickerProviderStateMixin {
  bool _hovered = false;
  late AnimationController _pressController;
  late Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _pressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      reverseDuration: const Duration(milliseconds: 200),
    );
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.94).animate(
      CurvedAnimation(parent: _pressController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: (_) => _pressController.forward(),
        onTapUp: (_) {
          _pressController.reverse();
          widget.onTap();
        },
        onTapCancel: () => _pressController.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              gradient: _hovered ? AppColors.primaryGradient : null,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: _hovered
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withOpacity(0.5),
              ),
              boxShadow: _hovered
                  ? [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.4),
                        blurRadius: 20,
                      ),
                    ]
                  : [],
            ),
            child: Text(
              widget.label,
              style: TextStyle(
                color: _hovered ? Colors.white : AppColors.lightPurple,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
