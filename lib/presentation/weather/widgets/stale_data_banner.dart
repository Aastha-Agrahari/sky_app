import 'package:flutter/material.dart';

import '../../../core/utils/formatters.dart';

/// Shown when the visible data is older than the latest attempted refresh.
class StaleDataBanner extends StatelessWidget {
  const StaleDataBanner({
    super.key,
    required this.lastUpdated,
    required this.onRetry,
  });

  final DateTime lastUpdated;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 6, 6, 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFB74D).withValues(alpha: 0.22),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFFFFB74D).withValues(alpha: 0.5),
        ),
      ),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_rounded, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Showing saved data from ${Formatters.clock(lastUpdated)}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          TextButton(
            onPressed: onRetry,
            style: TextButton.styleFrom(foregroundColor: Colors.white),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }
}
