import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_colors.dart';
import '../utils/responsive_helper.dart';
import '../widgets/section_label.dart';

// ─── Social / contact URLs ────────────────────────────────────────────────────
const _kEmail = 'gabbybender328@gmail.com';
const _kGitHubUrl = 'https://github.com/kgabbybender';
const _kLinkedInUrl = 'https://www.linkedin.com/in/gabby-bender-0b896a3a2/';
const _kInstagramUrl = 'https://www.instagram.com/_gabbybender/';

// ─────────────────────────────────────────────────────────────────────────────

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _sending = false;
  bool _sent = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      debugPrint('Could not launch $url');
    }
  }

  Future<void> _sendEmail() async {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    final message = _messageController.text.trim();

    if (name.isEmpty || email.isEmpty || message.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill in all fields.'),
          backgroundColor: AppColors.primaryPurple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    setState(() => _sending = true);

    // Build a mailto URI so the user's email client opens pre-filled.
    final subject = Uri.encodeComponent('Portfolio Contact from $name');
    final body = Uri.encodeComponent('From: $name <$email>\n\n$message');
    final mailUri = Uri.parse('mailto:$_kEmail?subject=$subject&body=$body');

    if (await canLaunchUrl(mailUri)) {
      await launchUrl(mailUri);
    }

    if (mounted) {
      setState(() {
        _sending = false;
        _sent = true;
      });
      // Reset after 3 s
      Future.delayed(const Duration(seconds: 3), () {
        if (mounted) setState(() => _sent = false);
      });
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
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.darkBackground, AppColors.darkSurface],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
      child: Column(
        children: [
          SectionLabel(label: 'Contact'),
          const SizedBox(height: 20),
          Text(
                "Let's Work Together",
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
          Text(
            "Have a project in mind? Let's create something amazing together.",
            style: TextStyle(
              color: AppColors.textSecondary,
              fontSize: isMobile ? 14 : 16,
              height: 1.7,
            ),
            textAlign: TextAlign.center,
          ).animate().fadeIn(delay: 200.ms, duration: 700.ms),
          const SizedBox(height: 60),
          isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(child: _buildContactInfo(isMobile)),
                    const SizedBox(width: 80),
                    Expanded(child: _buildContactForm(isMobile)),
                  ],
                )
              : Column(
                  children: [
                    _buildContactInfo(isMobile),
                    const SizedBox(height: 60),
                    _buildContactForm(isMobile),
                  ],
                ),
        ],
      ),
    );
  }

  Widget _buildContactInfo(bool isMobile) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Get in Touch',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: isMobile ? 24 : 30,
            fontWeight: FontWeight.w700,
          ),
        ).animate().fadeIn(delay: 300.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Text(
          "I'm always open to discussing new projects, creative ideas, or opportunities to be part of your vision.",
          style: TextStyle(
            color: AppColors.textSecondary,
            fontSize: isMobile ? 14 : 16,
            height: 1.8,
          ),
        ).animate().fadeIn(delay: 400.ms, duration: 600.ms),
        const SizedBox(height: 40),
        ...[
          _ContactInfoItem(
            icon: Icons.email_outlined,
            label: 'Email',
            value: _kEmail,
            delay: 500,
            onTap: () => _launchUrl('mailto:$_kEmail'),
          ),
          _ContactInfoItem(
            icon: Icons.location_on_outlined,
            label: 'Location',
            value: 'Accra, Ghana',
            delay: 600,
          ),
          _ContactInfoItem(
            icon: Icons.access_time_outlined,
            label: 'Availability',
            value: 'Mon - Fri, 8pm - 1am GMT',
            delay: 700,
          ),
        ],
        const SizedBox(height: 40),
        Text(
          'Follow Me',
          style: TextStyle(
            color: AppColors.textMain,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ).animate().fadeIn(delay: 800.ms, duration: 600.ms),
        const SizedBox(height: 16),
        Row(
          children: [
            _SocialButton(icon: Icons.code, label: 'GitHub', url: _kGitHubUrl),
            const SizedBox(width: 12),
            _SocialButton(
              icon: Icons.work_outline,
              label: 'LinkedIn',
              url: _kLinkedInUrl,
            ),
            const SizedBox(width: 12),
            _SocialButton(
              icon: Icons.mail_outline,
              label: 'Instagram',
              url: _kInstagramUrl,
            ),
          ],
        ).animate().fadeIn(delay: 900.ms, duration: 600.ms),
      ],
    );
  }

  Widget _buildContactForm(bool isMobile) {
    return Container(
          padding: const EdgeInsets.all(40),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [AppColors.cardSurface, AppColors.glassCard],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.primaryPurple.withOpacity(0.2)),
            boxShadow: [
              BoxShadow(
                color: AppColors.primaryPurple.withOpacity(0.1),
                blurRadius: 40,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _GlowTextField(
                controller: _nameController,
                label: 'Your Name',
                hint: 'John Doe',
                icon: Icons.person_outline,
              ),
              const SizedBox(height: 20),
              _GlowTextField(
                controller: _emailController,
                label: 'Email Address',
                hint: 'john@example.com',
                icon: Icons.email_outlined,
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              _GlowTextField(
                controller: _messageController,
                label: 'Message',
                hint: 'Tell me about your project...',
                icon: Icons.message_outlined,
                maxLines: 5,
              ),
              const SizedBox(height: 32),
              SizedBox(
                width: double.infinity,
                child: _SendButton(
                  sending: _sending,
                  sent: _sent,
                  onTap: _sendEmail,
                ),
              ),
            ],
          ),
        )
        .animate()
        .fadeIn(delay: 400.ms, duration: 700.ms)
        .slideX(begin: 0.2, curve: Curves.easeOut);
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Contact info item (optionally tappable)
// ─────────────────────────────────────────────────────────────────────────────

class _ContactInfoItem extends StatefulWidget {
  final IconData icon;
  final String label;
  final String value;
  final int delay;
  final VoidCallback? onTap;

  const _ContactInfoItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.delay,
    this.onTap,
  });

  @override
  State<_ContactInfoItem> createState() => _ContactInfoItemState();
}

