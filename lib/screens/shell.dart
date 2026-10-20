import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../theme/tokens.dart';
import '../widgets/bottom_nav.dart';
import 'account_screen.dart';
import 'analytics_screen.dart';
import 'apps_screen.dart';
import 'home_screen.dart';
import 'payment_screen.dart';

class Shell extends StatefulWidget {
  const Shell({super.key});

  @override
  State<Shell> createState() => _ShellState();
}

class _ShellState extends State<Shell> {
  int _index = 0;

  /// Tabs are built on first visit so their entrance plays when opened.
  final _visited = <int>{0};

  /// Home has its own navigator so Send Money keeps the tab bar, as in the
  /// design.
  final _homeNav = GlobalKey<NavigatorState>();

  static const _tabs = <NavItem>[
    NavItem('Home', Icons.home_outlined, Icons.home_rounded),
    NavItem(
      'Payment',
      Icons.account_balance_wallet_outlined,
      Icons.account_balance_wallet_rounded,
    ),
    NavItem('Apps', Icons.grid_view_outlined, Icons.grid_view_rounded),
    NavItem(
      'Analytics',
      Icons.insert_chart_outlined_rounded,
      Icons.insert_chart_rounded,
    ),
    NavItem('Setting', Icons.settings_outlined, Icons.settings_rounded),
  ];

  late final _pages = <Widget>[
    Navigator(
      key: _homeNav,
      onGenerateRoute: (_) =>
          MaterialPageRoute(builder: (_) => const HomeScreen()),
    ),
    const PaymentScreen(),
    const AppsScreen(),
    const AnalyticsScreen(),
    const AccountScreen(),
  ];

  void _select(int i) {
    if (i == _index) {
      // Tapping Home again returns to the top of Home.
      if (i == 0) _homeNav.currentState?.popUntil((r) => r.isFirst);
      return;
    }
    setState(() {
      _index = i;
      _visited.add(i);
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (didPop) return;
        final nav = _homeNav.currentState;
        if (_index == 0 && nav != null && nav.canPop()) {
          nav.pop();
        } else if (_index != 0) {
          _select(0);
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        backgroundColor: TB.ground,
        body: Stack(
          children: [
            for (var i = 0; i < _pages.length; i++)
              _TabLayer(
                active: i == _index,
                child: _visited.contains(i)
                    ? _pages[i]
                    : const SizedBox.shrink(),
              ),
          ],
        ),
        bottomNavigationBar: BottomNav(
          items: _tabs,
          index: _index,
          onChanged: _select,
        ),
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
        child: AnimatedSlide(
          offset: active ? Offset.zero : const Offset(0, 0.015),
          duration: Motion.medium,
          curve: Motion.easeExpo,
          child: TickerMode(enabled: active, child: child),
        ),
      ),
    );
  }
}
