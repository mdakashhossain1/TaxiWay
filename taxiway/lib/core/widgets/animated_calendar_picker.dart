import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';

/// Shows the custom, animated Taxiway calendar and time picker in a centered modal dialog.
Future<DateTime?> showAnimatedCalendarPicker({
  required BuildContext context,
  required DateTime initialDate,
  DateTime? firstDate,
  DateTime? lastDate,
}) async {
  return showGeneralDialog<DateTime>(
    context: context,
    barrierDismissible: true,
    barrierLabel: 'Dismiss',
    barrierColor: Colors.black.withValues(alpha: 0.55),
    transitionDuration: const Duration(milliseconds: 280),
    pageBuilder: (context, anim1, anim2) => _CenteredAnimatedCalendarDialog(
      initialDate: initialDate,
      firstDate: firstDate ?? DateTime.now(),
      lastDate: lastDate ?? DateTime.now().add(const Duration(days: 90)),
    ),
    transitionBuilder: (context, anim1, anim2, child) {
      final curve = CurvedAnimation(parent: anim1, curve: Curves.easeOutBack);
      return ScaleTransition(
        scale: Tween<double>(begin: 0.85, end: 1.0).animate(curve),
        child: FadeTransition(
          opacity: anim1,
          child: child,
        ),
      );
    },
  );
}

