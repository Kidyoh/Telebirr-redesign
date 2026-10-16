import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../widgets/floating_nav.dart';
import '../widgets/pressable.dart';
import '../widgets/scan_button.dart';
import 'account_screen.dart';
import 'apps_screen.dart';
import 'engage_screen.dart';
import 'home_screen.dart';
import 'payment_screen.dart';
import 'scan_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  /// Tabs are built on first visit so their entrance plays when opened.
  final _visited = <int>{0};

  static const _tabs = <NavItem>[
    NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    NavItem('Payment', Icons.receipt_long_outlined, Icons.receipt_long_rounded),
    NavItem('Apps', Icons.grid_view_outlined, Icons.grid_view_rounded),
    NavItem('Engage', Icons.forum_outlined, Icons.forum_rounded),
    NavItem('Account', Icons.person_outline_rounded, Icons.person_rounded),
  ];

  final _pages = const <Widget>[
    HomeScreen(),
    PaymentScreen(),
    AppsScreen(),
    EngageScreen(),
    AccountScreen(),
  ];

  void _openScan() {
    haptic(HapticKind.medium);
    Navigator.of(context).push(
      PageRouteBuilder(
        transitionDuration: Motion.medium,
        reverseTransitionDuration: Motion.fast,
        pageBuilder: (_, a, _) => const ScanScreen(),
        transitionsBuilder: (_, a, _, child) {
          final t = CurvedAnimation(parent: a, curve: Motion.easeExpo);
          return FadeTransition(
            opacity: t,
            child: ScaleTransition(
              scale: Tween(begin: 1.06, end: 1.0).animate(t),
              child: child,
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.paddingOf(context).bottom;
    return Scaffold(
      extendBody: true,
      body: Stack(
        children: [
          // Tabs keep their state; the active one fades and settles in.
          for (var i = 0; i < _pages.length; i++)
            _TabLayer(
              active: i == _index,
              child: _visited.contains(i) ? _pages[i] : const SizedBox.shrink(),
            ),

          // Scan QR: the one hero CTA, only on Home.
          Positioned(
            left: TB.s32,
            right: TB.s32,
            bottom: bottomInset + 14 + 64 + TB.s12,
            child: AnimatedSwitcher(
              duration: Motion.medium,
              switchInCurve: Motion.easeExpo,
              switchOutCurve: Motion.easeOut,
              transitionBuilder: (child, a) => FadeTransition(
                opacity: a,
                child: SlideTransition(
                  position: Tween(
                    begin: const Offset(0, 0.4),
                    end: Offset.zero,
                  ).animate(a),
                  child: child,
                ),
              ),
              child: _index == 0
                  ? ScanButton(key: const ValueKey('scan'), onTap: _openScan)
                  : const SizedBox(key: ValueKey('none'), height: 56),
            ),
          ),

          Positioned(
            left: TB.s20,
            right: TB.s20,
            bottom: bottomInset + 14,
            child: FloatingNav(
              items: _tabs,
              index: _index,
              onChanged: (i) => setState(() {
                _index = i;
                _visited.add(i);
              }),
            ),
          ),
        ],
      ),
    );
  }
}

class _TabLayer extends StatelessWidget {
  const _TabLayer({required this.active, required this.child});

  final bool active;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    // The fade runs outside the TickerMode so a tab can still fade out
    // after its own animations are paused.
    return IgnorePointer(
      ignoring: !active,
      child: AnimatedOpacity(
        opacity: active ? 1 : 0,
        duration: active ? Motion.medium : Motion.fast,
        curve: Motion.easeOut,
        child: AnimatedScale(
          scale: active ? 1 : 0.985,
          duration: Motion.medium,
          curve: Motion.easeExpo,
          child: TickerMode(enabled: active, child: child),
        ),
      ),
    );
  }
}
