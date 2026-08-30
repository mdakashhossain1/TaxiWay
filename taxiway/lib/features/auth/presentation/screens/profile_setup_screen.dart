import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  bool _saving = false;
  String _name = '';

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_name.trim().isEmpty || _saving) return;
    setState(() => _saving = true);
    await ref.read(authControllerProvider.notifier).completeProfile(
          name: _name.trim(),
          email: _emailController.text.trim().isEmpty ? null : _emailController.text.trim(),
        );
    if (!mounted) return;
    AppToast.success(context, 'Profile setup completed!', title: 'Welcome');
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      // Top Bar with Back Button
                      Align(
                        alignment: Alignment.centerLeft,
                        child: AppBackButton(
                          onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.login),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // User Avatar with Camera Badge
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              width: 96,
                              height: 96,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF1F5F9),
                                shape: BoxShape.circle,
                              ),
                              child: Icon(
                                BootstrapIcons.person_fill,
                                size: 48,
                                color: AppColors.of(context).mutedText,
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 0,
                              child: Material(
                                color: AppColors.of(context).primary,
                                shape: const CircleBorder(),
                                elevation: 2,
                                child: InkWell(
                                  customBorder: const CircleBorder(),
                                  onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Photo upload ready.')),
                                  ),
                                  child: const Padding(
                                    padding: EdgeInsets.all(8),
                                    child: Icon(BootstrapIcons.camera_fill, size: 16, color: Colors.white),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ).animate().scale(duration: 400.ms, curve: Curves.elasticOut).fadeIn(duration: 300.ms),

                      const SizedBox(height: 28),

                      // Heading: Tell us about you
                      Text(
                        'Tell us about you',
                        style: AppTypography.of(context).h1.copyWith(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppColors.of(context).navy,
                        ),
                      ).animate().fadeIn(delay: 150.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 6),

                      // Subtitle
                      Text(
                        'Just the essentials — you can update this anytime.',
                        style: AppTypography.of(context).body.copyWith(
                          fontSize: 15,
                          color: AppColors.of(context).bodyText,
                        ),
                      ).animate().fadeIn(delay: 200.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 28),

                      // Full Name Text Field
                      AppTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        prefixIcon: BootstrapIcons.person_vcard,
                        onChanged: (v) => setState(() => _name = v),
                      ).animate().fadeIn(delay: 250.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      const SizedBox(height: 18),

                      // Email Text Field (Optional)
                      AppTextField(
                        controller: _emailController,
                        label: 'Email (optional)',
                        hint: 'Enter your email',
                        prefixIcon: BootstrapIcons.envelope,
                        keyboardType: TextInputType.emailAddress,
                      ).animate().fadeIn(delay: 300.ms, duration: 350.ms).slideY(begin: 0.2, end: 0),

                      const Spacer(),
                      const SizedBox(height: 20),

                      // Primary Button: "Continue"
                      SizedBox(
                        height: 52,
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _name.trim().isNotEmpty && !_saving ? _continue : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.of(context).primary,
                            disabledBackgroundColor: AppColors.of(context).primary.withValues(alpha: 0.4),
                            foregroundColor: Colors.white,
                            disabledForegroundColor: Colors.white70,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(AppRadius.button),
                            ),
                            textStyle: AppTypography.of(context).button,
                          ),
                          child: _saving
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4, color: Colors.white),
                                )
                              : const Text('Continue'),
                        ),
                      ),

                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
