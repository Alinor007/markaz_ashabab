import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import 'app_sidebar.dart';
import 'app_top_bar.dart';

/// The persistent application chrome: a permanent left sidebar plus a top
/// navigation bar above the routed content. Hosts every authenticated screen.
class AppShell extends StatelessWidget {
  const AppShell({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.ivory,
      // Don't shrink the body for the keyboard — it would squeeze the permanent
      // sidebar (the profile card slides up) and overflow content. The keyboard
      // overlays the bottom; search fields live at the top and stay visible.
      resizeToAvoidBottomInset: false,
      body: Row(
        children: [
          const AppSidebar(),
          Expanded(
            child: Column(
              children: [
                const AppTopBar(),
                // NOTE: the routed content is swapped directly (no
                // AnimatedSwitcher). go_router's ShellRoute child carries
                // GlobalKeys, so cross-fading two copies during a transition
                // triggers a "Duplicate GlobalKey" error that truncates the
                // tree (it broke dialogs such as Add Shu'ba).
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
