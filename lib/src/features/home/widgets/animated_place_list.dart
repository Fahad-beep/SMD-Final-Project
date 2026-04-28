import 'package:flutter/material.dart';

import '../../../core/models/place.dart';
import 'place_card.dart';

class AnimatedPlaceList extends StatefulWidget {
  const AnimatedPlaceList({
    super.key,
    required this.places,
    required this.favoriteIds,
    required this.onPlaceTap,
    required this.onFavoriteToggle,
    this.compact = false,
  });

  final List<TravelPlace> places;
  final Set<String> favoriteIds;
  final ValueChanged<TravelPlace> onPlaceTap;
  final ValueChanged<TravelPlace> onFavoriteToggle;
  final bool compact;

  @override
  State<AnimatedPlaceList> createState() => _AnimatedPlaceListState();
}

class _AnimatedPlaceListState extends State<AnimatedPlaceList> {
  final GlobalKey<SliverAnimatedListState> _listKey =
      GlobalKey<SliverAnimatedListState>();
  final List<TravelPlace> _items = [];
  String _signature = '';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance
        .addPostFrameCallback((_) => _syncItems(widget.places));
  }

  @override
  void didUpdateWidget(covariant AnimatedPlaceList oldWidget) {
    super.didUpdateWidget(oldWidget);
    final nextSignature = _buildSignature(widget.places);
    if (_signature != nextSignature) {
      _syncItems(widget.places);
    }
  }

  String _buildSignature(List<TravelPlace> places) {
    return places.map((place) => place.id).join('|');
  }

  void _syncItems(List<TravelPlace> next) {
    final listState = _listKey.currentState;
    if (listState == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          _syncItems(next);
        }
      });
      return;
    }

    _signature = _buildSignature(next);

    for (var index = _items.length - 1; index >= 0; index--) {
      final removedItem = _items.removeAt(index);
      listState.removeItem(
        index,
        (context, animation) => _AnimatedRemovalCard(
          place: removedItem,
          animation: animation,
        ),
        duration: const Duration(milliseconds: 220),
      );
    }

    for (var index = 0; index < next.length; index++) {
      _items.insert(index, next[index]);
      listState.insertItem(index, duration: const Duration(milliseconds: 260));
    }

    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.places.isEmpty) {
      return const SliverToBoxAdapter(child: SizedBox.shrink());
    }

    return SliverPadding(
      padding: const EdgeInsets.only(bottom: 24),
      sliver: SliverAnimatedList(
        key: _listKey,
        initialItemCount: _items.length,
        itemBuilder: (context, index, animation) {
          final place = _items[index];
          return SizeTransition(
            sizeFactor: animation,
            child: FadeTransition(
              opacity: animation,
              child: PlaceCard(
                place: place,
                isFavorite: widget.favoriteIds.contains(place.id),
                onTap: () => widget.onPlaceTap(place),
                onFavoriteToggle: () => widget.onFavoriteToggle(place),
                compact: widget.compact,
              ),
            ),
          );
        },
      ),
    );
  }
}

class _AnimatedRemovalCard extends StatelessWidget {
  const _AnimatedRemovalCard({
    required this.place,
    required this.animation,
  });

  final TravelPlace place;
  final Animation<double> animation;

  @override
  Widget build(BuildContext context) {
    return SizeTransition(
      sizeFactor: animation,
      child: FadeTransition(
        opacity: animation,
        child: Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 180,
          decoration: BoxDecoration(
            color: Theme.of(context).cardColor,
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant
                  .withOpacity(0.45),
            ),
          ),
          alignment: Alignment.centerLeft,
          padding: const EdgeInsets.all(20),
          child: Text(
            place.title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }
}
