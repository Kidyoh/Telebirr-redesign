import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import '../data/services.dart';
import '../data/wallet.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import '../widgets/pressable.dart';
import '../widgets/reveal.dart';

/// Send Money: pick someone in the dark header, type an amount on the round
/// keypad, then confirm in a sheet that turns into the receipt.
class SendMoneyScreen extends StatefulWidget {
  const SendMoneyScreen({super.key, this.initial});

  final Contact? initial;

  @override
  State<SendMoneyScreen> createState() => _SendMoneyScreenState();
}

class _SendMoneyScreenState extends State<SendMoneyScreen> {
  late int _contact = widget.initial == null
      ? 0
      : recentContacts.indexWhere((c) => c.name == widget.initial!.name);
  String _amount = '';
  bool _shake = false;

  int get _value => int.tryParse(_amount) ?? 0;

  void _key(String k) {
    setState(() {
      if (k == '<') {
        if (_amount.isNotEmpty) {
          _amount = _amount.substring(0, _amount.length - 1);
        }
        return;
      }
      if (_amount.length >= 6) return;
      if (_amount.isEmpty && k == '0') return;
      _amount += k;
    });
  }

  Future<void> _send() async {
    if (_value <= 0) return;
    if (_value + Wallet.fee > Wallet.balance.value) {
      haptic(HapticKind.medium);
      setState(() => _shake = !_shake);
      return;
    }
    haptic(HapticKind.light);
    final sent = await showTransferSheet(
      context,
      to: recentContacts[_contact],
      amount: _value.toDouble(),
      // Keep the keypad in step with the ruler if the sheet is closed.
      onAmountChanged: (v) {
        if (mounted) setState(() => _amount = v.round().toString());
      },
    );
    if (sent == true && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final to = recentContacts[_contact];
    final over = _value + Wallet.fee > Wallet.balance.value && _value > 0;
    return Scaffold(
      backgroundColor: TB.ground,
      body: Column(
        children: [
          _Header(
            selected: _contact,
            onSelect: (i) => setState(() => _contact = i),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: TB.s20),
              child: Column(
                children: [
                  const Spacer(),
                  Row(
                    children: [
                      const SizedBox(width: 72),
                      Expanded(
                        child: Column(
                          children: [
                            Text(
                              'Send To',
                              style: TType.caption.copyWith(
                                color: TB.inkFaint,
                                fontSize: 12,
                              ),
                            ),
                            AnimatedSwitcher(
                              duration: Motion.fast,
                              transitionBuilder: (c, a) => FadeTransition(
                                opacity: a,
                                child: SlideTransition(
                                  position: Tween(
                                    begin: const Offset(0, 0.4),
                                    end: Offset.zero,
                                  ).animate(a),
                                  child: c,
                                ),
                              ),
                              child: Text(
                                to.name.toUpperCase(),
                                key: ValueKey(to.name),
                                style: TType.bodyStrong.copyWith(
                                  color: TB.ink,
                                  letterSpacing: 0.6,
                                ),
                              ),
                            ),
                            _Shake(
                              trigger: _shake,
                              child: _Amount(text: _amount, over: over),
                            ),
                            AnimatedSwitcher(
                              duration: Motion.fast,
                              child: Text(
                                over ? 'NOT ENOUGH BALANCE' : 'AMOUNT',
                                key: ValueKey(over),
                                style: TType.micro.copyWith(
                                  color: over ? TB.danger : TB.inkFaint,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        width: 72,
                        child: _SendButton(enabled: _value > 0, onTap: _send),
                      ),
                    ],
                  ),
                  const Spacer(),
                  _Keypad(onKey: _key),
                  const SizedBox(height: TB.s16),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Header ────────────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  const _Header({required this.selected, required this.onSelect});

  final int selected;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.paddingOf(context).top;
    return Padding(
      padding: EdgeInsets.fromLTRB(12, top + 8, 12, 0),
      child: Hero(
        tag: 'send-card',
        // Fly as a plain dark card; the header's content fades in after.
        flightShuttleBuilder: (_, a, _, _, _) => AnimatedBuilder(
          animation: a,
          builder: (_, _) => DecoratedBox(
            decoration: BoxDecoration(
              color: TB.night,
              borderRadius: BorderRadius.circular(20 + 8 * a.value),
            ),
          ),
        ),
        child: Container(
          padding: const EdgeInsets.fromLTRB(8, 6, 8, 22),
          decoration: BoxDecoration(
            color: TB.night,
            borderRadius: BorderRadius.circular(28),
          ),
          child: Material(
            type: MaterialType.transparency,
            child: Column(
              children: [
                Row(
                  children: [
                    Pressable(
                      scale: Motion.pressRound,
                      semanticLabel: 'Back',
                      onTap: () => Navigator.of(context).pop(),
                      child: const SizedBox(
                        width: 44,
                        height: 44,
                        child: Icon(
                          Icons.arrow_back_rounded,
                          color: Colors.white,
                          size: 22,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Text(
                        'Send Money',
                        style: TType.bodyStrong.copyWith(color: Colors.white),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: TB.s8),
                SizedBox(
                  height: 78,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    itemCount: recentContacts.length + 1,
                    separatorBuilder: (_, _) => const SizedBox(width: 18),
                    itemBuilder: (context, i) {
                      if (i == 0) {
                        return const _Bubble(
                          label: 'New',
                          fill: TB.brand,
                          ring: Color(0x558CC63F),
                          child: Icon(
                            Icons.add_rounded,
                            color: Colors.white,
                            size: 26,
                          ),
                        );
                      }
                      final idx = i - 1;
                      final c = recentContacts[idx];
                      final on = idx == selected;
                      return Reveal(
                        index: i,
                        baseDelay: Motion.fast,
                        child: Pressable(
                          scale: Motion.pressRound,
                          semanticLabel: c.name,
                          onTap: () => onSelect(idx),
                          child: _Bubble(
                            label: c.firstName,
                            fill: on ? Colors.white : TB.brand,
                            ring: on ? TB.ribbon : const Color(0x558CC63F),
                            child: Text(
                              c.initials,
                              style: TType.bodyStrong.copyWith(
                                color: on ? TB.ink : Colors.white,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: TB.s12),
                ValueListenableBuilder<double>(
                  valueListenable: Wallet.balance,
                  builder: (context, b, _) {
                    final parts = formatEtb(b).split('.');
                    return Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(text: parts[0]),
                          TextSpan(
                            text: '.${parts[1]}',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                      style: TType.title1.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                        fontSize: 26,
                        fontFeatures: const [FontFeature.tabularFigures()],
                      ),
                    );
                  },
                ),
                const SizedBox(height: 2),
                Text(
                  'TOTAL BALANCE',
                  style: TType.micro.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1.2,
                    fontSize: 10,
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

/// A contact bubble: a filled disc with a soft ring, the name underneath.
class _Bubble extends StatelessWidget {
  const _Bubble({
    required this.label,
    required this.fill,
    required this.ring,
    required this.child,
  });

  final String label;
  final Color fill;
  final Color ring;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedContainer(
          duration: Motion.medium,
          curve: Motion.easeSpring,
          width: 52,
          height: 52,
          decoration: BoxDecoration(
            color: fill,
            shape: BoxShape.circle,
            border: Border.all(color: ring, width: 3),
          ),
          alignment: Alignment.center,
          child: child,
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: TType.micro.copyWith(color: Colors.white, fontSize: 10.5),
        ),
      ],
    );
  }
}

// ── Amount + send ─────────────────────────────────────────────────────────

class _Amount extends StatelessWidget {
  const _Amount({required this.text, required this.over});

  final String text;
  final bool over;

  @override
  Widget build(BuildContext context) {
    final shown = text.isEmpty
        ? '0'
        : formatEtb(double.parse(text), decimals: false);
    final color = over ? TB.danger : TB.ink;
    return SizedBox(
      height: 64,
      child: FittedBox(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (var i = 0; i < shown.length; i++)
              TweenAnimationBuilder<double>(
                key: ValueKey('${shown.length}-$i-${shown[i]}'),
                tween: Tween(begin: 0, end: 1),
                duration: Motion.medium,
                curve: Motion.easeBack,
                builder: (context, t, child) => Opacity(
                  opacity: t.clamp(0.0, 1.0),
                  child: Transform.translate(
                    offset: Offset(0, 14 * (1 - t)),
                    child: child,
                  ),
                ),
                child: AnimatedDefaultTextStyle(
                  duration: Motion.fast,
                  style: TType.numeralHero.copyWith(
                    fontSize: 52,
                    fontWeight: FontWeight.w400,
                    letterSpacing: -1.5,
                    color: color,
                  ),
                  child: Text(shown[i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.enabled, required this.onTap});

  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Motion.fast,
      opacity: enabled ? 1 : 0.45,
      child: Pressable(
        scale: Motion.pressRound,
        haptic: HapticKind.none,
        semanticLabel: 'Send',
        onTap: onTap,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AnimatedContainer(
              duration: Motion.medium,
              width: 54,
              height: 54,
              decoration: BoxDecoration(
                color: TB.brand,
                shape: BoxShape.circle,
                boxShadow: enabled
                    ? const [
                        BoxShadow(
                          color: Color(0x668CC63F),
                          blurRadius: 16,
                          offset: Offset(0, 6),
                        ),
                      ]
                    : const [],
              ),
              child: const Icon(
                Icons.north_east_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(height: 6),
            Text('Send', style: TType.caption.copyWith(color: TB.ink)),
          ],
        ),
      ),
    );
  }
}

class _Shake extends StatelessWidget {
  const _Shake({required this.trigger, required this.child});

  final bool trigger;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      key: ValueKey(trigger),
      tween: Tween(begin: 0, end: 1),
      duration: Motion.medium,
      builder: (context, t, child) {
        final dx = (1 - t) * 10 * math.sin(t * 6 * math.pi);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
      child: child,
    );
  }
}

class _Keypad extends StatelessWidget {
  const _Keypad({required this.onKey});

  final ValueChanged<String> onKey;

  @override
  Widget build(BuildContext context) {
    const rows = [
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      ['', '0', '<'],
    ];
    return Column(
      children: [
        for (final row in rows)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (final k in row)
                  k.isEmpty
                      ? const SizedBox(width: 64, height: 64)
                      : Pressable(
                          scale: Motion.pressRound,
                          semanticLabel: k == '<' ? 'Delete' : k,
                          onTap: () => onKey(k),
                          child: Container(
                            width: 64,
                            height: 64,
                            decoration: BoxDecoration(
                              color: k == '<' ? Colors.transparent : TB.keyFill,
                              shape: BoxShape.circle,
                              border: k == '<'
                                  ? null
                                  : Border.all(color: TB.keyRim),
                            ),
                            alignment: Alignment.center,
                            child: k == '<'
                                ? const Icon(
                                    Icons.chevron_left_rounded,
                                    color: TB.ink,
                                    size: 28,
                                  )
                                : Text(
                                    k,
                                    style: TType.title1.copyWith(
                                      color: TB.ink,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                          ),
                        ),
              ],
            ),
          ),
      ],
    );
  }
}

// ── Confirm → success sheet ───────────────────────────────────────────────

/// Blurs the screen behind and slides up the confirm sheet. Resolves to true
/// once the money has been sent and the receipt dismissed.
Future<bool?> showTransferSheet(
  BuildContext context, {
  required Contact to,
  required double amount,
  ValueChanged<double>? onAmountChanged,
}) {
  return showGeneralDialog<bool>(
    context: context,
    useRootNavigator: true,
    barrierDismissible: true,
    barrierLabel: 'Close',
    barrierColor: Colors.transparent,
    transitionDuration: Motion.slow,
    pageBuilder: (_, _, _) => _TransferSheet(
      to: to,
      amount: amount,
      onAmountChanged: onAmountChanged,
    ),
    transitionBuilder: (context, a, _, child) {
      final t = CurvedAnimation(
        parent: a,
        curve: Motion.easeExpo,
        reverseCurve: Motion.easeOut,
      );
      return AnimatedBuilder(
        animation: t,
        child: child,
        builder: (context, child) => Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: BackdropFilter(
                  filter: ImageFilter.blur(
                    sigmaX: 14 * t.value,
                    sigmaY: 14 * t.value,
                  ),
                  child: ColoredBox(
                    color: Colors.white.withValues(alpha: 0.35 * t.value),
                  ),
                ),
              ),
            ),
            FractionalTranslation(
              translation: Offset(0, 1 - t.value),
              child: child,
            ),
          ],
        ),
      );
    },
  );
}

enum _Stage { confirm, sending, leaving, done }

class _TransferSheet extends StatefulWidget {
  const _TransferSheet({
    required this.to,
    required this.amount,
    this.onAmountChanged,
  });

  final Contact to;
  final double amount;
  final ValueChanged<double>? onAmountChanged;

  @override
  State<_TransferSheet> createState() => _TransferSheetState();
}

class _TransferSheetState extends State<_TransferSheet> {
  _Stage _stage = _Stage.confirm;
  final _note = TextEditingController();
  late double _amount = widget.amount;
  late final DateTime _at;
  late final String _txnId;

  double get _total => _amount + Wallet.fee;

  /// The most you can send and still cover the fee.
  double get _max =>
      math.max(1, (Wallet.balance.value - Wallet.fee).floorToDouble());

  @override
  void dispose() {
    _note.dispose();
    super.dispose();
  }

  void _setAmount(double v) {
    setState(() => _amount = v);
    widget.onAmountChanged?.call(v);
  }

  Future<void> _confirm() async {
    haptic(HapticKind.light);
    FocusScope.of(context).unfocus();
    setState(() => _stage = _Stage.sending);
    await Future.delayed(const Duration(milliseconds: 900));
    if (!mounted) return;
    _at = DateTime.now();
    _txnId = 'TB${_at.millisecondsSinceEpoch}';
    Wallet.balance.value -= _total;
    haptic(HapticKind.heavy);
    // Clear the confirm content first, then let the sheet resize and the
    // receipt build itself in, so the two never overlap.
    setState(() => _stage = _Stage.leaving);
    await Future.delayed(Motion.fast);
    if (!mounted) return;
    setState(() => _stage = _Stage.done);
  }

  @override
  Widget build(BuildContext context) {
    final pad = MediaQuery.paddingOf(context);
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    final leaving = _stage == _Stage.leaving;
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          12,
          pad.top + 60,
          12,
          math.max(pad.bottom, keyboard) + 12,
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
          clipBehavior: Clip.antiAlias,
          elevation: 0,
          child: AnimatedSize(
            duration: Motion.medium,
            curve: Motion.easeOut,
            alignment: Alignment.bottomCenter,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(22, 14, 22, 24),
              child: _stage == _Stage.done
                  ? _Receipt(
                      to: widget.to,
                      amount: _amount,
                      at: _at,
                      txnId: _txnId,
                      onDone: () => Navigator.of(context).pop(true),
                    )
                  : _Confirm(
                      to: widget.to,
                      amount: _amount,
                      max: _max,
                      note: _note,
                      sending: _stage != _Stage.confirm,
                      leaving: leaving,
                      onAmountChanged: _setAmount,
                      onConfirm: _confirm,
                      onClose: () => Navigator.of(context).pop(),
                    ),
            ),
          ),
        ),
      ),
    );
  }
}

class _Confirm extends StatelessWidget {
  const _Confirm({
    required this.to,
    required this.amount,
    required this.max,
    required this.note,
    required this.sending,
    required this.leaving,
    required this.onAmountChanged,
    required this.onConfirm,
    required this.onClose,
  });

  final Contact to;
  final double amount;
  final double max;
  final TextEditingController note;
  final bool sending;

  /// Fading out for the receipt; the button stays so it can carry over.
  final bool leaving;
  final ValueChanged<double> onAmountChanged;
  final VoidCallback onConfirm;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AnimatedOpacity(
          opacity: leaving ? 0 : 1,
          duration: Motion.fast,
          curve: Motion.easeOut,
          child: AnimatedSlide(
            offset: leaving ? const Offset(0, 0.02) : Offset.zero,
            duration: Motion.fast,
            curve: Motion.easeOut,
            child: Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: Pressable(
                    scale: Motion.pressRound,
                    semanticLabel: 'Close',
                    onTap: onClose,
                    child: Container(
                      width: 30,
                      height: 30,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        border: Border.all(color: TB.keyRim),
                      ),
                      child: const Icon(
                        Icons.close_rounded,
                        size: 16,
                        color: TB.ink,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: TB.s8),
                Text(
                  'Confirm Transaction',
                  style: TType.title2.copyWith(color: TB.ink, fontSize: 19),
                ),
                const SizedBox(height: 6),
                Text(
                  'Please confirm your transaction\nbefore sending to this account',
                  textAlign: TextAlign.center,
                  style: TType.caption.copyWith(
                    color: TB.inkFaint,
                    fontSize: 12.5,
                  ),
                ),
                const SizedBox(height: TB.s20),
                IgnorePointer(
                  ignoring: sending,
                  child: _AmountDial(
                    initial: amount,
                    min: 1,
                    max: max,
                    onChanged: onAmountChanged,
                  ),
                ),
                const SizedBox(height: TB.s20),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: TB.keyRim),
                  ),
                  child: Column(
                    children: [
                      _Line('Sending From', Wallet.ownerName),
                      _Line('Sending To', to.name),
                    ],
                  ),
                ),
                const SizedBox(height: TB.s12),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    children: [
                      _Line('Fee', Wallet.fee.toStringAsFixed(2)),
                      const _Line('Speed', 'Arrives Instantly'),
                      _NoteLine(controller: note),
                      _Line(
                        'Total',
                        formatEtb(amount + Wallet.fee),
                        strong: true,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: TB.s24),
        _GreenButton(
          label: 'Confirm',
          loading: sending,
          onTap: sending ? null : onConfirm,
        ),
      ],
    );
  }
}

/// The amount over a ruler. It counts up into place when the sheet opens,
/// then you can drag or fling the ruler to adjust it, one birr per tick,
/// with a tick of haptics as each birr passes the needle.
class _AmountDial extends StatefulWidget {
  const _AmountDial({
    required this.initial,
    required this.min,
    required this.max,
    required this.onChanged,
  });

  final double initial;
  final double min;
  final double max;
  final ValueChanged<double> onChanged;

  @override
  State<_AmountDial> createState() => _AmountDialState();
}

class _AmountDialState extends State<_AmountDial>
    with SingleTickerProviderStateMixin {
  static const _gap = 9.0;

  late final AnimationController _c = AnimationController.unbounded(vsync: this)
    ..addListener(_onTick);

  bool _interactive = false;
  bool _touched = false;
  late int _last = widget.initial.round();

  @override
  void initState() {
    super.initState();
    _c
        .animateTo(
          widget.initial,
          duration: const Duration(milliseconds: 1100),
          curve: Motion.easeExpo,
        )
        .whenComplete(() => _interactive = true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  void _onTick() {
    final v = _c.value;
    // Stop a fling at either end instead of running past it.
    if (_interactive && (v < widget.min || v > widget.max)) {
      _c.stop();
      _c.value = v.clamp(widget.min, widget.max);
      haptic(HapticKind.light);
      return;
    }
    final r = v.round();
    if (_interactive && r != _last) {
      _last = r;
      haptic(HapticKind.selection);
      widget.onChanged(r.toDouble());
    }
  }

  void _dragStart(DragStartDetails _) {
    if (!_interactive) return;
    _c.stop();
    if (!_touched) setState(() => _touched = true);
  }

  void _dragUpdate(DragUpdateDetails d) {
    if (!_interactive) return;
    // Dragging left moves the ruler left, which brings bigger numbers in.
    _c.value = (_c.value - d.delta.dx / _gap).clamp(widget.min, widget.max);
  }

  void _dragEnd(DragEndDetails d) {
    if (!_interactive) return;
    final v = -d.velocity.pixelsPerSecond.dx / _gap;
    if (v.abs() < 4) {
      _snap();
      return;
    }
    _c.animateWith(FrictionSimulation(0.08, _c.value, v)).whenComplete(_snap);
  }

  void _snap() {
    final target = _c.value.round().toDouble().clamp(widget.min, widget.max);
    _c.animateTo(target, duration: Motion.fast, curve: Motion.easeOut);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onHorizontalDragStart: _dragStart,
      onHorizontalDragUpdate: _dragUpdate,
      onHorizontalDragEnd: _dragEnd,
      child: AnimatedBuilder(
        animation: _c,
        builder: (context, _) {
          final v = _c.value;
          return Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 34,
                child: CustomPaint(painter: _RulerPainter(v, _gap)),
              ),
              const SizedBox(height: TB.s8),
              Text(
                formatEtb(v.roundToDouble(), decimals: false),
                style: TType.numeralHero.copyWith(
                  fontSize: 44,
                  fontWeight: FontWeight.w500,
                  letterSpacing: -1,
                  color: TB.ink,
                ),
              ),
              const SizedBox(height: 4),
              AnimatedOpacity(
                opacity: _touched ? 0 : 1,
                duration: Motion.medium,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.swap_horiz_rounded,
                      size: 14,
                      color: TB.inkFaint,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'Drag the ruler to adjust',
                      style: TType.micro.copyWith(
                        color: TB.inkFaint,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _RulerPainter extends CustomPainter {
  _RulerPainter(this.value, this.gap);

  /// The amount under the needle; whole birr sit on ticks.
  final double value;
  final double gap;

  @override
  void paint(Canvas canvas, Size size) {
    final mid = size.width / 2;
    final base = value.floor();
    final frac = value - base;
    final count = (mid / gap).ceil() + 1;
    final p = Paint()
      ..strokeCap = StrokeCap.round
      ..strokeWidth = 1.4;
    for (var i = -count; i <= count; i++) {
      final n = base + i;
      if (n < 0) continue;
      final x = mid + (i - frac) * gap;
      if (x < 0 || x > size.width) continue;
      final edge = 1 - ((x - mid).abs() / mid).clamp(0.0, 1.0);
      final h = n % 10 == 0 ? 18.0 : (n % 5 == 0 ? 13.0 : 8.0);
      p.color = TB.inkFaint.withValues(alpha: 0.08 + 0.5 * edge * edge);
      canvas.drawLine(Offset(x, size.height - h), Offset(x, size.height), p);
    }
    canvas.drawLine(
      Offset(mid, 2),
      Offset(mid, size.height),
      Paint()
        ..color = TB.ink
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round,
    );
  }

  @override
  bool shouldRepaint(covariant _RulerPainter old) => old.value != value;
}

class _Line extends StatelessWidget {
  const _Line(this.label, this.value, {this.strong = false, this.trailing});

  final String label;
  final String value;
  final bool strong;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        children: [
          Text(
            label,
            style: TType.caption.copyWith(color: TB.inkFaint, fontSize: 12.5),
          ),
          const SizedBox(width: TB.s16),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TType.caption.copyWith(
                color: TB.ink,
                fontSize: 12.5,
                fontWeight: strong ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ),
          if (trailing != null) ...[const SizedBox(width: 6), trailing!],
        ],
      ),
    );
  }
}

class _NoteLine extends StatelessWidget {
  const _NoteLine({required this.controller});

  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text(
            'Note',
            style: TType.caption.copyWith(color: TB.inkFaint, fontSize: 12.5),
          ),
          const SizedBox(width: TB.s16),
          Expanded(
            child: TextField(
              controller: controller,
              textAlign: TextAlign.right,
              maxLength: 40,
              cursorColor: TB.brandDeep,
              style: TType.caption.copyWith(
                color: TB.ink,
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
              ),
              decoration: InputDecoration(
                isDense: true,
                counterText: '',
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(vertical: 4),
                hintText: 'Add a note',
                hintStyle: TType.caption.copyWith(
                  color: TB.inkFaint,
                  fontSize: 12.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _GreenButton extends StatelessWidget {
  const _GreenButton({
    required this.label,
    required this.onTap,
    this.loading = false,
    this.collapsed = false,
  });

  final String label;
  final VoidCallback? onTap;
  final bool loading;

  /// Round, with no label (the shape it has while loading).
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    return Pressable(
      scale: Motion.pressPill,
      haptic: HapticKind.none,
      semanticLabel: label,
      onTap: onTap ?? () {},
      child: AnimatedContainer(
        duration: Motion.medium,
        curve: Motion.easeExpo,
        width: loading || collapsed ? 54 : 200,
        height: 54,
        decoration: BoxDecoration(
          color: TB.brand,
          borderRadius: BorderRadius.circular(TB.rPill),
          boxShadow: const [
            BoxShadow(
              color: Color(0x478CC63F),
              blurRadius: 18,
              offset: Offset(0, 8),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: Motion.fast,
          child: loading
              ? const SizedBox(
                  key: ValueKey('spin'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.4,
                    color: Colors.white,
                  ),
                )
              : collapsed
              ? const Icon(
                  Icons.check_rounded,
                  key: ValueKey('check'),
                  color: Colors.white,
                  size: 24,
                )
              : Text(
                  label,
                  key: const ValueKey('label'),
                  maxLines: 1,
                  style: TType.bodyStrong.copyWith(color: Colors.white),
                ),
        ),
      ),
    );
  }
}

class _Receipt extends StatefulWidget {
  const _Receipt({
    required this.to,
    required this.amount,
    required this.at,
    required this.txnId,
    required this.onDone,
  });

  final Contact to;
  final double amount;
  final DateTime at;
  final String txnId;
  final VoidCallback onDone;

  @override
  State<_Receipt> createState() => _ReceiptState();
}

class _ReceiptState extends State<_Receipt> {
  bool _copied = false;

  /// Done starts as the round spinner Confirm became, then widens.
  bool _wide = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Motion.medium, () {
      if (mounted) setState(() => _wide = true);
    });
  }

  static const _months = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'May',
    'Jun',
    'Jul',
    'Aug',
    'Sep',
    'Oct',
    'Nov',
    'Dec',
  ];

  Future<void> _copy() async {
    await Clipboard.setData(ClipboardData(text: widget.txnId));
    haptic(HapticKind.selection);
    setState(() => _copied = true);
    await Future.delayed(const Duration(milliseconds: 1500));
    if (mounted) setState(() => _copied = false);
  }

  @override
  Widget build(BuildContext context) {
    final at = widget.at;
    String two(int n) => n.toString().padLeft(2, '0');
    final rows = <Widget>[
      _Line(
        'Status',
        'Completed',
        trailing: const Icon(
          Icons.check_circle_rounded,
          size: 15,
          color: TB.brandDeep,
        ),
      ),
      _Line('Sent to', widget.to.name),
      _Line('Time', '${two(at.hour)}:${two(at.minute)}'),
      _Line('Date', '${at.day} ${_months[at.month - 1]} ${at.year}'),
      _Line(
        'Transaction ID',
        _copied ? 'Copied' : widget.txnId,
        trailing: Pressable(
          scale: Motion.pressRound,
          semanticLabel: 'Copy transaction ID',
          onTap: _copy,
          child: Icon(
            _copied ? Icons.check_rounded : Icons.copy_rounded,
            size: 15,
            color: _copied ? TB.brandDeep : TB.inkSoft,
          ),
        ),
      ),
      const Padding(
        padding: EdgeInsets.symmetric(vertical: 8),
        child: Divider(height: 1, color: TB.keyRim),
      ),
      _Line('Amount', formatEtb(widget.amount)),
      _Line('Platform fee', Wallet.fee.toStringAsFixed(2)),
    ];

    return Column(
      children: [
        const SizedBox(height: TB.s12),
        const _SuccessMark(),
        const SizedBox(height: TB.s16),
        Reveal(
          index: 2,
          child: Text(
            'Transaction Successful',
            style: TType.title2.copyWith(color: TB.ink, fontSize: 19),
          ),
        ),
        const SizedBox(height: 4),
        Reveal(
          index: 3,
          child: Text(
            'From telebirr wallet: ${Wallet.ownerPhoneMasked}',
            style: TType.caption.copyWith(color: TB.inkFaint, fontSize: 12),
          ),
        ),
        const SizedBox(height: TB.s16),
        Reveal(
          index: 4,
          child: Column(
            children: [
              // The total counts up as it arrives.
              TweenAnimationBuilder<double>(
                tween: Tween(begin: 0, end: widget.amount + Wallet.fee),
                duration: const Duration(milliseconds: 900),
                curve: Motion.easeExpo,
                builder: (context, v, _) => Text(
                  formatEtb(v),
                  style: TType.numeralHero.copyWith(
                    fontSize: 40,
                    fontWeight: FontWeight.w500,
                    letterSpacing: -1,
                    color: TB.ink,
                  ),
                ),
              ),
              Text(
                'Total Amount',
                style: TType.caption.copyWith(color: TB.inkFaint, fontSize: 12),
              ),
            ],
          ),
        ),
        const SizedBox(height: TB.s20),
        Reveal(
          index: 5,
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              'Transaction details',
              style: TType.bodyStrong.copyWith(color: TB.ink, fontSize: 14),
            ),
          ),
        ),
        const SizedBox(height: 4),
        for (var i = 0; i < rows.length; i++)
          Reveal(index: 6 + i, rise: 10, child: rows[i]),
        const SizedBox(height: TB.s24),
        // Stays exactly where Confirm was; only its label changes.
        _GreenButton(label: 'Done', collapsed: !_wide, onTap: widget.onDone),
      ],
    );
  }
}

/// The green check that pops in, with a halo that keeps softly pulsing and
/// a few sparks drifting around it.
class _SuccessMark extends StatefulWidget {
  const _SuccessMark();

  @override
  State<_SuccessMark> createState() => _SuccessMarkState();
}

class _SuccessMarkState extends State<_SuccessMark>
    with SingleTickerProviderStateMixin {
  late final AnimationController _halo = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1800),
  )..repeat();

  @override
  void dispose() {
    _halo.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      height: 96,
      child: TweenAnimationBuilder<double>(
        tween: Tween(begin: 0, end: 1),
        duration: Motion.slow,
        curve: Motion.easeBack,
        builder: (context, pop, _) => AnimatedBuilder(
          animation: _halo,
          builder: (context, _) => CustomPaint(
            painter: _HaloPainter(_halo.value, pop.clamp(0.0, 1.0)),
            child: Center(
              child: Transform.scale(
                scale: pop,
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: const BoxDecoration(
                    color: TB.brand,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Color(0x668CC63F), blurRadius: 18),
                    ],
                  ),
                  child: CustomPaint(painter: _CheckPainter(pop.clamp(0, 1))),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _HaloPainter extends CustomPainter {
  _HaloPainter(this.t, this.pop);

  final double t;
  final double pop;

  @override
  void paint(Canvas canvas, Size size) {
    final c = size.center(Offset.zero);
    canvas.drawCircle(
      c,
      40 * pop,
      Paint()..color = TB.brandMist.withValues(alpha: 0.9 * pop),
    );
    canvas.drawCircle(
      c,
      40 + 14 * t,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5
        ..color = TB.brand.withValues(alpha: 0.35 * (1 - t) * pop),
    );
    for (var i = 0; i < 6; i++) {
      final a = i * math.pi / 3 + t * math.pi / 3;
      final r = 46 + 4 * math.sin(t * 2 * math.pi + i);
      canvas.drawCircle(
        c + Offset(math.cos(a) * r, math.sin(a) * r * 0.85),
        i.isEven ? 2.2 : 1.6,
        Paint()..color = TB.brand.withValues(alpha: 0.7 * pop),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HaloPainter old) =>
      old.t != t || old.pop != pop;
}

class _CheckPainter extends CustomPainter {
  _CheckPainter(this.t);

  final double t;

  @override
  void paint(Canvas canvas, Size size) {
    if (t <= 0) return;
    final w = size.width;
    final path = Path()
      ..moveTo(w * 0.3, w * 0.52)
      ..lineTo(w * 0.45, w * 0.66)
      ..lineTo(w * 0.71, w * 0.38);
    final m = path.computeMetrics().first;
    canvas.drawPath(
      m.extractPath(0, m.length * t),
      Paint()
        ..color = Colors.white
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4.5
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant _CheckPainter old) => old.t != t;
}
