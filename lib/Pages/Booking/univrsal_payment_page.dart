// ignore_for_file: deprecated_member_use, curly_braces_in_flow_control_structures, avoid_print, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/Bloc/BookingBloc/confirm_booking_cubit.dart';
import 'package:healthcareapp_try1/Pages/Booking/healtcare_provider.dart';
import 'package:healthcareapp_try1/Pages/Booking/payment_view.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/Widgets/success_lottie_widget.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class BookingConfirmationPage extends StatelessWidget {
  final HealthcareProvider provider;
  final String selectedService;
  final DateTime selectedDate;
  final String selectedTime;
  final String slotId;
  final String token;
  final double? totalFee;
  final double? serviceFee;
  final String providerType;
  final int? hours;
  final List<String>? labTestsIds;
  final List<String>? labTestsNames;

  const BookingConfirmationPage({
    super.key,
    required this.provider,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTime,
    required this.slotId,
    required this.token,
    required this.providerType,
    this.labTestsIds,
    this.hours,
    this.totalFee,
    this.serviceFee,
    this.labTestsNames,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => BookingCubit(context.read<UserService>()),
      child: _BookingConfirmationView(
        provider: provider,
        selectedService: selectedService,
        selectedDate: selectedDate,
        selectedTime: selectedTime,
        slotId: slotId,
        token: token,
        providerType: providerType,
        hours: hours,
        totalFee: totalFee,
        labTestsIds: labTestsIds,
        labTestsNames: labTestsNames,
      ),
    );
  }
}

class _BookingConfirmationView extends StatefulWidget {
  final HealthcareProvider provider;
  final String selectedService;
  final DateTime selectedDate;
  final String selectedTime;
  final String slotId;
  final String token;
  final String providerType;
  final int? hours;
  final List<String>? labTestsIds;
  final List<String>? labTestsNames;
  final double? totalFee;

  const _BookingConfirmationView({
    required this.provider,
    required this.selectedService,
    required this.selectedDate,
    required this.selectedTime,
    required this.slotId,
    required this.token,
    required this.providerType,
    this.labTestsIds,
    this.hours,
    this.labTestsNames,
    this.totalFee,
  });

  @override
  State<_BookingConfirmationView> createState() =>
      _BookingConfirmationViewState();
}