class _CenteredAnimatedCalendarDialog extends StatefulWidget {
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  const _CenteredAnimatedCalendarDialog({
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  @override
  State<_CenteredAnimatedCalendarDialog> createState() => _CenteredAnimatedCalendarDialogState();
}

class _CenteredAnimatedCalendarDialogState extends State<_CenteredAnimatedCalendarDialog> {
  late DateTime _selectedDate;
  late DateTime _displayedMonth;
  String _selectedTimeSlot = '10:00 AM';

  final List<String> _timeSlots = [
    '07:00 AM',
    '09:00 AM',
    '10:30 AM',
    '01:00 PM',
    '03:30 PM',
    '06:00 PM',
    '08:30 PM',
  ];

  @override
  void initState() {
    super.initState();
    _selectedDate = DateTime(widget.initialDate.year, widget.initialDate.month, widget.initialDate.day);
    _displayedMonth = DateTime(widget.initialDate.year, widget.initialDate.month, 1);
  }

  void _prevMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _displayedMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 1);
    });
  }

  void _quickSelect(DateTime date) {
    setState(() {
      _selectedDate = DateTime(date.year, date.month, date.day);
      _displayedMonth = DateTime(date.year, date.month, 1);
    });
  }

  String _formatMonthYear(DateTime date) {
    const months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 380,
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0)),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 28,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Centered Top Header & Close Icon
                Row(
                  children: [
                    const SizedBox(width: 36),
                    Expanded(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            'Select Date & Time',
                            textAlign: TextAlign.center,
                            style: AppTypography.h2.copyWith(
                              fontSize: 19,
                              fontWeight: FontWeight.w800,
                              color: AppColors.navy,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            'Choose your travel schedule',
                            textAlign: TextAlign.center,
                            style: AppTypography.caption.copyWith(
                              fontSize: 13,
                              color: AppColors.secondaryText,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close_rounded, color: AppColors.mutedText, size: 22),
                      onPressed: () => Navigator.of(context).pop(),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Centered Quick Select Chips (Today, Tomorrow, Weekend)
                Row(
                  children: [
                    _QuickDateChip(
                      label: 'Today',
                      selected: _isSameDay(_selectedDate, today),
                      onTap: () => _quickSelect(today),
                    ),
                    const SizedBox(width: 8),
                    _QuickDateChip(
                      label: 'Tomorrow',
                      selected: _isSameDay(_selectedDate, tomorrow),
                      onTap: () => _quickSelect(tomorrow),
                    ),
                    const SizedBox(width: 8),
                    _QuickDateChip(
                      label: 'This Weekend',
                      selected: _isSameDay(_selectedDate, _getNextWeekend(today)),
                      onTap: () => _quickSelect(_getNextWeekend(today)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Centered Month Navigation Bar
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(AppRadius.medium),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.chevron_left_rounded, color: AppColors.navy, size: 24),
                        onPressed: _prevMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                      Text(
                        _formatMonthYear(_displayedMonth),
                        style: AppTypography.h3.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.navy,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.chevron_right_rounded, color: AppColors.navy, size: 24),
                        onPressed: _nextMonth,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),

                // Weekday Labels Centered (Mon, Tue, Wed, Thu, Fri, Sat, Sun)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun']
                      .map((d) => Expanded(
                            child: Text(
                              d,
                              textAlign: TextAlign.center,
                              style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF94A3B8),
                              ),
                            ),
                          ))
                      .toList(),
                ),
                const SizedBox(height: 8),

                // Centered Month Calendar Matrix
                _buildCalendarGrid(today),

                const SizedBox(height: 16),

                // Time Slot Selector
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Pickup Time Slot',
                    style: AppTypography.label.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.navy,
                      fontSize: 13.5,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: _timeSlots.map((slot) {
                      final isSelected = _selectedTimeSlot == slot;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: InkWell(
                          onTap: () => setState(() => _selectedTimeSlot = slot),
                          borderRadius: BorderRadius.circular(AppRadius.pill),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 180),
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                            decoration: BoxDecoration(
                              color: isSelected ? AppColors.primaryBackground : const Color(0xFFF8FAFC),
                              borderRadius: BorderRadius.circular(AppRadius.pill),
                              border: Border.all(
                                color: isSelected ? AppColors.primary : const Color(0xFFE2E8F0),
                                width: isSelected ? 1.5 : 1,
                              ),
                            ),
                            child: Text(
                              slot,
                              style: TextStyle(
                                fontSize: 12.5,
                                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
                                color: isSelected ? AppColors.primaryDark : AppColors.navy,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),

                const SizedBox(height: 20),

                // Confirm Date CTA Button
                PrimaryButton(
                  label: 'Confirm Date & Schedule',
                  onPressed: () => Navigator.of(context).pop(_selectedDate),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendarGrid(DateTime today) {
    final firstDayOfMonth = DateTime(_displayedMonth.year, _displayedMonth.month, 1);
    final daysInMonth = DateTime(_displayedMonth.year, _displayedMonth.month + 1, 0).day;
    final weekdayOffset = (firstDayOfMonth.weekday - 1) % 7;

    final totalCells = ((weekdayOffset + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemCount: totalCells,
      itemBuilder: (context, index) {
        final dayNumber = index - weekdayOffset + 1;
        if (dayNumber < 1 || dayNumber > daysInMonth) {
          return const SizedBox.shrink();
        }

        final date = DateTime(_displayedMonth.year, _displayedMonth.month, dayNumber);
        final isPast = date.isBefore(today);
        final isSelected = _isSameDay(_selectedDate, date);
        final isToday = _isSameDay(today, date);

        return GestureDetector(
          onTap: isPast ? null : () => setState(() => _selectedDate = date),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primary
                  : isToday
                      ? AppColors.primaryBackground
                      : Colors.transparent,
              shape: BoxShape.circle,
              boxShadow: isSelected
                  ? [
                      BoxShadow(
                        color: AppColors.primary.withValues(alpha: 0.35),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: Center(
              child: Text(
                '$dayNumber',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isSelected || isToday ? FontWeight.w800 : FontWeight.w600,
                  color: isSelected
                      ? Colors.white
                      : isPast
                          ? const Color(0xFFCBD5E1)
                          : isToday
                              ? AppColors.primaryDark
                              : const Color(0xFF0F172A),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  DateTime _getNextWeekend(DateTime from) {
    int daysUntilSat = (DateTime.saturday - from.weekday + 7) % 7;
    if (daysUntilSat == 0) daysUntilSat = 7;
    return from.add(Duration(days: daysUntilSat));
  }
}

class _QuickDateChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _QuickDateChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 8),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: selected ? AppColors.primaryBackground : const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(AppRadius.medium),
            border: Border.all(
              color: selected ? AppColors.primary : const Color(0xFFE2E8F0),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12.5,
              fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              color: selected ? AppColors.primaryDark : AppColors.navy,
            ),
          ),
        ),
      ),
    );
  }
}
