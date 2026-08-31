import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import '../../l10n/generated/app_localizations.dart';
import '../providers.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'animated_calendar_picker.dart';
import 'app_toast.dart';

/// "Book Now" / "Schedule for Later" toggle shown on the home screen, above
/// vehicle selection. Scheduling opens the existing animated date picker for
/// the date, then Flutter's native [showTimePicker] for the time — NOT the
/// date picker's own internal time-slot chips, whose selection its confirm
/// button silently discards (a latent bug in that shared widget). Combining
/// date+time this way is the same workaround `bulk_trip_capacity_screen.dart`
/// already uses.
class ScheduleToggleCard extends ConsumerWidget {
  const ScheduleToggleCard({super.key});

  static const _minLeadTime = Duration(minutes: 30);
  static const _maxLeadTime = Duration(days: 7);

  Future<void> _pickSchedule(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final now = DateTime.now();

    final date = await showAnimatedCalendarPicker(
      context: context,
      initialDate: now.add(_minLeadTime),
      firstDate: now,
      lastDate: now.add(_maxLeadTime),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now.add(_minLeadTime)),
    );
    if (time == null || !context.mounted) return;

    final combined = DateTime(date.year, date.month, date.day, time.hour, time.minute);

    if (combined.isBefore(now.add(_minLeadTime))) {
      AppToast.error(context, l10n.scheduleTooSoonError);
      return;
    }
    if (combined.isAfter(now.add(_maxLeadTime))) {
      AppToast.error(context, l10n.scheduleTooFarError);
      return;
    }

    ref.read(bookingDraftControllerProvider.notifier).setScheduledAt(combined);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final draft = ref.watch(bookingDraftControllerProvider);
    final isScheduled = draft.isScheduled;

    return Row(
      children: [
        Expanded(
          child: _ToggleChip(
            label: l10n.bookNow,
            icon: BootstrapIcons.clock,
            selected: !isScheduled,
            onTap: () => ref.read(bookingDraftControllerProvider.notifier).setScheduledAt(null),
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ToggleChip(
            label: isScheduled ? DateFormat('d MMM, h:mm a').format(draft.scheduledAt!) : l10n.scheduleForLater,
            icon: BootstrapIcons.calendar_event,
            selected: isScheduled,
            onTap: () => _pickSchedule(context, ref),
          ),
        ),
      ],
    );
  }
}

class _ToggleChip extends StatelessWidget {
  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ToggleChip({required this.label, required this.icon, required this.selected, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: selected ? AppColors.of(context).primaryBackground : AppColors.of(context).card,
          borderRadius: BorderRadius.circular(AppRadius.medium),
          border: Border.all(
            color: selected ? AppColors.of(context).primary : AppColors.of(context).border,
            width: selected ? 1.5 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 15, color: selected ? AppColors.of(context).primaryDark : AppColors.of(context).mutedText),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.of(context).caption.copyWith(
                  fontSize: 12.5,
                  fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                  color: selected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
