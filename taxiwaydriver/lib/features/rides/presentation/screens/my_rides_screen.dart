import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/driver_ride.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/state/driver_rides_controller.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/driver_bottom_nav.dart';
import '../../../../core/widgets/driver_ride_card.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/page_state_builder.dart';
import '../../../../l10n/generated/app_localizations.dart';

class MyRidesScreen extends ConsumerStatefulWidget {
  const MyRidesScreen({super.key});

  @override
  ConsumerState<MyRidesScreen> createState() => _MyRidesScreenState();
}

class _MyRidesScreenState extends ConsumerState<MyRidesScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 2, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _goToTab(DriverNavTab tab) {
    context.go(tab == DriverNavTab.rides ? AppRoutes.myRides : AppRoutes.subscription);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: AppColors.of(context).appBackground,
      appBar: AppBar(
        title: Text(l10n.myRidesTitle, style: AppTypography.of(context).h2),
        automaticallyImplyLeading: false,
        leading: IconButton(
          icon: Icon(BootstrapIcons.house_fill, color: AppColors.of(context).navy),
          onPressed: () => context.go(AppRoutes.dashboard),
        ),
        bottom: TabBar(
          controller: _tabController,
          labelColor: AppColors.of(context).primary,
          unselectedLabelColor: AppColors.of(context).mutedText,
          labelStyle: AppTypography.of(context).label,
          indicatorColor: AppColors.of(context).primary,
          tabs: [Tab(text: l10n.upcomingTab), Tab(text: l10n.completedTab)],
        ),
      ),
      bottomNavigationBar: DriverBottomNav(selected: DriverNavTab.rides, onSelect: _goToTab),
      body: TabBarView(
        controller: _tabController,
        children: [
          _RideList(showCompleted: false, emptyTitle: l10n.noUpcomingRidesTitle, ascending: true),
          _RideList(showCompleted: true, emptyTitle: l10n.noCompletedRidesTitle, ascending: false),
        ],
      ),
    );
  }
}

class _RideList extends ConsumerWidget {
  final bool showCompleted;
  final String emptyTitle;
  final bool ascending;

  const _RideList({required this.showCompleted, required this.emptyTitle, required this.ascending});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ridesAsync = showCompleted ? ref.watch(completedRidesProvider) : ref.watch(upcomingRidesProvider);

    return PageStateBuilder<List<DriverRide>>(
      asyncValue: ridesAsync,
      shimmer: const RideListShimmer(itemCount: 4),
      isEmpty: (rides) => rides.isEmpty,
      emptyWidget: EmptyState(icon: BootstrapIcons.calendar3, title: emptyTitle, message: ''),
      onRetry: () async {
        if (showCompleted) {
          ref.invalidate(completedRidesProvider);
        } else {
          ref.invalidate(upcomingRidesProvider);
        }
      },
      builder: (context, rides) {
        final sorted = [...rides]..sort((a, b) => ascending ? a.dateTime.compareTo(b.dateTime) : b.dateTime.compareTo(a.dateTime));
        return ListView.builder(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          itemCount: sorted.length,
          itemBuilder: (context, index) {
            final ride = sorted[index];
            return DriverRideCard(ride: ride, onTap: () => context.push(AppRoutes.rideDetails, extra: ride));
          },
        );
      },
    );
  }
}
