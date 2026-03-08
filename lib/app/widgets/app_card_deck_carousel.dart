import 'package:flutter/material.dart';

import '../localization/app_localizations.dart';
import 'app_panel.dart';

class AppCardDeckCarousel extends StatefulWidget {
  const AppCardDeckCarousel({
    super.key,
    required this.title,
    required this.icon,
    required this.accentColor,
    required this.itemLabels,
    required this.itemBuilder,
    this.subtitle,
    this.initialIndex = 0,
    this.initiallyCollapsed = false,
    this.expandedHeight = 340,
    this.collapsedHeight = 188,
  }) : assert(itemLabels.length > 0);

  final String title;
  final String? subtitle;
  final IconData icon;
  final Color accentColor;
  final List<String> itemLabels;
  final IndexedWidgetBuilder itemBuilder;
  final int initialIndex;
  final bool initiallyCollapsed;
  final double expandedHeight;
  final double collapsedHeight;

  @override
  State<AppCardDeckCarousel> createState() => _AppCardDeckCarouselState();
}

class _AppCardDeckCarouselState extends State<AppCardDeckCarousel> {
  late final PageController _pageController;
  late int _currentIndex;
  late bool _collapsed;

  double get _page {
    if (!_pageController.hasClients) {
      return _currentIndex.toDouble();
    }
    final page = _pageController.page;
    return page ?? _currentIndex.toDouble();
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.itemLabels.length - 1);
    _collapsed = widget.initiallyCollapsed;
    _pageController = PageController(
      initialPage: _currentIndex,
      viewportFraction: 0.82,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSingle = widget.itemLabels.length == 1;
    final currentLabel = widget.itemLabels[_currentIndex];

    return AppPanel(
      tint: widget.accentColor,
      borderOpacity: 0.18,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: widget.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: widget.accentColor.withValues(alpha: 0.2),
                  ),
                ),
                child: Icon(widget.icon, color: widget.accentColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.title,
                      style: theme.textTheme.headlineSmall,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (widget.subtitle != null) ...[
                      const SizedBox(height: 4),
                      Text(
                        widget.subtitle!,
                        style: theme.textTheme.bodyMedium,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 7,
                    ),
                    decoration: BoxDecoration(
                      color: widget.accentColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${_currentIndex + 1} / ${widget.itemLabels.length}',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: widget.accentColor,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  if (!isSingle)
                    TextButton.icon(
                      onPressed: _toggleCollapsed,
                      icon: Icon(
                        _collapsed
                            ? Icons.unfold_more_rounded
                            : Icons.unfold_less_rounded,
                        size: 18,
                      ),
                      label: Text(
                        _collapsed
                            ? context.l10n.expandDetails
                            : context.l10n.collapseDetails,
                      ),
                    ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            height: _collapsed ? widget.collapsedHeight : widget.expandedHeight,
            child: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  children: [
                    _DeckBackdrop(
                      accentColor: widget.accentColor,
                      collapsed: _collapsed,
                    ),
                    AnimatedBuilder(
                      animation: _pageController,
                      builder: (context, _) {
                        final currentPage = _page;
                        return PageView.builder(
                          controller: _pageController,
                          padEnds: false,
                          itemCount: widget.itemLabels.length,
                          onPageChanged: (index) {
                            if (_currentIndex == index) {
                              return;
                            }
                            setState(() {
                              _currentIndex = index;
                            });
                          },
                          itemBuilder: (context, index) {
                            final delta = (index - currentPage).clamp(
                              -1.0,
                              1.0,
                            );
                            final absDelta = delta.abs();
                            final scale = _collapsed
                                ? 0.86 - absDelta * 0.08
                                : 1 - absDelta * 0.12;
                            final translateY = _collapsed
                                ? 10 + absDelta * 18
                                : 8 + absDelta * 26;
                            final translateX = delta * (_collapsed ? 26 : 36);
                            final rotateY = delta * (_collapsed ? 0.18 : 0.14);

                            return Align(
                              alignment: Alignment.topCenter,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 12),
                                child: Transform.translate(
                                  offset: Offset(translateX, translateY),
                                  child: Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.001)
                                      ..rotateY(rotateY),
                                    child: Transform.scale(
                                      scale: scale,
                                      child: Opacity(
                                        opacity: 1 - absDelta * 0.18,
                                        child: SizedBox(
                                          height: constraints.maxHeight - 6,
                                          child: widget.itemBuilder(
                                            context,
                                            index,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 180),
                  child: Text(
                    currentLabel,
                    key: ValueKey(currentLabel),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: widget.accentColor,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
              if (!isSingle) ...[
                IconButton(
                  onPressed: _currentIndex > 0
                      ? () => _jumpTo(_currentIndex - 1)
                      : null,
                  icon: const Icon(Icons.chevron_left_rounded),
                ),
                IconButton(
                  onPressed: _currentIndex < widget.itemLabels.length - 1
                      ? () => _jumpTo(_currentIndex + 1)
                      : null,
                  icon: const Icon(Icons.chevron_right_rounded),
                ),
              ],
            ],
          ),
          if (!_collapsed && !isSingle) ...[
            const SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: widget.itemLabels
                    .asMap()
                    .entries
                    .map((entry) {
                      final index = entry.key;
                      final label = entry.value;
                      final selected = index == _currentIndex;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: ChoiceChip(
                          label: SizedBox(
                            width: 72,
                            child: Text(
                              label,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                            ),
                          ),
                          selected: selected,
                          onSelected: (_) => _jumpTo(index),
                        ),
                      );
                    })
                    .toList(growable: false),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _toggleCollapsed() {
    setState(() {
      _collapsed = !_collapsed;
    });
  }

  void _jumpTo(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeOutCubic,
    );
  }
}

class _DeckBackdrop extends StatelessWidget {
  const _DeckBackdrop({required this.accentColor, required this.collapsed});

  final Color accentColor;
  final bool collapsed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return IgnorePointer(
      child: Stack(
        children: List.generate(3, (index) {
          final inset = collapsed ? 26 + index * 20.0 : 34 + index * 16.0;
          final top = collapsed ? 26 + index * 8.0 : 18 + index * 10.0;
          return Positioned(
            left: inset,
            right: inset,
            top: top,
            bottom: 12,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    theme.colorScheme.surface.withValues(
                      alpha: 0.82 - index * 0.08,
                    ),
                    accentColor.withValues(alpha: 0.08 + index * 0.02),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(28),
                border: Border.all(
                  color: accentColor.withValues(alpha: 0.12 + index * 0.04),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
