import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/animated_background.dart';

// ─── Social link data ────────────────────────────────────────────────────────
const _kGitHubUrl = 'https://github.com/';
const _kLinkedInUrl = 'https://linkedin.com/';
const _kTwitterUrl = 'https://twitter.com/';
const _kCvUrl =
    'https://drive.google.com/file/d/1wZVFd8xgcCn-iQhI19QnJvkQ_r55BjfZ/view?usp=drive_link'; // replace with real CV link

// ─────────────────────────────────────────────────────────────────────────────

class HeroSection extends StatefulWidget {
  final VoidCallback? onViewWork;
  final VoidCallback? onContact;

  const HeroSection({super.key, this.onViewWork, this.onContact});

  @override
  State<HeroSection> createState() => _HeroSectionState();
}

class _HeroSectionState extends State<HeroSection>
    with TickerProviderStateMixin {
  late AnimationController _glowController;
  late AnimationController _typewriterController;
  late Animation<double> _glowAnimation;

  final List<String> _roles = [
    'Flutter Developer',
    'UI/UX Designer',
    'Creative Coder',
    'Mobile Engineer',
  ];
  int _currentRoleIndex = 0;
  String _displayedText = '';
  bool _isDeleting = false;
  int _charIndex = 0;

  @override
  void initState() {
    super.initState();

    _glowController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(reverse: true);

    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );

    _typewriterController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );

    _startTypewriter();
  }

  void _startTypewriter() async {
    while (mounted) {
      final currentRole = _roles[_currentRoleIndex];

      if (!_isDeleting) {
        if (_charIndex < currentRole.length) {
          setState(() {
            _charIndex++;
            _displayedText = currentRole.substring(0, _charIndex);
          });
          await Future.delayed(const Duration(milliseconds: 100));
        } else {
          await Future.delayed(const Duration(milliseconds: 1500));
          _isDeleting = true;
        }
      } else {
        if (_charIndex > 0) {
          setState(() {
            _charIndex--;
            _displayedText = currentRole.substring(0, _charIndex);
          });
          await Future.delayed(const Duration(milliseconds: 50));
        } else {
          _isDeleting = false;
          _currentRoleIndex = (_currentRoleIndex + 1) % _roles.length;
        }
      }
    }
  }

  @override
  void dispose() {
    _glowController.dispose();
    _typewriterController.dispose();
    super.dispose();
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
      height: MediaQuery.of(context).size.height,
      width: double.infinity,
      decoration: const BoxDecoration(gradient: AppColors.heroGradient),
      child: AnimatedBackground(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Glowing orbs
            _buildGlowOrb(
              left: isDesktop ? 100 : 20,
              top: 100,
              size: isDesktop ? 400 : 200,
              color: AppColors.primaryPurple,
              opacity: 0.08,
            ),
            _buildGlowOrb(
              right: isDesktop ? 100 : 20,
              bottom: 100,
              size: isDesktop ? 350 : 180,
              color: AppColors.deepPurple,
              opacity: 0.06,
            ),
            _buildGlowOrb(
              left: isDesktop ? 400 : 100,
              bottom: 200,
              size: isDesktop ? 250 : 120,
              color: AppColors.neonPurple,
              opacity: 0.05,
            ),

            // Main content
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 120 : (isMobile ? 24 : 60),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Greeting badge
                  Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: AppColors.primaryPurple.withOpacity(0.5),
                          ),
                          borderRadius: BorderRadius.circular(30),
                          color: AppColors.primaryPurple.withOpacity(0.1),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            AnimatedBuilder(
                              animation: _glowAnimation,
                              builder: (context, _) => Container(
                                width: 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: AppColors.primaryPurple.withOpacity(
                                    _glowAnimation.value,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: AppColors.primaryPurple
                                          .withOpacity(
                                            _glowAnimation.value * 0.8,
                                          ),
                                      blurRadius: 8,
                                      spreadRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Available for work',
                              style: TextStyle(
                                color: AppColors.lightPurple,
                                fontSize: isMobile ? 12 : 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      )
                      .animate()
                      .fadeIn(duration: 600.ms)
                      .slideX(begin: -0.3, curve: Curves.easeOut),

                  const SizedBox(height: 32),

                  // Main heading
                  Text(
                        "Hello, I'm",
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isDesktop ? 24 : (isMobile ? 16 : 20),
                          fontWeight: FontWeight.w400,
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 200.ms, duration: 600.ms)
                      .slideY(begin: 0.3),

                  const SizedBox(height: 8),

                  ShaderMask(
                        shaderCallback: (bounds) =>
                            AppColors.purpleGlow.createShader(bounds),
                        child: Text(
                          "Gabby Bender",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isDesktop ? 80 : (isMobile ? 42 : 60),
                            fontWeight: FontWeight.w900,
                            height: 2.0,
                            letterSpacing: 1,
                          ),
                        ),
                      )
                      .animate()
                      .fadeIn(delay: 400.ms, duration: 800.ms)
                      .scale(
                        begin: const Offset(0.8, 0.8),
                        curve: Curves.easeOutBack,
                      ),

                  const SizedBox(height: 16),

                  // Typewriter role
                  Row(
                    children: [
                      Text(
                        'I am a ',
                        style: TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: isDesktop ? 28 : (isMobile ? 18 : 22),
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      Text(
                        _displayedText,
                        style: TextStyle(
                          color: AppColors.primaryPurple,
                          fontSize: isDesktop ? 28 : (isMobile ? 18 : 22),
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      AnimatedBuilder(
                        animation: _glowAnimation,
                        builder: (context, _) => Opacity(
                          opacity: _glowAnimation.value > 0.6 ? 1.0 : 0.0,
                          child: Container(
                            width: 2,
                            height: isDesktop ? 32 : 22,
                            color: AppColors.primaryPurple,
                          ),
                        ),
                      ),
                    ],
                  ).animate().fadeIn(delay: 600.ms, duration: 600.ms),

                  const SizedBox(height: 24),

                  // Description
                  SizedBox(
                    width: isDesktop ? 600 : double.infinity,
                    child: Text(
                      'Crafting beautiful digital experiences with clean code and creative design. Passionate about building products that make a difference.',
                      style: TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: isDesktop ? 18 : (isMobile ? 14 : 16),
                        height: 1.7,
                      ),
                    ),
                  ).animate().fadeIn(delay: 800.ms, duration: 600.ms),

                  const SizedBox(height: 48),

                  // CTA Buttons
                  Wrap(
                    spacing: 16,
                    runSpacing: 16,
                    children: [
                      _GlowButton(
                        label: 'View My Work',
                        icon: Icons.arrow_forward_rounded,
                        onTap: widget.onViewWork ?? () {},
                      ),
                      _OutlineButton(
                        label: 'Download CV',
                        icon: Icons.download_rounded,
                        onTap: () => _launchUrl(_kCvUrl),
                      ),
                    ],
                  ).animate().fadeIn(delay: 1000.ms, duration: 600.ms),

                  const SizedBox(height: 60),

                  // Social links
                  Row(
                    children: [
                      _SocialIcon(
                        icon: Icons.code,
                        label: 'GitHub',
                        url: _kGitHubUrl,
                      ),
                      const SizedBox(width: 16),
                      _SocialIcon(
                        icon: Icons.work_outline,
                        label: 'LinkedIn',
                        url: _kLinkedInUrl,
                      ),
                      const SizedBox(width: 16),
                      _SocialIcon(
                        icon: Icons.alternate_email,
                        label: 'Twitter',
                        url: _kTwitterUrl,
                      ),
                    ],
                  ).animate().fadeIn(delay: 1200.ms, duration: 600.ms),
                ],
              ),
            ),

            // Scroll indicator
            Positioned(
              bottom: 40,
              child: Column(
                children: [
                  Text(
                    'Scroll Down',
                    style: TextStyle(
                      color: AppColors.textMuted,
                      fontSize: 12,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _ScrollIndicator(),
                ],
              ).animate().fadeIn(delay: 1500.ms, duration: 800.ms),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlowOrb({
    double? left,
    double? right,
    double? top,
    double? bottom,
    required double size,
    required Color color,
    required double opacity,
  }) {
    return Positioned(
      left: left,
      right: right,
      top: top,
      bottom: bottom,
      child: AnimatedBuilder(
        animation: _glowAnimation,
        builder: (context, _) => Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: RadialGradient(
              colors: [
                color.withOpacity(opacity * _glowAnimation.value),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Glow CTA button
// ─────────────────────────────────────────────────────────────────────────────

class _GlowButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GlowButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GlowButton> createState() => _GlowButtonState();
}

class _GlowButtonState extends State<_GlowButton>
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(50),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primaryPurple.withOpacity(
                    _hovered ? 0.6 : 0.3,
                  ),
                  blurRadius: _hovered ? 30 : 15,
                  spreadRadius: _hovered ? 2 : 0,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  widget.label,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 8),
                AnimatedSlide(
                  offset: _hovered ? const Offset(0.3, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(widget.icon, color: Colors.white, size: 18),
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
// Outline button
// ─────────────────────────────────────────────────────────────────────────────

class _OutlineButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _OutlineButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_OutlineButton> createState() => _OutlineButtonState();
}

class _OutlineButtonState extends State<_OutlineButton>
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
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primaryPurple.withOpacity(0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(50),
              border: Border.all(
                color: _hovered
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withOpacity(0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                AnimatedSlide(
                  offset: _hovered ? const Offset(-0.1, 0) : Offset.zero,
                  duration: const Duration(milliseconds: 250),
                  child: Icon(
                    widget.icon,
                    color: AppColors.lightPurple,
                    size: 18,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  widget.label,
                  style: TextStyle(
                    color: AppColors.lightPurple,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
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
// Social icon with tooltip + URL
// ─────────────────────────────────────────────────────────────────────────────

class _SocialIcon extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialIcon({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialIcon> createState() => _SocialIconState();
}

class _SocialIconState extends State<_SocialIcon>
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
      end: 0.88,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  Future<void> _launch() async {
    final uri = Uri.parse(widget.url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch ${widget.url}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.label,
      preferBelow: false,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hovered = true),
        onExit: (_) => setState(() => _hovered = false),
        child: GestureDetector(
          onTapDown: (_) => _pressCtrl.forward(),
          onTapUp: (_) {
            _pressCtrl.reverse();
            _launch();
          },
          onTapCancel: () => _pressCtrl.reverse(),
          child: ScaleTransition(
            scale: _scaleAnim,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _hovered
                    ? AppColors.primaryPurple.withOpacity(0.2)
                    : AppColors.surface.withOpacity(0.5),
                border: Border.all(
                  color: _hovered
                      ? AppColors.primaryPurple
                      : AppColors.primaryPurple.withOpacity(0.3),
                ),
                boxShadow: _hovered
                    ? [
                        BoxShadow(
                          color: AppColors.primaryPurple.withOpacity(0.3),
                          blurRadius: 12,
                        ),
                      ]
                    : [],
              ),
              child: Icon(
                widget.icon,
                color: _hovered
                    ? AppColors.primaryPurple
                    : AppColors.textSecondary,
                size: 20,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Scroll indicator
// ─────────────────────────────────────────────────────────────────────────────

class _ScrollIndicator extends StatefulWidget {
  @override
  State<_ScrollIndicator> createState() => _ScrollIndicatorState();
}

class _ScrollIndicatorState extends State<_ScrollIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat(reverse: true);
    _animation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 24,
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryPurple.withOpacity(0.5),
          width: 1.5,
        ),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, _) => Align(
          alignment: Alignment(0, -1 + _animation.value * 2),
          child: Container(
            width: 4,
            height: 8,
            margin: const EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(2),
              color: AppColors.primaryPurple,
            ),
          ),
        ),
      ),
    );
  }
}
