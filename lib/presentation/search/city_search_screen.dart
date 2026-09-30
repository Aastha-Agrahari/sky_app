import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/city.dart';
import '../../data/models/popular_cities.dart';
import 'city_search_view_model.dart';

/// Pops with the chosen [City], or null if the user goes back.
class CitySearchScreen extends StatefulWidget {
  const CitySearchScreen({super.key});

  @override
  State<CitySearchScreen> createState() => _CitySearchScreenState();
}

class _CitySearchScreenState extends State<CitySearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _select(City city) => Navigator.of(context).pop(city);

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<CitySearchViewModel>();

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFF141E30), Color(0xFF243B55)],
        ),
      ),
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(4, 8, 16, 8),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        autofocus: true,
                        textInputAction: TextInputAction.search,
                        onChanged: (value) {
                          setState(() {}); // toggles the clear button
                          vm.onQueryChanged(value);
                        },
                        onSubmitted: (_) {
                          if (vm.results.isNotEmpty) _select(vm.results.first);
                        },
                        decoration: InputDecoration(
                          hintText: 'Search city…',
                          filled: true,
                          fillColor: Colors.white.withValues(alpha: 0.12),
                          prefixIcon: const Icon(Icons.search_rounded),
                          suffixIcon: _controller.text.isEmpty
                              ? null
                              : IconButton(
                                  icon: const Icon(Icons.close_rounded),
                                  onPressed: () {
                                    _controller.clear();
                                    setState(() {});
                                    vm.onQueryChanged('');
                                  },
                                ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(18),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(child: _buildBody(vm)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBody(CitySearchViewModel vm) {
    switch (vm.status) {
      case SearchStatus.idle:
        return _PopularCities(onSelected: _select);
      case SearchStatus.loading:
        return const Center(child: CircularProgressIndicator());
      case SearchStatus.empty:
        return _Message(
          icon: Icons.search_off_rounded,
          text: 'No city found for "${vm.query}".\nCheck the spelling and try again.',
        );
      case SearchStatus.error:
        return _Message(
          icon: Icons.wifi_off_rounded,
          text: vm.errorMessage,
          actionLabel: 'Retry',
          onAction: vm.retry,
        );
      case SearchStatus.results:
        return ListView.separated(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          itemCount: vm.results.length,
          separatorBuilder: (_, __) => Divider(
            height: 1,
            color: Colors.white.withValues(alpha: 0.1),
          ),
          itemBuilder: (context, index) {
            final city = vm.results[index];
            return ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 4),
              leading: const Icon(Icons.place_outlined),
              title: Text(city.name),
              subtitle: city.subtitle.isEmpty ? null : Text(city.subtitle),
              onTap: () => _select(city),
            );
          },
        );
    }
  }
}

class _PopularCities extends StatelessWidget {
  const _PopularCities({required this.onSelected});

  final ValueChanged<City> onSelected;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          'POPULAR CITIES',
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                letterSpacing: 1.2,
                color: Colors.white.withValues(alpha: 0.7),
              ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            for (final city in popularCities)
              ActionChip(
                label: Text(city.name),
                avatar: const Icon(Icons.place_outlined, size: 16),
                onPressed: () => onSelected(city),
                backgroundColor: Colors.white.withValues(alpha: 0.12),
                side: BorderSide(color: Colors.white.withValues(alpha: 0.2)),
              ),
          ],
        ),
      ],
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.text,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String text;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 64, color: Colors.white70),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            if (actionLabel != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
