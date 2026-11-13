import '../../../../core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/animated_success_check.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../l10n/generated/app_localizations.dart';

class ProfileSetupScreen extends ConsumerStatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  ConsumerState<ProfileSetupScreen> createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends ConsumerState<ProfileSetupScreen> {
  static final _emailPattern = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$');
  static const _welcomeDuration = Duration(milliseconds: 2400);

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _emailFocus = FocusNode();
  bool _saving = false;
  bool _done = false;
  bool _navigated = false;
  bool _emailTouched = false;
  String _firstName = '';

  String get _name => _nameController.text.trim();
  String get _email => _emailController.text.trim();
  bool get _emailInvalid => _email.isNotEmpty && !_emailPattern.hasMatch(_email);

  @override
  void initState() {
    super.initState();
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _email.isNotEmpty && !_emailTouched) {
        setState(() => _emailTouched = true);
      }
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _emailFocus.dispose();
    super.dispose();
  }

  Future<void> _continue() async {
    if (_name.isEmpty || _saving) return;
    if (_emailInvalid) {
      setState(() => _emailTouched = true);
      _emailFocus.requestFocus();
      return;
    }

    FocusScope.of(context).unfocus();
    setState(() => _saving = true);
    try {
      await ref.read(authControllerProvider.notifier).completeProfile(
            name: _name,
            email: _email.isEmpty ? null : _email,
          );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      AppToast.error(context, AppLocalizations.of(context).profileSaveError);
      return;
    }

    if (!mounted) return;
    setState(() {
      _saving = false;
      _done = true;
      _firstName = _name.split(RegExp(r'\s+')).first;
    });
    Future.delayed(_welcomeDuration, _goHome);
  }

  void _goHome() {
    if (!mounted || _navigated) return;
    _navigated = true;
    context.go(AppRoutes.home);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_done,
      child: Scaffold(
        backgroundColor: AppColors.of(context).appBackground,
        body: SafeArea(
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 320),
            switchInCurve: Curves.easeOutCubic,
            child: _done ? _buildWelcome(context) : _buildForm(context),
          ),
        ),
      ),
    );
  }

  Widget _page({required Key key, required List<Widget> children}) {
    return LayoutBuilder(
      key: key,
      builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: IntrinsicHeight(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: children),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);

    return _page(
      key: const ValueKey('form'),
      children: [
        const SizedBox(height: 8),
        Align(
          alignment: Alignment.centerLeft,
          child: AppBackButton(
            onPressed: () => context.canPop() ? context.pop() : context.go(AppRoutes.login),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: _InitialAvatar(name: _name),
        ).animate().scale(duration: 400.ms, curve: Curves.elasticOut).fadeIn(duration: 300.ms),
        const SizedBox(height: 28),
        Text(
          l10n.profileSetupTitle,
          style: AppTypography.of(context).h1.copyWith(
                fontSize: 28,
                fontWeight: FontWeight.w700,
                color: colors.navy,
              ),
        ),
        const SizedBox(height: 6),
        Text(
          l10n.profileSetupSubtitle,
          style: AppTypography.of(context).body.copyWith(fontSize: 15, color: colors.bodyText),
        ),
        const SizedBox(height: 28),
        AutofillGroup(
          child: Column(
            children: [
              AppTextField(
                controller: _nameController,
                label: l10n.fullNameLabel,
                hint: l10n.fullNameHint,
                prefixIcon: AppIcons.person_vcard,
                textCapitalization: TextCapitalization.words,
                textInputAction: TextInputAction.next,
                autofillHints: const [AutofillHints.name],
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 18),
              AppTextField(
                controller: _emailController,
                focusNode: _emailFocus,
                label: l10n.emailOptionalLabel,
                hint: l10n.emailHint,
                prefixIcon: AppIcons.envelope,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.done,
                autofillHints: const [AutofillHints.email],
                errorText: _emailTouched && _emailInvalid ? l10n.validationEmailInvalid : null,
                onChanged: (_) => setState(() {}),
                onSubmitted: (_) => _continue(),
              ),
            ],
          ),
        ),
        const Spacer(),
        const SizedBox(height: 20),
        PrimaryButton(
          label: l10n.continueLabel,
          loading: _saving,
          onPressed: _name.isEmpty ? null : _continue,
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildWelcome(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final colors = AppColors.of(context);

    return _page(
      key: const ValueKey('welcome'),
      children: [
        const Spacer(flex: 2),
        const Center(child: AnimatedSuccessCheck(size: 88, iconSize: 44)),
        const SizedBox(height: 28),
        Column(
          children: [
            Text(
              l10n.profileSavedTitle(_firstName),
              textAlign: TextAlign.center,
              style: AppTypography.of(context).h1.copyWith(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: colors.navy,
                  ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.profileSavedMessage,
              textAlign: TextAlign.center,
              style: AppTypography.of(context).body.copyWith(fontSize: 15, color: colors.bodyText),
            ),
          ],
        )
            .animate(delay: 450.ms)
            .fadeIn(duration: 320.ms)
            .slideY(begin: 0.12, end: 0, duration: 320.ms, curve: Curves.easeOutCubic),
        const Spacer(flex: 3),
        PrimaryButton(
          label: l10n.startRidingButton,
          icon: AppIcons.arrow_right,
          onPressed: _goHome,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _InitialAvatar extends StatelessWidget {
  final String name;

  const _InitialAvatar({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = AppColors.of(context);
    final initial = name.isEmpty ? null : name.characters.first.toUpperCase();

    return Container(
      width: 96,
      height: 96,
      decoration: BoxDecoration(
        color: colors.primaryBackground,
        shape: BoxShape.circle,
        border: Border.all(color: colors.primaryBorder, width: 1.5),
      ),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 180),
        switchInCurve: Curves.easeOutBack,
        transitionBuilder: (child, animation) => ScaleTransition(
          scale: animation,
          child: FadeTransition(opacity: animation, child: child),
        ),
        child: initial == null
            ? Icon(
                AppIcons.person_fill,
                key: const ValueKey('empty'),
                size: 44,
                color: colors.primary.withValues(alpha: 0.55),
              )
            : Text(
                initial,
                key: ValueKey(initial),
                style: AppTypography.of(context).h1.copyWith(
                      fontSize: 40,
                      fontWeight: FontWeight.w800,
                      color: colors.primaryDark,
                    ),
              ),
      ),
    );
  }
}
