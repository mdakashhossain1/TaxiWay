import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/launch_utils.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/buttons.dart';
import '../../../chat/presentation/screens/chat_screen.dart';

const _topics = [
  (BootstrapIcons.car_front_fill, 'How to book a ride'),
  (BootstrapIcons.cash_stack, 'Fare and payment issues'),
  (BootstrapIcons.x_circle_fill, 'Cancellation & Refund policy'),
  (BootstrapIcons.person_dash_fill, 'Driver or vehicle feedback'),
  (BootstrapIcons.box_seam_fill, 'Lost & Found item in vehicle'),
  (BootstrapIcons.shield_check, 'Safety & Emergency support'),
  (BootstrapIcons.people_fill, 'Bulk & Corporate booking help'),
  (BootstrapIcons.three_dots, 'Other queries & feedback'),
];

class HelpSupportScreen extends ConsumerWidget {
  const HelpSupportScreen({super.key});

  Future<void> _callSupport(BuildContext context, WidgetRef ref) async {
    try {
      final number = await ref.read(appConfigRepositoryProvider).getSupportContactNumber();
      if (number == null || number.isEmpty) {
        if (context.mounted) {
          AppToast.error(context, 'Support number is not configured yet.', title: 'Unavailable');
        }
        return;
      }
      if (context.mounted) {
        AppToast.call(context, 'Connecting to Taxiway Helpline: $number...', title: 'Helpline Calling');
      }
      await launchPhoneCall(number);
    } catch (_) {
      if (context.mounted) {
        AppToast.error(context, 'Could not reach support right now. Please try again.', title: 'Something went wrong');
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return AppScaffold(
      appBar: AppBar(
        title: Text(
          'Help & Support',
          style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy),
        ),
      ),
      scrollable: true,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 6),
          Text(
            'How can we help you?',
            style: AppTypography.of(context).h2.copyWith(fontSize: 20, color: AppColors.of(context).navy),
          ),
          const SizedBox(height: 4),
          Text(
            'Browse popular topics or connect directly with our support team.',
            style: AppTypography.of(context).body.copyWith(color: AppColors.of(context).bodyText),
          ),
          const SizedBox(height: 16),
          ..._topics.map(
            (t) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: AppColors.of(context).card,
                borderRadius: BorderRadius.circular(AppRadius.card),
                border: Border.all(color: AppColors.of(context).border),
              ),
              child: ListTile(
                leading: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.of(context).primaryBackground,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(t.$1, color: AppColors.of(context).primaryDark, size: 18),
                ),
                title: Text(
                  t.$2,
                  style: AppTypography.of(context).label.copyWith(fontSize: 14, color: AppColors.of(context).navy, fontWeight: FontWeight.w600),
                ),
                trailing: Icon(BootstrapIcons.chevron_right, size: 14, color: AppColors.of(context).mutedText),
                onTap: () => AppToast.info(
                  context,
                  'Opening guide and FAQs for "${t.$2}"...',
                  title: 'Help Center',
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.of(context).primaryBackground,
              borderRadius: BorderRadius.circular(AppRadius.card),
              border: Border.all(color: AppColors.of(context).primaryBorder),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Still need help?',
                  style: AppTypography.of(context).h3.copyWith(fontSize: 15, color: AppColors.of(context).navy),
                ),
                const SizedBox(height: 2),
                Text(
                  "We're here for you.",
                  style: AppTypography.of(context).caption.copyWith(color: AppColors.of(context).bodyText),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: AppOutlineButton(
                        label: 'Call',
                        icon: BootstrapIcons.telephone_fill,
                        onPressed: () => _callSupport(context, ref),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: AppOutlineButton(
                        label: 'Message',
                        icon: BootstrapIcons.chat_dots_fill,
                        onPressed: () => context.push(AppRoutes.chat, extra: const ChatScreenArgs(title: 'Support')),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
