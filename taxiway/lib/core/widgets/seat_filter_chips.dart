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
      height: 32,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _options.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, i) {
          final value = _options[i];
          final isSelected = selected == value;
          final label = value == null ? l10n.seatsFilterAny : l10n.seatsFilterPlus(value);

          return InkWell(
            onTap: () => ref.read(selectedMinSeatsProvider.notifier).set(value),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.of(context).primaryBackground : AppColors.of(context).card,
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(
                  color: isSelected ? AppColors.of(context).primary : AppColors.of(context).border,
                  width: isSelected ? 1.5 : 1,
                ),
              ),
              child: Text(
                label,
                style: AppTypography.of(context).caption.copyWith(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
