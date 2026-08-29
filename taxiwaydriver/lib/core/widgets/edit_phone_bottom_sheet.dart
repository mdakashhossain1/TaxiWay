import 'package:bootstrap_icons/bootstrap_icons.dart';
import 'package:flutter/material.dart';
import '../services/phone_hint_service.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import 'buttons.dart';
import 'phone_input.dart';

/// A user-friendly bottom sheet for updating the phone number directly from the OTP screen.
class EditPhoneBottomSheet extends StatefulWidget {
  final String currentPhone;
  final Future<void> Function(String newPhone) onConfirm;

  const EditPhoneBottomSheet({
    super.key,
    required this.currentPhone,
    required this.onConfirm,
  });

  static Future<String?> show(
    BuildContext context, {
    required String currentPhone,
    required Future<void> Function(String newPhone) onConfirm,
  }) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(bottom: MediaQuery.of(ctx).viewInsets.bottom),
        child: EditPhoneBottomSheet(
          currentPhone: currentPhone,
          onConfirm: onConfirm,
        ),
      ),
    );
  }

  @override
  State<EditPhoneBottomSheet> createState() => _EditPhoneBottomSheetState();
}

class _EditPhoneBottomSheetState extends State<EditPhoneBottomSheet> {
  late final TextEditingController _controller;
  String _phone = '';
  bool _loading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _phone = widget.currentPhone;
    _controller = TextEditingController(text: widget.currentPhone);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  bool get _isValid => _phone.length == 10;

  Future<void> _detectSim() async {
    final detected = await PhoneHintService.requestPhoneNumber(context);
    if (detected != null && mounted) {
      setState(() {
        _phone = detected;
        _controller.text = detected;
        _error = null;
      });
    }
  }

  Future<void> _submit() async {
    if (!_isValid || _loading) return;
    if (_phone == widget.currentPhone) {
      Navigator.of(context).pop();
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await widget.onConfirm(_phone);
      if (!mounted) return;
      Navigator.of(context).pop(_phone);
    } catch (_) {
      if (!mounted) return;
      setState(() => _error = "Couldn't send OTP. Please check the number and try again.");
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 28),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),

          // Header with edit phone icon
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  BootstrapIcons.pencil_square,
                  color: AppColors.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Change Phone Number',
                      style: AppTypography.h3.copyWith(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: AppColors.navy,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Enter your correct mobile number to receive a new OTP',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.bodyText,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          const Divider(height: 1, color: Color(0xFFF1F5F9)),
          const SizedBox(height: 20),

          // Phone input
          PhoneInput(
            controller: _controller,
            onChanged: (v) => setState(() {
              _phone = v;
              _error = null;
            }),
            onSimPickerTap: _detectSim,
          ),

          if (_error != null) ...[
            const SizedBox(height: 10),
            Text(
              _error!,
              style: AppTypography.caption.copyWith(color: AppColors.error),
            ),
          ],

          const SizedBox(height: 24),

          // Action Button
          PrimaryButton(
            label: _loading ? 'Sending OTP...' : 'Send OTP to New Number',
            icon: _loading ? null : BootstrapIcons.send_fill,
            onPressed: _isValid && !_loading ? _submit : null,
          ),

          const SizedBox(height: 10),

          Center(
            child: TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: AppTypography.button.copyWith(
                  color: AppColors.secondaryText,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
