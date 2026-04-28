import 'package:flutter/material.dart';

import '../../../core/models/place.dart';
import '../../widgets/common_widgets.dart';

class PlaceCard extends StatefulWidget {
  const PlaceCard({
    super.key,
    required this.place,
    required this.isFavorite,
    required this.onTap,
    required this.onFavoriteToggle,
    this.compact = false,
  });

  final TravelPlace place;
  final bool isFavorite;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final bool compact;

  @override
  State<PlaceCard> createState() => _PlaceCardState();
}

class _PlaceCardState extends State<PlaceCard> {
  bool _hovering = false;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final isWide = MediaQuery.sizeOf(context).width >= 700;

    return MouseRegion(
      onEnter: (_) => setState(() => _hovering = true),
      onExit: (_) => setState(() => _hovering = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        margin: const EdgeInsets.only(bottom: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(26),
          border: Border.all(
            color: widget.isFavorite || _hovering
                ? scheme.primary.withOpacity(0.45)
                : scheme.outlineVariant.withOpacity(0.45),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(_hovering ? 0.12 : 0.05),
              blurRadius: _hovering ? 18 : 10,
              offset: Offset(0, _hovering ? 12 : 6),
            ),
          ],
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(26),
          onTap: widget.onTap,
          child: isWide
              ? IntrinsicHeight(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        width: 240,
                        child: _imageSection(context, expanded: true),
                      ),
                      Expanded(child: _detailsSection(context)),
                    ],
                  ),
                )
              : Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _imageSection(context, expanded: false),
                    _detailsSection(context),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _imageSection(BuildContext context, {required bool expanded}) {
    final brightness = Theme.of(context).brightness;
    final chipBg = brightness == Brightness.dark
        ? Colors.white.withOpacity(0.16)
        : Theme.of(context).colorScheme.primaryContainer.withOpacity(0.88);
    final chipFg = brightness == Brightness.dark
        ? Colors.white
        : Theme.of(context).colorScheme.onPrimaryContainer;

    return SizedBox(
      height: expanded ? double.infinity : 188,
      child: Stack(
        fit: StackFit.expand,
        children: [
          Hero(
            tag: 'place-image-${widget.place.id}',
            child: TravelImageFrame(
              imageUrl: widget.place.imageUrl,
              fallbackIcon: Icons.flight_takeoff_rounded,
              borderRadius: expanded
                  ? const BorderRadius.horizontal(left: Radius.circular(26))
                  : const BorderRadius.vertical(top: Radius.circular(26)),
              fit: BoxFit.cover,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withOpacity(0.5),
                  Colors.transparent,
                ],
              ),
            ),
          ),
          Positioned(
            left: 14,
            right: 14,
            bottom: 14,
            child: Row(
              children: [
                Chip(
                  visualDensity: VisualDensity.compact,
                  label: Text(
                    widget.place.region,
                    style: TextStyle(color: chipFg),
                  ),
                  backgroundColor: chipBg,
                  side: BorderSide(color: chipFg.withOpacity(0.08)),
                ),
                const Spacer(),
                AnimatedScale(
                  scale: widget.isFavorite ? 1.04 : 1,
                  duration: const Duration(milliseconds: 220),
                  child: IconButton.filledTonal(
                    onPressed: widget.onFavoriteToggle,
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white.withOpacity(0.16),
                      foregroundColor: widget.isFavorite
                          ? Theme.of(context).colorScheme.errorContainer
                          : Colors.white,
                    ),
                    icon: Icon(
                      widget.isFavorite
                          ? Icons.favorite_rounded
                          : Icons.favorite_border_rounded,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _detailsSection(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  widget.place.title,
                  style: textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.star_rounded, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    widget.place.rating.toStringAsFixed(1),
                    style: textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '${widget.place.country} - ${widget.place.category}',
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Text(
            widget.place.description,
            maxLines: widget.compact ? 2 : 3,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodyMedium?.copyWith(height: 1.35),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(Icons.photo_library_outlined,
                  size: 16, color: textTheme.bodySmall?.color),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.place.sourcePhotoId > 0
                      ? 'API photo #${widget.place.sourcePhotoId}'
                      : 'Location image sourced from the web',
                  style: textTheme.bodySmall,
                ),
              ),
              Icon(Icons.arrow_forward_rounded,
                  size: 18, color: textTheme.bodyMedium?.color),
            ],
          ),
        ],
      ),
    );
  }
}
