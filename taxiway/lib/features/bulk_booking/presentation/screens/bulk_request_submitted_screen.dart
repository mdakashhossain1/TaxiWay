import '../../../../core/theme/app_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/buttons.dart';
import 'bulk_status_label.dart';
import '../../../../l10n/generated/app_localizations.dart';

class BulkRequestSubmittedScreen extends ConsumerWidget {
  const BulkRequestSubmittedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final request = ref.watch(bulkBookingControllerProvider).request;

    if (request == null) {
      return AppScaffold(appBar: AppBar(), body: Center(child: Text(AppLocalizations.of(context).noRequestFound)));
    }

    return AppScaffold(
      appBar: AppBar(automaticallyImplyLeading: false),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(color: AppColors.of(context).successBackground, shape: BoxShape.circle),
            child: Icon(AppIcons.check_circle_fill, color: AppColors.of(context).success, size: 42),
          ),
          const SizedBox(height: 20),
          Text(
            AppLocalizations.of(context).bulkRequestSubmittedHeading,
            style: AppTypography.of(context).h1,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          Text(
            AppLocalizations.of(context).weWillNotifyVehicles,
            style: AppTypography.of(context).bodyLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(color: AppColors.of(context).surface, borderRadius: BorderRadius.circular(AppRadius.card)),
            child: Column(
              children: [
                _Row(AppLocalizations.of(context).requestId, request.id),
                _Row(AppLocalizations.of(context).dateLabel, DateFormat('dd MMM yyyy').format(request.createdAt)),
                _Row(AppLocalizations.of(context).statusLabel, bulkStatusLabel(request.status)),
              ],
            ),
          ),
          const Spacer(),
          PrimaryButton(
            label: AppLocalizations.of(context).viewMyRequest,
            onPressed: () => context.go(AppRoutes.bulkRequestDetails),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  final String label;
  final String value;
  const _Row(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTypography.of(context).caption),
          Text(value, style: AppTypography.of(context).label),
        ],
      ),
    );
  }
}
