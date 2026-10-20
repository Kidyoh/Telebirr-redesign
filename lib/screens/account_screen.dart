import 'package:flutter/material.dart';

import '../data/services.dart';
import '../data/wallet.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/pressable.dart';
import '../widgets/qr_sheet.dart';
import '../widgets/reveal.dart';
import '../widgets/wave_card.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  bool _amharic = false;
  bool _biometric = true;

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    var groupIndex = 0;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: _ProfileHero()),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(TB.s20, TB.s24, TB.s20, bottom + TB.s32),
          sliver: SliverList.list(
            children: [
              for (final entry in accountGroups.entries) ...[
                Reveal(
                  index: groupIndex++,
                  child: _Group(
                    title: entry.key,
                    children: [
                      for (final item in entry.value)
                        _Row(
                          item: item,
                          trailing: switch (item.label) {
                            'Change Language' => _LangToggle(
                              amharic: _amharic,
                              onChanged: (v) => setState(() => _amharic = v),
                            ),
                            'Biometric Authentication' => _Toggle(
                              value: _biometric,
                              onChanged: (v) => setState(() => _biometric = v),
                            ),
                            _ => null,
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: TB.s24),
              ],
              Reveal(
                index: groupIndex,
                child: Pressable(
                  scale: Motion.pressPill,
                  haptic: HapticKind.medium,
                  onTap: () {},
                  child: Container(
                    height: 54,
                    decoration: BoxDecoration(
                      color: TB.surfaceRaised,
                      borderRadius: BorderRadius.circular(TB.rPill),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.logout_rounded,
                          color: TB.danger,
                          size: 20,
                        ),
                        const SizedBox(width: TB.s8),
                        Text(
                          'Log out',
                          style: TType.uiLabel.copyWith(color: TB.danger),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: TB.s16),
              Center(
                child: Text('telebirr · version 6.0', style: TType.caption),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ProfileHero extends StatelessWidget {
  const _ProfileHero();

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(TB.s20, top + TB.s16, TB.s20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Reveal(
            child: Text(
              'SETTING',
              style: TType.eyebrow.copyWith(color: TB.inkFaint),
            ),
          ),
          const SizedBox(height: 6),
          Reveal(
            index: 1,
            child: Text(
              'Your account',
              style: TType.title1.copyWith(
                color: TB.ink,
                fontSize: 24,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(height: TB.s16),
          Reveal(
            index: 2,
            child: WaveCard(
              height: 150,
              waveDepth: 0.5,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 54,
                          height: 54,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.5),
                              width: 3,
                            ),
                          ),
                          child: const Icon(
                            Icons.person_rounded,
                            color: TB.brandDeep,
                            size: 32,
                          ),
                        ),
                        const Spacer(),
                        Pressable(
                          scale: Motion.pressRound,
                          haptic: HapticKind.light,
                          semanticLabel: 'My QR code',
                          onTap: () => showQrSheet(context),
                          child: Container(
                            width: 44,
                            height: 44,
                            decoration: const BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.qr_code_2_rounded,
                              color: TB.night,
                              size: 24,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Text(
                          Wallet.ownerName,
                          style: TType.title2.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: TB.s8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: TB.ribbon,
                            borderRadius: BorderRadius.circular(TB.rPill),
                          ),
                          child: Text(
                            'Level 3',
                            style: TType.micro.copyWith(
                              color: TB.ribbonInk,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        Text(
                          Wallet.ownerPhoneMasked,
                          style: TType.caption.copyWith(
                            color: Colors.white.withValues(alpha: 0.8),
                            fontFeatures: const [FontFeature.tabularFigures()],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Group extends StatelessWidget {
  const _Group({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: TB.s8, bottom: TB.s8),
          child: Text(title, style: TType.labelCaps),
        ),
        Container(
          decoration: BoxDecoration(
            color: TB.surfaceRaised,
            borderRadius: BorderRadius.circular(TB.rLg),
            boxShadow: TB.shadowSoft,
          ),
          child: Column(
            children: [
              for (var i = 0; i < children.length; i++) ...[
                if (i > 0)
                  const Divider(
                    height: 1,
                    indent: 68,
                    endIndent: 16,
                    color: TB.hairline,
                  ),
                children[i],
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({required this.item, this.trailing});

  final AccountItem item;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: 0.98,
      onTap: () {},
      semanticLabel: item.label,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: TB.s16, vertical: 12),
        child: Row(
          children: [
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: TB.brandMist,
                shape: BoxShape.circle,
              ),
              child: item.logo != null
                  ? ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Image.asset(item.logo!, fit: BoxFit.contain),
                      ),
                    )
                  : Icon(item.icon, color: TB.brandInk, size: 20),
            ),
            const SizedBox(width: TB.s16),
            Expanded(
              child: Text(
                item.label,
                style: TType.body.copyWith(
                  color: TB.ink,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            trailing ??
                const Icon(
                  Icons.chevron_right_rounded,
                  color: TB.inkFaint,
                  size: 22,
                ),
          ],
        ),
      ),
    );
  }
}

/// English / አማርኛ segmented pill with a sliding thumb.
class _LangToggle extends StatelessWidget {
  const _LangToggle({required this.amharic, required this.onChanged});

  final bool amharic;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    const w = 52.0;
    return Container(
      height: 32,
      width: w * 2 + 4,
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: TB.surface,
        borderRadius: BorderRadius.circular(TB.rPill),
      ),
      child: Stack(
        children: [
          AnimatedAlign(
            duration: Motion.medium,
            curve: Motion.easeSpring,
            alignment: amharic ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              width: w,
              decoration: BoxDecoration(
                color: TB.button,
                borderRadius: BorderRadius.circular(TB.rPill),
              ),
            ),
          ),
          Row(
            children: [
              for (final (label, isAm) in [('EN', false), ('አማ', true)])
                Expanded(
                  child: Pressable(
                    scale: Motion.pressPill,
                    onTap: () => onChanged(isAm),
                    child: Center(
                      child: AnimatedDefaultTextStyle(
                        duration: Motion.fast,
                        style: TType.caption.copyWith(
                          fontWeight: FontWeight.w600,
                          color: amharic == isAm ? TB.onButton : TB.inkSoft,
                        ),
                        child: Text(label),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

/// A borderless pill switch: green when on, with a springy thumb.
class _Toggle extends StatelessWidget {
  const _Toggle({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressPill,
      semanticLabel: value ? 'On' : 'Off',
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: Motion.fast,
        width: 50,
        height: 30,
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: value ? TB.brand : TB.track,
          borderRadius: BorderRadius.circular(TB.rPill),
        ),
        child: AnimatedAlign(
          duration: Motion.medium,
          curve: Motion.easeSpring,
          alignment: value ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: 24,
            height: 24,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Color(0x26000000),
                  blurRadius: 6,
                  offset: Offset(0, 2),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
