import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../l10n/generated/app_localizations.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';

/// null = "Any". The vehicle carousel filters by `category.seats >= value`
/// client-side — no API changes needed, `seats` is already on every category.
class SelectedMinSeats extends Notifier<int?> {
  @override
  int? build() => null;

  void set(int? value) => state = value;
}

final selectedMinSeatsProvider = NotifierProvider<SelectedMinSeats, int?>(SelectedMinSeats.new);

class SeatFilterChips extends ConsumerWidget {
  const SeatFilterChips({super.key});

  static const List<int?> _options = [null, 2, 4, 6, 7];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final selected = ref.watch(selectedMinSeatsProvider);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final value = _options[i];
          final isSelected = selected == value;
          final label = value == null ? l10n.seatsFilterAny : l10n.seatsFilterPlus(value);

          final colors = AppColors.of(context);

          return GestureDetector(
            onTap: () => ref.read(selectedMinSeatsProvider.notifier).set(value),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? colors.primary : colors.surface,
                borderRadius: BorderRadius.circular(AppRadius.pill),
              ),
              child: Text(
                label,
                style: AppTypography.of(context).label.copyWith(
                  fontSize: 14,
                  color: isSelected ? colors.onPrimary : colors.navy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