class _BookingConfirmationViewState extends State<_BookingConfirmationView> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _savedAddress;

  // ─── Dark-mode helpers ────────────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _pageBg => _isDark ? AppColors.bgDark : Colors.grey.shade100;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : AppColors.textLight;
  Color get _secondaryText => _isDark
      ? AppColors.textDark.withOpacity(0.6)
      : AppColors.textLight.withOpacity(0.6);
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color get _hintColor =>
      _isDark ? Colors.white.withOpacity(0.35) : Colors.grey.shade400;
  Color get _inputFill =>
      _isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50;
  // ─────────────────────────────────────────────────────────────────────────

  bool get _isAddressRequired =>
      widget.selectedService == "Home Visit" || widget.providerType == "Nurse";

  bool get _isAddressValid => _addressController.text.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    _loadSavedAddress();
    _addressController.addListener(() => setState(() {}));
  }

  Future<void> _loadSavedAddress() async {
    final prefs = await SharedPreferences.getInstance();

    final address =
        prefs.getString('address') ??
        prefs.getString('user_address') ??
        prefs.getString('userAddress') ??
        '';

    if (address.isEmpty) {
      final userJson =
          prefs.getString('user') ?? prefs.getString('userData') ?? '';
      if (userJson.isNotEmpty) {
        try {
          final map = jsonDecode(userJson);
          final fromJson = map['address'] ?? '';
          if (mounted) setState(() => _savedAddress = fromJson);
          return;
        } catch (_) {}
      }
    }

    if (mounted) {
      setState(() => _savedAddress = address.isEmpty ? null : address);
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  // ─── Build ────────────────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<BookingCubit, BookingState>(
      listener: (context, state) {
        if (state is BookingLoading) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (_) => const Center(child: SizedBox()),
          );
        } else if (state is BookingSuccess) {
          if (Navigator.canPop(context)) Navigator.pop(context);

          if (widget.selectedService == "Online" && state.paymentUrl != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => PaymentScreen(paymentUrl: state.paymentUrl!),
                fullscreenDialog: true,
              ),
            ).then((ok) {
              if (ok == true) _showSuccessDialog(context);
            });
          } else {
            _showSuccessDialog(context);
          }
        } else if (state is BookingError) {
          if (Navigator.canPop(context)) Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: _pageBg,
          appBar: AppBar(
            backgroundColor: _cardBg,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back_ios_new, color: _primaryText),
              onPressed: () => Navigator.pop(context),
            ),
            title: Text(
              'Confirm Booking',
              style: TextStyle(
                color: _primaryText,
                fontWeight: FontWeight.bold,
                fontFamily: 'Cotta',
              ),
            ),
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderCard(),
                const SizedBox(height: 16),
                _buildDetailsCard(),
                const SizedBox(height: 16),
                _buildLabTestsCard(),
                const SizedBox(height: 16),
                _buildNotesField(),
                if (_isAddressRequired) ...[
                  const SizedBox(height: 16),
                  _buildAddressField(),
                ],
                const SizedBox(height: 10),
                if (widget.selectedService == "Online")
                  _buildOnlineNotice()
                else
                  const SizedBox(height: 1),
                const SizedBox(height: 10),
                _buildConfirmButton(context, state),
                const SizedBox(height: 10),
              ],
            ),
          ),
        );
      },
    );
  }

  // ─── Widgets ──────────────────────────────────────────────────────────────

  Widget _buildProviderCard() {
    return _card(
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(
              widget.provider.profilePictureUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (_, __, ___) => Container(
                width: 70,
                height: 70,
                color: _isDark
                    ? Colors.blue.shade900.withOpacity(0.4)
                    : Colors.blue.shade50,
                child: Icon(Icons.person, color: _accent, size: 40),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.provider.name,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                    color: _primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider.subTitle,
                  style: TextStyle(
                    fontSize: 14,
                    color: _accent,
                    fontFamily: 'Agency',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  widget.provider.location,
                  style: TextStyle(
                    fontSize: 12,
                    color: _secondaryText,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailsCard() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Booking Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
              color: _primaryText,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow(
            FontAwesomeIcons.briefcaseMedical,
            'Service',
            widget.selectedService,
            Colors.blue,
          ),
          Divider(height: 24, color: _borderColor),
          _buildDetailRow(
            FontAwesomeIcons.calendarDay,
            'Date',
            DateFormat('EEEE, dd MMM yyyy').format(widget.selectedDate),
            Colors.orange,
          ),
          Divider(height: 24, color: _borderColor),
          _buildDetailRow(
            FontAwesomeIcons.clock,
            'Time',
            widget.selectedTime.length >= 5
                ? widget.selectedTime.substring(0, 5)
                : widget.selectedTime,
            Colors.green,
          ),
          if (widget.totalFee != null && widget.totalFee! > 0) ...[
            Divider(height: 24, color: _borderColor),
            _buildDetailRow(
              FontAwesomeIcons.moneyBillWave,
              'Total Amount',
              '${widget.totalFee!.toStringAsFixed(2)} EGP',
              Colors.deepPurpleAccent,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(_isDark ? 0.18 : 0.10),
            borderRadius: BorderRadius.circular(10),
          ),
          child: FaIcon(icon, color: color, size: 16),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: _secondaryText,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 2),
            Text(
              value,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: 'Agency',
                color: _primaryText,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildNotesField() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notes (Optional)',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
              color: _primaryText,
            ),
          ),
          const SizedBox(height: 10),
          _styledTextField(
            controller: _notesController,
            hintText: 'Any notes for the doctor...',
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildAddressField() {
    return _card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Home Address',
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                  color: _primaryText,
                ),
              ),
              if (_savedAddress != null && _savedAddress!.isNotEmpty)
                GestureDetector(
                  onTap: () =>
                      setState(() => _addressController.text = _savedAddress!),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _accent.withOpacity(0.10),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: _accent.withOpacity(0.30)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.my_location, size: 14, color: _accent),
                        const SizedBox(width: 4),
                        Text(
                          'Use My Address',
                          style: TextStyle(
                            fontSize: 12,
                            color: _accent,
                            fontFamily: 'Agency',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          _styledTextField(
            controller: _addressController,
            hintText: 'Enter your address...',
            prefixIcon: const Icon(
              Icons.location_on_outlined,
              color: Colors.red,
            ),
            errorText: _isAddressRequired && !_isAddressValid
                ? "Address is required"
                : null,
          ),
        ],
      ),
    );
  }

  Widget _buildOnlineNotice() {
    return _card(
      child: Text(
        "Online consultations can be paid for via online payment only",
        style: TextStyle(
          color: _secondaryText,
          fontSize: 14,
          fontFamily: 'Agency',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildConfirmButton(BuildContext context, BookingState state) {
    final isLoading = state is BookingLoading;
    final isDisabled = isLoading || (_isAddressRequired && !_isAddressValid);

    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: isDisabled ? null : () => _onConfirm(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: _accent,
          disabledBackgroundColor: _isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.grey.shade300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: isLoading
            ? const CustomSpinner(color: Colors.white, size: 24)
            : const Text(
                'Confirm Booking',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Agency',
                ),
              ),
      ),
    );
  }

  Widget _buildLabTestsCard() {
    if (widget.labTestsNames == null || widget.labTestsNames!.isEmpty) {
      return const SizedBox.shrink();
    }

    return _card(
      margin: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.biotech_rounded,
                color: _isDark ? Colors.teal.shade200 : Colors.teal,
                size: 22,
              ),
              const SizedBox(width: 8),
              Text(
                'Selected Lab Tests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cotta',
                  color: _primaryText,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: widget.labTestsNames!.map((testName) {
              final chipColor = _isDark ? Colors.teal.shade200 : Colors.teal;
              return Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: chipColor.withOpacity(_isDark ? 0.15 : 0.08),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: chipColor.withOpacity(_isDark ? 0.35 : 0.30),
                  ),
                ),
                child: Text(
                  testName,
                  style: TextStyle(
                    fontSize: 13,
                    color: chipColor,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'Agency',
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  /// Shared card container with dark-aware background + shadow.
  Widget _card({required Widget child, EdgeInsets? margin}) {
    return Container(
      margin: margin,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: _isDark
                ? Colors.black.withOpacity(0.25)
                : Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: child,
    );
  }

  /// Shared text-field with dark-aware styling.
  Widget _styledTextField({
    required TextEditingController controller,
    required String hintText,
    int maxLines = 1,
    Widget? prefixIcon,
    String? errorText,
  }) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _borderColor),
    );
    final focusedBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(12),
      borderSide: BorderSide(color: _accent),
    );

    return TextField(
      controller: controller,
      maxLines: maxLines,
      style: TextStyle(color: _primaryText, fontFamily: 'Agency'),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: TextStyle(color: _hintColor, fontFamily: 'Agency'),
        filled: true,
        fillColor: _inputFill,
        prefixIcon: prefixIcon,
        border: border,
        enabledBorder: border,
        focusedBorder: focusedBorder,
        errorText: errorText,
        errorStyle: const TextStyle(fontFamily: 'Agency'),
      ),
    );
  }

  // ─── Logic ────────────────────────────────────────────────────────────────

  void _onConfirm(BuildContext context) {
    final isNurse = widget.providerType == "Nurse";
    final isDoctorHomeVisit =
        widget.providerType == "Doctor" &&
        widget.selectedService == "Home Visit";

    String? address = _addressController.text.trim();
    if ((isNurse || isDoctorHomeVisit) && address.isEmpty) {
      if (_savedAddress != null && _savedAddress!.isNotEmpty) {
        address = _savedAddress;
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Address is required for this service")),
        );
        return;
      }
    }

    String appointmentType;

    // 2️⃣ تحديد نوع الموعد
    if (isNurse) {
      // الـ Nurse عنده خدمتين بس
      appointmentType = widget.selectedService == "Hourly Rate"
          ? "HourlyStay"
          : "QuickVisit";
    } else {
      switch (widget.selectedService) {
        case "Clinic Visit":
          appointmentType = "OnSiteVisit";
          break;
        case "Home Visit":
          appointmentType = "HomeVisit";
          break;
        case "Lab Visit":
          appointmentType = "OnSiteVisit";
          break;
        case "Online":
          appointmentType = "Online";
          break;
        default:
          appointmentType = widget.selectedService;
      }
    }

    String finalTime;
    try {
      final tempTime = DateFormat.jm().parse(widget.selectedTime);
      finalTime = DateFormat("HH:mm:ss").format(tempTime);
    } catch (_) {
      String raw = widget.selectedTime.split(' ')[0];
      if (raw.length == 4) raw = "0$raw";
      finalTime = raw.contains(':') && raw.length <= 5 ? "$raw:00" : raw;
    }

    print("Final Time to be sent: $finalTime");

    context.read<BookingCubit>().confirmBooking(
      providerId: widget.provider.id,
      slotId: widget.providerType == "Lab" ? "" : widget.slotId,
      appointmentType: appointmentType,
      startTime: finalTime,
      token: widget.token,
      providerType: widget.providerType,
      notes: _notesController.text.trim(),
      address: address,
      hours: widget.hours ?? 1,
      labTestsIds: widget.labTestsIds,
      date: widget.selectedDate.toIso8601String().split('T')[0],
    );
  }

  void _showSuccessDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => AlertDialog(
        backgroundColor: _cardBg,
        title: Column(
          children: [
            const SuccessLottieWidget(),
            Text(
              "Booking Confirmed!",
              style: TextStyle(fontFamily: 'Cotta', color: _primaryText),
            ),
          ],
        ),
        content: Text(
          "Your appointment and payment have been processed successfully.",
          textAlign: TextAlign.center,
          style: TextStyle(fontFamily: 'Agency', color: _secondaryText),
        ),
        actions: [
          TextButton(
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(_accent),
              foregroundColor: MaterialStateProperty.all(Colors.white),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            onPressed: () => Navigator.of(context).popUntil((r) => r.isFirst),
            child: const Text(
              "Back to Booking Page",
              style: TextStyle(
                fontFamily: 'Agency',
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
