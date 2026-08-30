import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/bulk_booking.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../../core/widgets/phone_input.dart';

class BulkAdditionalRequirementsScreen extends ConsumerStatefulWidget {
  const BulkAdditionalRequirementsScreen({super.key});

  @override
  ConsumerState<BulkAdditionalRequirementsScreen> createState() => _BulkAdditionalRequirementsScreenState();
}

class _BulkAdditionalRequirementsScreenState extends ConsumerState<BulkAdditionalRequirementsScreen> {
  final _notesController = TextEditingController();
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isNotesExpanded = false;

  @override
  void initState() {
    super.initState();
    final draft = ref.read(bulkBookingDraftControllerProvider);
    if (draft.notes.trim().isNotEmpty) {
      _notesController.text = draft.notes;
      _isNotesExpanded = true;
    }
    if (draft.contactName.isNotEmpty) {
      _nameController.text = draft.contactName;
    }
    if (draft.contactPhone.isNotEmpty) {
      _phoneController.text = draft.contactPhone;
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final draft = ref.watch(bulkBookingDraftControllerProvider);
    final notifier = ref.read(bulkBookingDraftControllerProvider.notifier);

    return AppScaffold(
      appBar: AppBar(title: const Text('Additional Requirements')),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selectable Feature Requirements Tags
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: kBulkRequirementOptions.map((r) {
              final selected = draft.requirements.contains(r);
              return GestureDetector(
                onTap: () => notifier.toggleRequirement(r),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: selected ? AppColors.of(context).primaryBackground : Colors.white,
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                    border: Border.all(color: selected ? AppColors.of(context).primary : AppColors.of(context).border),
                  ),
                  child: Text(
                    r,
                    style: AppTypography.of(context).label.copyWith(
                      color: selected ? AppColors.of(context).primaryDark : AppColors.of(context).navy,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 18),

          // Collapsible Optional Notes Section
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 240),
            crossFadeState: _isNotesExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
            firstChild: InkWell(
              onTap: () => setState(() => _isNotesExpanded = true),
              borderRadius: BorderRadius.circular(AppRadius.medium),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(AppRadius.medium),
                  border: Border.all(color: AppColors.of(context).border),
                ),
                child: Row(
                  children: [
                    Icon(BootstrapIcons.chat_left_text, size: 16, color: AppColors.of(context).primary),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Add Special Notes / Instructions (Optional)',
                        style: AppTypography.of(context).caption.copyWith(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w600,
                          color: AppColors.of(context).navy,
                        ),
                      ),
                    ),
                    Icon(BootstrapIcons.plus_circle, size: 18, color: AppColors.of(context).primary),
                  ],
                ),
              ),
            ),
            secondChild: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(AppRadius.medium),
                border: Border.all(color: AppColors.of(context).border),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(BootstrapIcons.chat_left_text, size: 16, color: AppColors.of(context).primary),
                          const SizedBox(width: 8),
                          Text(
                            'Special Notes (Optional)',
                            style: AppTypography.of(context).label.copyWith(fontSize: 14),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            _notesController.clear();
                            notifier.setNotes('');
                            _isNotesExpanded = false;
                          });
                        },
                        child: Text(
                          'Remove',
                          style: AppTypography.of(context).caption.copyWith(
                            color: AppColors.of(context).error,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    onChanged: notifier.setNotes,
                    style: AppTypography.of(context).body,
                    decoration: InputDecoration(
                      hintText: 'e.g. Extra luggage space, airport flight details, English speaking driver...',
                      hintStyle: AppTypography.of(context).caption,
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        borderSide: BorderSide(color: AppColors.of(context).border),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        borderSide: BorderSide(color: AppColors.of(context).border),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(AppRadius.small),
                        borderSide: BorderSide(color: AppColors.of(context).primary, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 22),

          // Contact Person Section
          Text('Contact Person', style: AppTypography.of(context).h3),
          const SizedBox(height: 12),
          AppTextField(
            controller: _nameController,
            hint: 'Full name',
            prefixIcon: BootstrapIcons.person,
            onChanged: notifier.setContactName,
          ),
          const SizedBox(height: 12),
          PhoneInput(controller: _phoneController, onChanged: notifier.setContactPhone),
          const SizedBox(height: 28),

          // Primary Continue CTA
          PrimaryButton(
            label: 'Continue',
            onPressed: draft.step2Valid ? () => context.push(AppRoutes.bulkReviewRequest) : null,
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
