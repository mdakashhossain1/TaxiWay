import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/models/trip_history_item.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_shimmer.dart';
import '../../../../core/widgets/empty_state.dart';
import '../../../../core/widgets/page_state_builder.dart';
import '../../../../core/widgets/trip_card.dart';

class TripHistoryScreen extends ConsumerStatefulWidget {
  const TripHistoryScreen({super.key});

  @override
  ConsumerState<TripHistoryScreen> createState() => _TripHistoryScreenState();
}

class _TripHistoryScreenState extends ConsumerState<TripHistoryScreen> with SingleTickerProviderStateMixin {
  late final TabController _tabController = TabController(length: 4, vsync: this);

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  List<TripHistoryItem> _filtered(List<TripHistoryItem> all, int index) {
    if (index == 0) return all;
    final bucket = TripFilter.values[index];
    return all.where((t) => t.filterBucket == bucket).toList();
  }

  @override
  Widget build(BuildContext context) {
    final tripsAsync = ref.watch(tripHistoryControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Trip History'),
        leading: const AppBackButton(),
        automaticallyImplyLeading: false,
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabAlignment: TabAlignment.start,
          tabs: const [Tab(text: 'All'), Tab(text: 'Upcoming'), Tab(text: 'Completed'), Tab(text: 'Cancelled')],
        ),
      ),
      body: PageStateBuilder<List<TripHistoryItem>>(
        asyncValue: tripsAsync,
        shimmer: const RideListShimmer(itemCount: 4),
        onRetry: () async => ref.invalidate(tripHistoryControllerProvider),
        builder: (context, trips) => TabBarView(
          controller: _tabController,
          children: List.generate(4, (index) {
            final list = _filtered(trips, index);
            if (list.isEmpty) {
              return const EmptyState(
                icon: BootstrapIcons.receipt,
                title: 'No trips yet',
                message: 'Your bookings will appear here.',
              );
            }
            return ListView.builder(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
              itemCount: list.length,
              itemBuilder: (context, i) => TripCard(
                booking: list[i].booking,
                onTap: () => context.push(AppRoutes.tripDetails, extra: list[i]),
              )
                  .animate()
                  .fadeIn(delay: (50 * i).ms, duration: 260.ms)
                  .slideY(begin: 0.08, end: 0, delay: (50 * i).ms, duration: 260.ms, curve: Curves.easeOutCubic),
            );
          }),
        ),
      ),
    );
  }
}
