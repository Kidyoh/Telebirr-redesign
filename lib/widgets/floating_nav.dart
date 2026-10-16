import 'package:flutter/material.dart';

import '../theme/tokens.dart';
import '../theme/type.dart';
import 'glass.dart';
import 'pressable.dart';

class NavItem {
  const NavItem(this.label, this.icon, this.activeIcon);

  final String label;
  final IconData icon;
  final IconData activeIcon;
}

/// The floating glass nav: a frosted pill with a green indicator that springs
/// between tabs. Active icons are filled, idle ones outlined.
class FloatingNav extends StatelessWidget {
  const FloatingNav({
    super.key,
    required this.items,
    required this.index,
    required this.onChanged,
  });

  final List<NavItem> items;
  final int index;
  final ValueChanged<int> onChanged;

  static const height = 64.0;

  @override
  Widget build(BuildContext context) {
    return GlassPanel(
      radius: TB.rPill,
      blur: TB.blurBar,
      fill: const Color(0xD9FFFFFF),
      rim: TB.glassRimPaper,
      shadow: const [
        BoxShadow(
          color: Color(0x1F1C1B19),
          blurRadius: 30,
          offset: Offset(0, 12),
        ),
      ],
      padding: const EdgeInsets.all(6),
      child: SizedBox(
        height: height - 12,
        child: LayoutBuilder(
          builder: (context, c) {
            final w = c.maxWidth / items.length;
            return Stack(
              children: [
                AnimatedPositioned(
                  duration: Motion.medium,
                  curve: Motion.easeSpring,
                  left: w * index,
                  top: 0,
                  bottom: 0,
                  width: w,
                  child: Container(
                    decoration: BoxDecoration(
                      color: TB.brand,
                      borderRadius: BorderRadius.circular(TB.rPill),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x478CC63F),
                          blurRadius: 14,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                  ),
                ),
                Row(
                  children: [
                    for (var i = 0; i < items.length; i++)
                      Expanded(
                        child: Pressable(
                          scale: Motion.pressRound,
                          semanticLabel: items[i].label,
                          onTap: () {
                            if (i != index) onChanged(i);
                          },
                          child: _NavCell(item: items[i], active: i == index),
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _NavCell extends StatelessWidget {
  const _NavCell({required this.item, required this.active});

  final NavItem item;
  final bool active;

  @override
  Widget build(BuildContext context) {
    final color = active ? Colors.white : TB.inkSoft;
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AnimatedSwitcher(
          duration: Motion.fast,
          transitionBuilder: (c, a) => ScaleTransition(
            scale: Tween(
              begin: 0.6,
              end: 1.0,
            ).animate(CurvedAnimation(parent: a, curve: Motion.easeBack)),
            child: FadeTransition(opacity: a, child: c),
          ),
          child: Icon(
            active ? item.activeIcon : item.icon,
            key: ValueKey(active),
            size: 22,
            color: color,
          ),
        ),
        const SizedBox(height: 2),
        AnimatedDefaultTextStyle(
          duration: Motion.fast,
          style: TType.micro.copyWith(
            color: color,
            fontWeight: active ? FontWeight.w600 : FontWeight.w500,
          ),
          child: Text(item.label, maxLines: 1),
        ),
      ],
    );
  }
}
