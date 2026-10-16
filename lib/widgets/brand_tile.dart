import 'package:flutter/material.dart';

import '../data/services.dart';
import '../theme/tokens.dart';
import '../theme/type.dart';
import 'pressable.dart';

/// A service tile: the partner's own mark (or a telebirr line icon) in a soft
/// white well, the label underneath. Logos keep their native colours.
class BrandTile extends StatelessWidget {
  const BrandTile({
    super.key,
    required this.service,
    this.onTap,
    this.compact = false,
  });

  final Service service;
  final VoidCallback? onTap;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final well = compact ? 52.0 : 60.0;
    return Pressable(
      onTap: onTap ?? () {},
      semanticLabel: service.label,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Stack(
            clipBehavior: Clip.none,
            children: [
              Container(
                width: well,
                height: well,
                decoration: BoxDecoration(
                  color: TB.surfaceRaised,
                  borderRadius: BorderRadius.circular(well * 0.32),
                  boxShadow: TB.shadowSoft,
                ),
                alignment: Alignment.center,
                child: ServiceMark(service: service, size: well * 0.62),
              ),
              if (service.badge != null)
                Positioned(
                  top: -8,
                  right: -14,
                  child: RibbonBadge(text: service.badge!),
                ),
            ],
          ),
          const SizedBox(height: TB.s8),
          Text(
            service.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: TType.micro.copyWith(
              fontSize: 12,
              height: 15 / 12,
              color: TB.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class ServiceMark extends StatelessWidget {
  const ServiceMark({super.key, required this.service, required this.size});

  final Service service;
  final double size;

  @override
  Widget build(BuildContext context) {
    if (service.logo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(size * 0.18),
        child: Image.asset(
          service.logo!,
          width: size,
          height: size,
          fit: BoxFit.contain,
          filterQuality: FilterQuality.medium,
        ),
      );
    }
    return Icon(service.icon, size: size * 0.78, color: TB.brandDeep);
  }
}

class RibbonBadge extends StatelessWidget {
  const RibbonBadge({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: TB.ribbon,
        borderRadius: BorderRadius.circular(TB.rPill),
        boxShadow: const [
          BoxShadow(
            color: Color(0x40F7B731),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        text,
        style: TType.micro.copyWith(
          color: TB.ribbonInk,
          fontWeight: FontWeight.w700,
          fontSize: 10.5,
        ),
      ),
    );
  }
}