class _ContactInfoItemState extends State<_ContactInfoItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final isClickable = widget.onTap != null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: MouseRegion(
        cursor: isClickable ? SystemMouseCursors.click : MouseCursor.defer,
        onEnter: (_) {
          if (isClickable) setState(() => _hovered = true);
        },
        onExit: (_) {
          if (isClickable) setState(() => _hovered = false);
        },
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: _hovered
                  ? AppColors.primaryPurple.withOpacity(0.05)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _hovered
                        ? AppColors.primaryPurple.withOpacity(0.2)
                        : AppColors.primaryPurple.withOpacity(0.1),
                    border: Border.all(
                      color: _hovered
                          ? AppColors.primaryPurple
                          : AppColors.primaryPurple.withOpacity(0.3),
                    ),
                  ),
                  child: Icon(
                    widget.icon,
                    color: AppColors.primaryPurple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.label,
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 2),
                    AnimatedDefaultTextStyle(
                      duration: const Duration(milliseconds: 200),
                      style: TextStyle(
                        color: _hovered
                            ? AppColors.primaryPurple
                            : AppColors.textMain,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        decoration: _hovered && isClickable
                            ? TextDecoration.underline
                            : TextDecoration.none,
                        decorationColor: AppColors.primaryPurple,
                      ),
                      child: Text(widget.value),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(
      delay: Duration(milliseconds: widget.delay),
      duration: 600.ms,
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Social button
// ─────────────────────────────────────────────────────────────────────────────

class _SocialButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final String url;

  const _SocialButton({
    required this.icon,
    required this.label,
    required this.url,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton>
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
// Glow text field
// ─────────────────────────────────────────────────────────────────────────────

class _GlowTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final int maxLines;
  final TextInputType keyboardType;

  const _GlowTextField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.maxLines = 1,
    this.keyboardType = TextInputType.text,
  });

  @override
  State<_GlowTextField> createState() => _GlowTextFieldState();
}

class _GlowTextFieldState extends State<_GlowTextField> {
  bool _focused = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Focus(
          onFocusChange: (focused) => setState(() => _focused = focused),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: _focused
                    ? AppColors.primaryPurple
                    : AppColors.primaryPurple.withOpacity(0.2),
                width: _focused ? 1.5 : 1,
              ),
              boxShadow: _focused
                  ? [
                      BoxShadow(
                        color: AppColors.primaryPurple.withOpacity(0.15),
                        blurRadius: 12,
                        spreadRadius: 1,
                      ),
                    ]
                  : [],
            ),
            child: TextField(
              controller: widget.controller,
              maxLines: widget.maxLines,
              keyboardType: widget.keyboardType,
              style: const TextStyle(color: AppColors.textMain, fontSize: 15),
              decoration: InputDecoration(
                hintText: widget.hint,
                hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 14),
                prefixIcon: Icon(
                  widget.icon,
                  color: _focused
                      ? AppColors.primaryPurple
                      : AppColors.textMuted,
                  size: 20,
                ),
                filled: true,
                fillColor: AppColors.surface,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 14,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Send button
// ─────────────────────────────────────────────────────────────────────────────

class _SendButton extends StatefulWidget {
  final bool sending;
  final bool sent;
  final VoidCallback onTap;

  const _SendButton({
    required this.sending,
    required this.sent,
    required this.onTap,
  });

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton>
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
      end: 0.96,
    ).animate(CurvedAnimation(parent: _pressCtrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _pressCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDisabled = widget.sending || widget.sent;

    return MouseRegion(
      cursor: isDisabled ? SystemMouseCursors.basic : SystemMouseCursors.click,
      onEnter: (_) {
        if (!isDisabled) setState(() => _hovered = true);
      },
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTapDown: isDisabled ? null : (_) => _pressCtrl.forward(),
        onTapUp: isDisabled
            ? null
            : (_) {
                _pressCtrl.reverse();
                widget.onTap();
              },
        onTapCancel: isDisabled ? null : () => _pressCtrl.reverse(),
        child: ScaleTransition(
          scale: _scaleAnim,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.symmetric(vertical: 18),
            decoration: BoxDecoration(
              gradient: widget.sent
                  ? const LinearGradient(
                      colors: [Color(0xFF22C55E), Color(0xFF16A34A)],
                    )
                  : AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color:
                      (widget.sent
                              ? const Color(0xFF22C55E)
                              : AppColors.primaryPurple)
                          .withOpacity(_hovered ? 0.6 : 0.3),
                  blurRadius: _hovered ? 30 : 15,
                  spreadRadius: _hovered ? 2 : 0,
                ),
              ],
            ),
            child: Center(
              child: widget.sending
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : widget.sent
                  ? const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.check_circle_outline_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Message Sent!',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Text(
                          'Send Message',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 8),
                        AnimatedSlide(
                          offset: _hovered ? const Offset(0.3, 0) : Offset.zero,
                          duration: const Duration(milliseconds: 250),
                          child: const Icon(
                            Icons.send_rounded,
                            color: Colors.white,
                            size: 18,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
