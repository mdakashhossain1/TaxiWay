import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/providers.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/app_back_button.dart';
import '../../../../core/widgets/app_scaffold.dart';
import '../../../../core/widgets/app_toast.dart';
import '../../../../core/widgets/ride_map_view.dart';
import '../../../../l10n/generated/app_localizations.dart';

class BookingConfirmedScreen extends ConsumerStatefulWidget {
  const BookingConfirmedScreen({super.key});

  @override
  ConsumerState<BookingConfirmedScreen> createState() => _BookingConfirmedScreenState();
}

class _BookingConfirmedScreenState extends ConsumerState<BookingConfirmedScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animController;
  late Animation<double> _checkScaleAnim;
  late Animation<Offset> _checkSlideAnim;
  late Animation<double> _detailsFadeAnim;
  late Animation<Offset> _detailsSlideAnim;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _checkScaleAnim = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.25).chain(CurveTween(curve: Curves.easeOutBack)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.25, end: 1.0).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 40,
      ),
    ]).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
      ),
    );

    _checkSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.40, 0.80, curve: Curves.easeOutCubic),
      ),
    );

    _detailsFadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOut),
      ),
    );

    _detailsSlideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.55, 1.0, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  String _getVehicleImage(String category) {
    final cat = category.toLowerCase();
    if (cat.contains('hatchback')) return 'assets/images/car_hatchback.jpg';
    if (cat.contains('suv')) return 'assets/images/car_suv.jpg';
    if (cat.contains('traveller') || cat.contains('tempo')) return 'assets/images/car_traveller.jpg';
    return 'assets/images/car_sedan.jpg';
  }

  void _showCancelDialog() {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.card)),
        title: Text(l10n.cancelRideTitle),
        content: Text(l10n.cancelRideBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.keepRideLabel),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.of(context).error,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              ref.read(bookingControllerProvider.notifier).cancelBooking();
              context.go(AppRoutes.home);
            },
            child: Text(l10n.cancelRideLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final booking = ref.watch(bookingControllerProvider);
    final driver = ref.watch(currentDriverProvider);
    final vehicle = ref.watch(currentVehicleProvider);

    if (booking == null) {
      return AppScaffold(
        appBar: AppBar(title: Text(l10n.bookingConfirmedTitle)),
        body: Center(child: Text(l10n.noActiveBookingLabel)),
      );
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: AppColors.of(context).card,
        elevation: 0,
        leading: AppBackButton(
          onPressed: () => context.go(AppRoutes.home),
        ),
        title: Text(
          l10n.bookingConfirmedTitle,
          style: AppTypography.of(context).h2.copyWith(fontSize: 18, color: AppColors.of(context).navy),
        ),
        centerTitle: true,
      ),
      body: AnimatedBuilder(
        animation: _animController,
        builder: (context, child) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SlideTransition(
                  position: _checkSlideAnim,
                  child: ScaleTransition(
                    scale: _checkScaleAnim,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E),
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF22C55E).withValues(alpha: 0.35),
                                  blurRadius: 12,
                                  spreadRadius: 2,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(Icons.check_rounded, color: Colors.white, size: 28),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                l10n.yourBookingConfirmedHeading,
                                style: AppTypography.of(context).h2.copyWith(
                                  fontSize: 18.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.of(context).navy,
                                ),
                              ),
                              const SizedBox(height: 3),
                              Text(
                                l10n.driverAllocatedSubtitle,
                                style: AppTypography.of(context).body.copyWith(
                                  fontSize: 13,
                                  color: AppColors.of(context).secondaryText,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 14),

                FadeTransition(
                  opacity: _detailsFadeAnim,
                  child: SlideTransition(
                    position: _detailsSlideAnim,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildDriverCard(driver.name, driver.rating, vehicle.model, vehicle.registrationNumber),

                        const SizedBox(height: 16),

                        _buildDriverStatusMapCard(booking),

                        const SizedBox(height: 14),

                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(AppRadius.card),
                            border: Border.all(color: AppColors.of(context).border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 38,
                                height: 38,
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDBEAFE),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: const Color(0xFFBFDBFE)),
                                ),
                                child: const Center(
                                  child: Icon(
                                    BootstrapIcons.telephone_fill,
                                    size: 16,
                                    color: Color(0xFF2563EB),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      l10n.driverMayCallTitle,
                                      style: AppTypography.of(context).label.copyWith(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.of(context).navy,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      l10n.keepPhoneReachableSubtitle,
                                      style: AppTypography.of(context).caption.copyWith(
                                        color: AppColors.of(context).secondaryText,
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        SizedBox(
                          height: 52,
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            icon: const Icon(BootstrapIcons.geo_alt_fill, size: 18),
                            label: Text(l10n.liveTrackDriverLabel),
                            onPressed: () => context.push(AppRoutes.liveTracking),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.of(context).primary,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.button),
                              ),
                              textStyle: AppTypography.of(context).button.copyWith(fontSize: 15),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: OutlinedButton(
                            onPressed: _showCancelDialog,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: const Color(0xFFEA580C),
                              side: const BorderSide(color: Color(0xFFFDBA74), width: 1.4),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(AppRadius.button),
                              ),
                              backgroundColor: Colors.white,
                            ),
                            child: Text(
                              l10n.cancelRideLabel,
                              style: AppTypography.of(context).button.copyWith(
                                color: const Color(0xFFEA580C),
                                fontWeight: FontWeight.w700,
                                fontSize: 14.5,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDriverCard(String name, double rating, String vehicleModel, String plateNumber) {
    final l10n = AppLocalizations.of(context);
    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border, width: 1),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(AppRadius.card),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              InkWell(
                onTap: () => context.push(AppRoutes.driverProfile),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.of(context).border, width: 2),
                        image: const DecorationImage(
                          image: AssetImage('assets/images/driver_avatar.jpg'),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                name,
                                style: AppTypography.of(context).h3.copyWith(
                                  fontSize: 16.5,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.of(context).navy,
                                ),
                              ),
                              const SizedBox(width: 6),
                              Icon(BootstrapIcons.chevron_right, size: 14, color: AppColors.of(context).mutedText),
                            ],
                          ),
                          const SizedBox(height: 3),
                          Row(
                            children: [
                              const Icon(Icons.star_rounded, size: 16, color: Color(0xFFEAB308)),
                              const SizedBox(width: 4),
                              Text(
                                '${rating.toStringAsFixed(1)} ${l10n.reviewCountSuffix(230)}',
                                style: AppTypography.of(context).caption.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.of(context).navy,
                                  fontSize: 12.5,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.verified_rounded, size: 12, color: Color(0xFF16A34A)),
                                const SizedBox(width: 4),
                                Text(
                                  l10n.verifiedDriverLabel,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF15803D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Material(
                      color: AppColors.of(context).card,
                      shape: const CircleBorder(),
                      elevation: 2,
                      shadowColor: Colors.black26,
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: () {
                          AppToast.call(
                            context,
                            l10n.callingDriverMessage(name),
                            title: l10n.connectingCallTitle,
                          );
                        },
                        child: Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: AppColors.of(context).border),
                          ),
                          child: Icon(
                            BootstrapIcons.telephone_fill,
                            color: AppColors.of(context).navy,
                            size: 18,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),
              Divider(height: 1, color: AppColors.of(context).border),
              const SizedBox(height: 14),

              InkWell(
                onTap: () => context.push(AppRoutes.driverProfile),
                borderRadius: BorderRadius.circular(8),
                child: Row(
                  children: [
                    Container(
                      width: 60,
                      height: 40,
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Image.asset(_getVehicleImage(vehicleModel), fit: BoxFit.contain),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            vehicleModel,
                            style: AppTypography.of(context).label.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 14,
                              color: AppColors.of(context).navy,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE2E8F0),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              plateNumber,
                              style: const TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.8,
                                color: Color(0xFF1E293B),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Icon(BootstrapIcons.chevron_right, size: 14, color: AppColors.of(context).mutedText),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDriverStatusMapCard(dynamic booking) {
    final l10n = AppLocalizations.of(context);
    final driverProgress = 1.0 - (booking.driverDistanceKm / 2.4).clamp(0.0, 1.0);

    return Container(
      decoration: BoxDecoration(
        color: AppColors.of(context).card,
        borderRadius: BorderRadius.circular(AppRadius.card),
        border: Border.all(color: AppColors.of(context).border),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F172A).withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: const BoxDecoration(
              color: Color(0xFFECFDF5),
              borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFD1FAE5),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    BootstrapIcons.car_front_fill,
                    size: 16,
                    color: Color(0xFF059669),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.driverOnWayHeading,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF065F46),
                        ),
                      ),
                      Text(
                        booking.driverDistanceKm <= 0.05 ? l10n.driverArrivedLabel : l10n.kmAwaySuffix(booking.driverDistanceKm.toStringAsFixed(1)),
                        style: const TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF047857),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      l10n.arrivingInLabel,
                      style: TextStyle(
                        fontSize: 11,
                        color: const Color(0xFF065F46).withValues(alpha: 0.8),
                      ),
                    ),
                    Text(
                      l10n.minutesShort(booking.driverEtaMinutes <= 0 ? 0 : booking.driverEtaMinutes),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w900,
                        color: Color(0xFF065F46),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(
            height: 180,
            width: double.infinity,
            child: RideMapView(
              pickup: booking.pickup,
              destination: booking.destination,
              showDestination: true,
              showDriver: true,
              driverPhase: MapDriverPhase.approachingPickup,
              driverProgress: driverProgress,
              height: 180,
              borderRadius: BorderRadius.zero,
              enableExpand: false,
              interactive: false,
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFF22C55E),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.pickupLabel,
                            style: AppTypography.of(context).caption.copyWith(
                              color: AppColors.of(context).mutedText,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            booking.pickup.shortName,
                            style: AppTypography.of(context).label.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.of(context).navy,
                              fontSize: 13.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '09:30 AM',
                      style: AppTypography.of(context).caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.of(context).navy,
                      ),
                    ),
                  ],
                ),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: SizedBox(
                      height: 14,
                      child: VerticalDivider(
                        color: Color(0xFFCBD5E1),
                        thickness: 1.5,
                        width: 2,
                      ),
                    ),
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 10,
                      height: 10,
                      margin: const EdgeInsets.only(top: 4),
                      decoration: const BoxDecoration(
                        color: Color(0xFFEA580C),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.dropLabel,
                            style: AppTypography.of(context).caption.copyWith(
                              color: AppColors.of(context).mutedText,
                              fontSize: 11,
                            ),
                          ),
                          Text(
                            booking.destination.shortName,
                            style: AppTypography.of(context).label.copyWith(
                              fontWeight: FontWeight.w700,
                              color: AppColors.of(context).navy,
                              fontSize: 13.5,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '10:05 AM',
                      style: AppTypography.of(context).caption.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.of(context).navy,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
