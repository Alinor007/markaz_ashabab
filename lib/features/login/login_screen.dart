import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/auth/session_controller.dart';
import '../../core/i18n/strings.dart';
import '../../core/patterns/geometric_pattern.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_dimens.dart';
import '../../core/theme/app_typography.dart';
import '../../widgets/common/app_checkbox.dart';
import '../../widgets/common/app_text_field.dart';
import '../../widgets/common/brand_emblem.dart';
import '../../widgets/common/primary_button.dart';

/// Split-screen login: brand / mission panel on the left, credential card on
/// the right. No registration, sign-up, or password recovery (by design).
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _username = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _errorKey;

  @override
  void dispose() {
    _username.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _busy = true;
      _errorKey = null;
    });
    final result = await context.read<SessionController>().signIn(
          username: _username.text,
          password: _password.text,
        );
    if (!mounted) return;
    if (result == null) {
      context.go('/home');
    } else {
      setState(() {
        _busy = false;
        _errorKey = result;
      });
    }
  }

  String _errorMessage(bool isArabic) {
    switch (_errorKey) {
      case 'empty':
        return 'Please enter your username and password.';
      case 'invalid':
        return 'Invalid username or password.';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Don't shrink the split-screen for the keyboard (it shifts/squeezes the
      // layout). The keyboard overlays the bottom; the credential panel's bottom
      // inset padding lifts its fields above the keyboard.
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          const Expanded(flex: 6, child: _BrandPanel()),
          Expanded(flex: 5, child: _buildLoginPanel(context)),
        ],
      ),
    );
  }

  Widget _buildLoginPanel(BuildContext context) {
    final s = AppStrings.of(context);
    final theme = Theme.of(context);
    final session = context.watch<SessionController>();

    return Container(
      color: AppColors.ivory,
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        left: AppSpacing.xxl,
        right: AppSpacing.xxl,
        top: AppSpacing.xxl,
        // Extra room so the focused field clears the keyboard.
        bottom: AppSpacing.xxl + MediaQuery.viewInsetsOf(context).bottom,
      ),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(s.loginTitle, style: theme.textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.sm),
              Text(s.loginSubtitle, style: theme.textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.xxl),
              AppTextField(
                label: s.username,
                hint: s.usernameHint,
                controller: _username,
                icon: Icons.person_outline,
                textInputAction: TextInputAction.next,
              ),
              const SizedBox(height: AppSpacing.lg),
              AppTextField(
                label: s.password,
                hint: s.passwordHint,
                controller: _password,
                icon: Icons.lock_outline,
                obscure: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppCheckbox(
                    value: session.rememberMe,
                    onChanged: (v) =>
                        context.read<SessionController>().setRememberMe(v),
                    label: s.rememberMe,
                  ),
                ],
              ),
              if (_errorKey != null) ...[
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    const Icon(Icons.error_outline,
                        size: 16, color: AppColors.error),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Text(
                        _errorMessage(false),
                        style: theme.textTheme.bodySmall
                            ?.copyWith(color: AppColors.error),
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: AppSpacing.xl),
              PrimaryButton(
                label: s.login,
                icon: Icons.login,
                expand: true,
                busy: _busy,
                onPressed: _submit,
              ),
              const SizedBox(height: AppSpacing.xxl),
              Center(
                child: Text(
                  '© ${DateTime.now().year} ${s.orgName}',
                  style: theme.textTheme.bodySmall
                      ?.copyWith(color: AppColors.textFaint),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class _BrandPanel extends StatelessWidget {
  const _BrandPanel();

  @override
  Widget build(BuildContext context) {
    final s = AppStrings.of(context);
    return Container(
      color: AppColors.emerald,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // Subtle darker base toward the bottom for depth (not a bright gradient).
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [AppColors.emerald, AppColors.emeraldDark],
              ),
            ),
          ),
          const GeometricPattern(
            color: Colors.white,
            opacity: 0.07,
            tile: 110,
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xxxl),
            // Scroll instead of overflowing when the keyboard shrinks the panel.
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const BrandEmblem(size: 160, onLight: false),
                  const SizedBox(height: AppSpacing.xxxl),
                  Text(
                    s.orgNameArabic,
                    textDirection: TextDirection.rtl,
                    style: AppTypography.arabic(
                      fontSize: 40,
                      color: AppColors.gold,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    s.orgName,
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                          color: AppColors.onEmerald,
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Container(width: 64, height: 3, color: AppColors.gold),
                  const SizedBox(height: AppSpacing.xl),
                  ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 460),
                    child: Text(
                      s.missionStatement,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.white.withValues(alpha: 0.85),
                            height: 1.7,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
