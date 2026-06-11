import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class CityPickerSheet extends ConsumerStatefulWidget {
  const CityPickerSheet({
    required this.onCitySelected,
    this.currentCity,
    super.key,
  });

  final ValueChanged<String> onCitySelected;
  final String? currentCity;

  static Future<String?> show(
    BuildContext context, {
    String? currentCity,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
      ),
      builder: (_) => CityPickerSheet(
        onCitySelected: (city) => Navigator.of(context).pop(city),
        currentCity: currentCity,
      ),
    );
  }

  @override
  ConsumerState<CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends ConsumerState<CityPickerSheet> {
  final _searchController = TextEditingController();
  String _filter = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filter.isEmpty
        ? kCities
        : kCities
            .where((c) =>
                c.toLowerCase().contains(_filter.toLowerCase()))
            .toList();

    return DraggableScrollableSheet(
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return Material(
          color: Colors.transparent,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              children: [
                Container(
                  width: 32,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: AppSpacing.md),
                  decoration: BoxDecoration(
                    color: AppColors.textFaint,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const Text(
                  'Select your city',
                  style: AppTypography.h2,
                ),
                const SizedBox(height: AppSpacing.md),
                TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search cities...',
                    prefixIcon: Icon(Icons.search),
                  ),
                  onChanged: (v) => setState(() => _filter = v),
                ),
                const SizedBox(height: AppSpacing.sm),
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Text(
                            'No cities found matching "$_filter"',
                            style: AppTypography.bodySecondary,
                          ),
                        )
                      : ListView.builder(
                          controller: scrollController,
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final city = filtered[index];
                            final isCurrent = city == widget.currentCity;
                            return ListTile(
                              leading: isCurrent
                                  ? const Icon(Icons.check_circle,
                                      color: AppColors.success)
                                  : const Icon(Icons.location_city,
                                      color: AppColors.textFaint),
                              title: Text(city),
                              trailing: isCurrent
                                  ? Text(
                                      'Current',
                                      style: AppTypography.caption.copyWith(
                                        color: AppColors.success,
                                      ),
                                    )
                                  : null,
                              onTap: () => widget.onCitySelected(city),
                            );
                          },
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

const kCities = [
  'Casablanca',
  'Rabat',
  'Marrakesh',
  'Fes',
  'Tangier',
  'Agadir',
  'Meknes',
  'Oujda',
  'Kenitra',
  'Tetouan',
  'Safi',
  'El Jadida',
  'Beni Mellal',
  'Nador',
  'Taza',
  'Mohammedia',
  'Khouribga',
  'Settat',
  'Larache',
  'Ksar El Kebir',
  'New York',
  'Los Angeles',
  'Chicago',
  'Houston',
  'London',
  'Paris',
  'Berlin',
  'Madrid',
  'Rome',
  'Amsterdam',
  'Brussels',
  'Vienna',
  'Zurich',
  'Stockholm',
  'Oslo',
  'Copenhagen',
  'Helsinki',
  'Dublin',
  'Lisbon',
  'Athens',
  'Istanbul',
  'Dubai',
  'Doha',
  'Riyadh',
  'Cairo',
  'Tunis',
  'Algiers',
  'Nairobi',
  'Cape Town',
  'Lagos',
  'Tokyo',
  'Seoul',
  'Shanghai',
  'Hong Kong',
  'Singapore',
  'Mumbai',
  'Bangkok',
  'Sydney',
  'Melbourne',
  'Auckland',
  'Toronto',
  'Vancouver',
  'Mexico City',
  'Sao Paulo',
  'Buenos Aires',
  'Bogota',
  'Lima',
  'Santiago',
];
