import 'package:flutter/material.dart';

/// Top bar: tappable city title plus search / GPS / refresh actions.
class WeatherHeader extends StatelessWidget {
  const WeatherHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.isBusy,
    required this.isRefreshing,
    required this.onSearch,
    required this.onLocate,
    required this.onRefresh,
  });

  final String title;
  final String? subtitle;
  final bool isBusy;
  final bool isRefreshing;
  final VoidCallback onSearch;
  final VoidCallback onLocate;
  final VoidCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 4, 0),
      child: Row(
        children: [
          Expanded(
            child: InkWell(
              onTap: onSearch,
              borderRadius: BorderRadius.circular(12),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.place_rounded, size: 18),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            title,
                            overflow: TextOverflow.ellipsis,
                            style: textTheme.titleLarge
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty)
                      Padding(
                        padding: const EdgeInsets.only(left: 22),
                        child: Text(
                          subtitle!,
                          overflow: TextOverflow.ellipsis,
                          style: textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.75),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
          IconButton(
            tooltip: 'Search city',
            color: Colors.white,
            onPressed: onSearch,
            icon: const Icon(Icons.search_rounded),
          ),
          IconButton(
            tooltip: 'Use my location',
            color: Colors.white,
            disabledColor: Colors.white38,
            onPressed: isBusy ? null : onLocate,
            icon: const Icon(Icons.my_location_rounded),
          ),
          IconButton(
            tooltip: 'Refresh',
            color: Colors.white,
            disabledColor: Colors.white38,
            onPressed: isBusy ? null : onRefresh,
            icon: isRefreshing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
    );
  }
}
