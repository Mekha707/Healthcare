// // lib/Pages/AppointmentDetails/appointment_details_page.dart
// // ignore_for_file: deprecated_member_use, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_styled_toast/flutter_styled_toast.dart';
// import 'package:healthcareapp_try1/API/user_service.dart';
// import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_submit.cubit.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
// import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
// import 'package:healthcareapp_try1/core/gradient_avatar.dart';
// import 'package:healthcareapp_try1/core/string_extension.dart';
// import 'package:healthcareapp_try1/core/theme/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:url_launcher/url_launcher.dart';

// class AppointmentDetailsPage extends StatelessWidget {
//   const AppointmentDetailsPage({super.key});

//   bool _isDark(BuildContext context) =>
//       Theme.of(context).brightness == Brightness.dark;

//   Color _pageBg(BuildContext context) =>
//       _isDark(context) ? AppColors.bgDark : Colors.grey.shade50;

//   Color _cardBg(BuildContext context) =>
//       _isDark(context) ? AppColors.surfaceDark : Colors.white;

//   Color _primaryText(BuildContext context) =>
//       _isDark(context) ? AppColors.textDark : AppColors.textLight;

//   Color _secondaryText(BuildContext context) => _isDark(context)
//       ? AppColors.textDark.withOpacity(0.72)
//       : Colors.grey.shade700;

//   Color _borderColor(BuildContext context) =>
//       _isDark(context) ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: _pageBg(context),
//       body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
//         builder: (context, state) {
//           if (state is AppointmentDetailsLoading) {
//             return _buildSkeleton(context);
//           }
//           if (state is AppointmentDetailsError) {
//             return _buildError(state.message, context);
//           }
//           if (state is DoctorAppointmentLoaded) {
//             return _buildDoctor(state.data, context);
//           }
//           if (state is NurseAppointmentLoaded) {
//             return _buildNurse(state.data, context);
//           }
//           if (state is LabAppointmentLoaded) {
//             return _buildLab(state.data, context);
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   Widget _buildDoctor(DoctorAppointmentDetails d, BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildBlueHeader(
//             name: d.doctorName,
//             subtitle: 'Doctor · ${d.appointmentType}',
//             status: d.status,
//             context: context,
//             stats: [
//               _statItem(context, 'Date', d.date),
//               _statItem(
//                 context,
//                 'Time',
//                 '${d.startTime.substring(0, 5)} – ${d.endTime.substring(0, 5)}',
//               ),
//               _statItem(context, 'Fee', '${d.fee.toStringAsFixed(0)} EGP'),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _infoCard(context, 'Appointment info', [
//                   if (d.address != null)
//                     _rowItem(context, 'Address', d.address!),
//                   _rowItem(context, 'Payment', d.paymentType),
//                   if (d.notes != null) _rowItem(context, 'Notes', d.notes!),
//                 ]),
//                 if (d.diagnosis != null || d.prescriptions != null)
//                   _sectionCard(
//                     context,
//                     'Diagnosis & prescription',
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (d.diagnosis != null) ...[
//                           _subLabel(context, 'Diagnosis'),
//                           _arabicBox(
//                             context,
//                             d.diagnosis!,
//                             _isDark(context)
//                                 ? AppColors.bgDark.withOpacity(0.6)
//                                 : Colors.grey.shade50,
//                           ),
//                           const SizedBox(height: 12),
//                         ],
//                         if (d.prescriptions != null) ...[
//                           _subLabel(context, 'Prescription'),
//                           _arabicBox(
//                             context,
//                             d.prescriptions!,
//                             _isDark(context)
//                                 ? Colors.blue.withOpacity(0.14)
//                                 : Colors.blue.shade50,
//                             textColor: _isDark(context)
//                                 ? Colors.blue.shade100
//                                 : Colors.blue.shade800,
//                           ),
//                         ],
//                       ],
//                     ),
//                   ),
//                 if (d.requiredTests.isNotEmpty)
//                   _sectionCard(
//                     context,
//                     'Required tests',
//                     Column(
//                       children: d.requiredTests
//                           .map((t) => _testRow(context, t.testName, t.status))
//                           .toList(),
//                     ),
//                   ),
//                 if (d.review != null) _reviewCard(context, d.review!),
//                 _reviewButton(
//                   context,
//                   targetId: d.doctorId,
//                   targetType: 'Doctor',
//                   existingReview: d.review,
//                 ),
//                 const SizedBox(height: 5),
//                 ButtonOfAuth(
//                   onPressed: () {},
//                   fontcolor: Colors.white,
//                   buttoncolor: AppColors.primary,
//                   buttonText: "Join Now",
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildNurse(NurseAppointmentDetails n, BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildBlueHeader(
//             name: n.nurseName,
//             subtitle: 'Nurse · ${n.serviceType}',
//             status: n.status,
//             context: context,
//             stats: [
//               _statItem(context, 'Date', n.date),
//               _statItem(
//                 context,
//                 'Shift',
//                 '${n.shiftStartTime.substring(0, 5)} – ${n.shiftEndTime.substring(0, 5)}',
//               ),
//               _statItem(context, 'Fee', '${n.totalFee.toStringAsFixed(0)} EGP'),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _infoCard(context, 'Appointment info', [
//                   _rowItem(context, 'Service', n.serviceType),
//                   if (n.address != null)
//                     _rowItem(context, 'Address', n.address!),
//                   if (n.hours != null)
//                     _rowItem(context, 'Hours', '${n.hours}h'),
//                   if (n.notes != null) _rowItem(context, 'Notes', n.notes!),
//                 ]),
//                 if (n.review != null) _reviewCard(context, n.review!),
//                 _reviewButton(
//                   context,
//                   targetId: n.nurseId,
//                   targetType: 'Nurse',
//                   existingReview: n.review,
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildLab(LabAppointmentDetails l, BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildBlueHeader(
//             name: l.labName,
//             subtitle: 'Lab · ${l.appointmentType}',
//             status: l.status,
//             context: context,
//             stats: [
//               _statItem(context, 'Date', l.date),
//               _statItem(context, 'Fee', '${l.totalFee.toStringAsFixed(0)} EGP'),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               children: [
//                 _infoCard(context, 'Appointment info', [
//                   if (l.address != null)
//                     _rowItem(context, 'Address', l.address!),
//                   if (l.notes != null) _rowItem(context, 'Notes', l.notes!),
//                 ]),
//                 if (l.testResults.isNotEmpty)
//                   _sectionCard(
//                     context,
//                     'Test results',
//                     Column(
//                       children: l.testResults
//                           .map((r) => _labResultItem(context, r))
//                           .toList(),
//                     ),
//                   ),
//                 if (l.review != null) _reviewCard(context, l.review!),
//                 _reviewButton(
//                   context,
//                   targetId: l.labId,
//                   targetType: 'Lab',
//                   existingReview: l.review,
//                 ),
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBlueHeader({
//     required String name,
//     required String subtitle,
//     required String status,
//     required BuildContext context,
//     required List<Widget> stats,
//   }) {
//     final isDark = _isDark(context);

//     return Container(
//       decoration: BoxDecoration(
//         gradient: LinearGradient(
//           colors: isDark
//               ? [AppColors.surfaceDark, AppColors.primaryDark]
//               : const [Color(0xff0A74FF), Color(0xff0047CC)],
//           begin: Alignment.topLeft,
//           end: Alignment.bottomRight,
//         ),
//         borderRadius: const BorderRadius.only(
//           bottomLeft: Radius.circular(24),
//           bottomRight: Radius.circular(24),
//         ),
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
//       child: Column(
//         children: [
//           Row(
//             children: [
//               GradientAvatar(name: name, size: 52, fontSize: 22),
//               const SizedBox(width: 12),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       textDirection: name.getDirection,
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 18,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cotta',
//                       ),
//                     ),
//                     const SizedBox(height: 3),
//                     Text(
//                       subtitle,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.82),
//                         fontSize: 13,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               _statusBadge(context, status),
//               const SizedBox(width: 4),
//               IconButton(
//                 icon: const Icon(
//                   Icons.arrow_back_ios_new,
//                   color: Colors.white,
//                   size: 18,
//                 ),
//                 onPressed: () => Navigator.pop(context),
//               ),
//             ],
//           ),
//           const SizedBox(height: 14),
//           Row(children: stats.map((s) => Expanded(child: s)).toList()),
//         ],
//       ),
//     );
//   }

//   Widget _statItem(BuildContext context, String label, String value) {
//     return Container(
//       margin: const EdgeInsets.only(right: 8),
//       padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
//       decoration: BoxDecoration(
//         color: Colors.white.withOpacity(_isDark(context) ? 0.10 : 0.15),
//         borderRadius: BorderRadius.circular(10),
//         border: Border.all(
//           color: Colors.white.withOpacity(_isDark(context) ? 0.08 : 0.0),
//         ),
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text(
//             label,
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.white.withOpacity(0.75),
//             ),
//           ),
//           const SizedBox(height: 3),
//           Text(
//             value,
//             style: const TextStyle(
//               fontSize: 13,
//               fontWeight: FontWeight.bold,
//               color: Colors.white,
//               fontFamily: 'Agency',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _infoCard(BuildContext context, String title, List<Widget> rows) {
//     return _sectionCard(context, title, Column(children: rows));
//   }

//   Widget _sectionCard(BuildContext context, String title, Widget child) {
//     return Container(
//       width: double.infinity,
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(18),
//       decoration: BoxDecoration(
//         color: _cardBg(context),
//         borderRadius: BorderRadius.circular(16),
//         border: Border.all(color: _borderColor(context)),
//         boxShadow: [
//           BoxShadow(
//             color: _isDark(context)
//                 ? Colors.black.withOpacity(0.16)
//                 : Colors.black.withOpacity(0.08),
//             blurRadius: 20,
//             offset: const Offset(0, 10),
//           ),
//         ],
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         children: [
//           Text(
//             title.toUpperCase(),
//             style: TextStyle(
//               fontSize: 15,
//               fontWeight: FontWeight.bold,
//               color: _secondaryText(context),
//               letterSpacing: 0.6,
//             ),
//           ),
//           const SizedBox(height: 12),
//           child,
//         ],
//       ),
//     );
//   }

//   Widget _rowItem(BuildContext context, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 7),
//       child: Row(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: 80,
//             child: Text(
//               label,
//               style: TextStyle(fontSize: 13, color: _secondaryText(context)),
//             ),
//           ),
//           const SizedBox(width: 8),
//           Expanded(
//             child: Text(
//               value,
//               textDirection: value.getDirection,
//               textAlign: value.getTextAlign,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontWeight: FontWeight.w500,
//                 color: _primaryText(context),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _testRow(BuildContext context, String name, String status) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 7),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Text(
//               name,
//               style: TextStyle(
//                 fontSize: 13,
//                 fontFamily: 'Agency',
//                 color: _primaryText(context),
//               ),
//             ),
//           ),
//           const SizedBox(width: 10),
//           _statusBadge(context, status),
//         ],
//       ),
//     );
//   }

//   Widget _labResultItem(BuildContext context, LabTestResult r) {
//     final isDark = _isDark(context);

//     return Container(
//       margin: const EdgeInsets.only(bottom: 10),
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         border: Border.all(color: _borderColor(context)),
//         borderRadius: BorderRadius.circular(10),
//         color: isDark ? AppColors.bgDark.withOpacity(0.35) : null,
//       ),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Text(
//                   r.testName,
//                   style: TextStyle(
//                     fontSize: 13,
//                     fontWeight: FontWeight.w600,
//                     color: _primaryText(context),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 8),
//               Text(
//                 r.value.toStringAsFixed(2),
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: isDark
//                       ? Colors.blue.shade200
//                       : const Color(0xff0861dd),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             r.summary,
//             style: TextStyle(
//               fontSize: 12,
//               color: _secondaryText(context),
//               height: 1.4,
//             ),
//           ),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               _statusBadge(context, r.status),
//               if (r.resultFileUrl.isNotEmpty)
//                 GestureDetector(
//                   onTap: () => launchUrl(
//                     Uri.parse(r.resultFileUrl),
//                     mode: LaunchMode.externalApplication,
//                   ),
//                   child: Container(
//                     padding: const EdgeInsets.symmetric(
//                       horizontal: 10,
//                       vertical: 6,
//                     ),
//                     decoration: BoxDecoration(
//                       border: Border.all(
//                         color: isDark
//                             ? Colors.blue.withOpacity(0.28)
//                             : Colors.blue.shade200,
//                       ),
//                       borderRadius: BorderRadius.circular(8),
//                       color: isDark ? Colors.blue.withOpacity(0.08) : null,
//                     ),
//                     child: Row(
//                       children: [
//                         Icon(
//                           Icons.download_outlined,
//                           size: 14,
//                           color: isDark
//                               ? Colors.blue.shade200
//                               : Colors.blue.shade700,
//                         ),
//                         const SizedBox(width: 4),
//                         Text(
//                           'Download PDF',
//                           style: TextStyle(
//                             fontSize: 12,
//                             color: isDark
//                                 ? Colors.blue.shade200
//                                 : Colors.blue.shade700,
//                             fontFamily: 'Agency',
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _reviewCard(BuildContext context, ReviewDetails r) {
//     return _sectionCard(
//       context,
//       'Patient review',
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               GradientAvatar(name: r.patientName, size: 36, fontSize: 14),
//               const SizedBox(width: 10),
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       r.patientName,
//                       style: TextStyle(
//                         fontSize: 13,
//                         fontWeight: FontWeight.w600,
//                         color: _primaryText(context),
//                       ),
//                     ),
//                     Text(
//                       '${r.date.day}/${r.date.month}/${r.date.year}${r.isUpdated ? ' · edited' : ''}',
//                       style: TextStyle(
//                         fontSize: 11,
//                         color: _secondaryText(context),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               Row(
//                 children: List.generate(
//                   5,
//                   (i) => Icon(
//                     i < r.rating
//                         ? Icons.star_rounded
//                         : Icons.star_outline_rounded,
//                     size: 16,
//                     color: i < r.rating ? Colors.amber : Colors.grey.shade300,
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//           _arabicBox(
//             context,
//             r.comment,
//             _isDark(context)
//                 ? AppColors.bgDark.withOpacity(0.6)
//                 : Colors.grey.shade50,
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _arabicBox(
//     BuildContext context,
//     String text,
//     Color bg, {
//     Color? textColor,
//   }) {
//     return Container(
//       width: double.infinity,
//       padding: const EdgeInsets.all(12),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Text(
//         text,
//         textDirection: text.getDirection,
//         textAlign: text.getTextAlign,
//         style: TextStyle(
//           fontSize: 13,
//           height: 1.5,
//           color: textColor ?? _primaryText(context),
//         ),
//       ),
//     );
//   }

//   Widget _subLabel(BuildContext context, String text) => Padding(
//     padding: const EdgeInsets.only(bottom: 4),
//     child: Text(
//       text,
//       style: TextStyle(fontSize: 11, color: _secondaryText(context)),
//     ),
//   );

//   Widget _statusBadge(BuildContext context, String status) {
//     final isDark = _isDark(context);

//     Color bg;
//     Color fg;
//     switch (status) {
//       case 'Completed':
//       case 'ResultsDone':
//         bg = isDark ? Colors.green.withOpacity(0.14) : Colors.green.shade50;
//         fg = isDark ? Colors.green.shade200 : Colors.green.shade800;
//         break;
//       case 'Pending':
//         bg = isDark ? Colors.orange.withOpacity(0.14) : Colors.orange.shade50;
//         fg = isDark ? Colors.orange.shade200 : Colors.orange.shade800;
//         break;
//       case 'Confirmed':
//         bg = isDark ? Colors.blue.withOpacity(0.14) : Colors.blue.shade50;
//         fg = isDark ? Colors.blue.shade200 : Colors.blue.shade800;
//         break;
//       case 'Cancelled':
//         bg = isDark ? Colors.red.withOpacity(0.14) : Colors.red.shade50;
//         fg = isDark ? Colors.red.shade200 : Colors.red.shade800;
//         break;
//       default:
//         bg = isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100;
//         fg = isDark ? AppColors.textLight : Colors.grey.shade700;
//     }

//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: bg,
//         borderRadius: BorderRadius.circular(20),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(Icons.circle, size: 6, color: fg),
//           const SizedBox(width: 5),
//           Text(
//             status,
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w600,
//               color: fg,
//               fontFamily: 'Agency',
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSkeleton(BuildContext context) => Center(
//     child: CustomSpinner(
//       size: 40,
//       color: _isDark(context) ? AppColors.textLight : const Color(0xff0861dd),
//     ),
//   );

//   Widget _buildError(String msg, BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
//         const SizedBox(height: 12),
//         Text(
//           msg,
//           style: TextStyle(
//             color: _isDark(context) ? Colors.red.shade300 : Colors.red.shade700,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ElevatedButton(
//           onPressed: () => Navigator.pop(context),
//           child: const Text('Go back'),
//         ),
//       ],
//     ),
//   );

//   void _showReviewSheet(
//     BuildContext context, {
//     required String targetId,
//     required String targetType,
//     ReviewDetails? existingReview,
//   }) {
//     final isDark = _isDark(context);
//     int selectedRating = existingReview?.rating ?? 0;
//     final commentController = TextEditingController(
//       text: existingReview?.comment ?? '',
//     );

//     showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
//       shape: const RoundedRectangleBorder(
//         borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
//       ),
//       builder: (_) => BlocProvider(
//         create: (_) => ReviewSubmitCubit(UserService()),
//         child: StatefulBuilder(
//           builder: (ctx, setSheetState) {
//             final sheetDark = _isDark(ctx);

//             return BlocListener<ReviewSubmitCubit, ReviewSubmitState>(
//               listener: (ctx, state) {
//                 if (state is ReviewSubmitSuccess) {
//                   context.read<AppointmentDetailsCubit>().refresh().then((_) {
//                     Navigator.pop(ctx);
//                     showToast(
//                       existingReview != null
//                           ? 'تم تعديل التقييم بنجاح'
//                           : 'تم إرسال التقييم بنجاح',
//                     );
//                   });
//                 }
//                 if (state is ReviewSubmitError) {
//                   showToast(state.message);
//                 }
//               },
//               child: Padding(
//                 padding: EdgeInsets.fromLTRB(
//                   16,
//                   20,
//                   16,
//                   MediaQuery.of(ctx).viewInsets.bottom + 20,
//                 ),
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Center(
//                       child: Container(
//                         width: 40,
//                         height: 4,
//                         decoration: BoxDecoration(
//                           color: sheetDark
//                               ? Colors.white24
//                               : Colors.grey.shade300,
//                           borderRadius: BorderRadius.circular(2),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Text(
//                       existingReview != null
//                           ? 'Edit your review'
//                           : 'Add your review',
//                       style: TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Cotta',
//                         color: _primaryText(ctx),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     Center(
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: List.generate(
//                           5,
//                           (i) => GestureDetector(
//                             onTap: () =>
//                                 setSheetState(() => selectedRating = i + 1),
//                             child: Icon(
//                               i < selectedRating
//                                   ? Icons.star_rounded
//                                   : Icons.star_outline_rounded,
//                               size: 40,
//                               color: i < selectedRating
//                                   ? Colors.amber
//                                   : (sheetDark
//                                         ? Colors.white24
//                                         : Colors.grey.shade300),
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     TextField(
//                       controller: commentController,
//                       maxLines: 3,
//                       textDirection: TextDirection.rtl,
//                       style: TextStyle(color: _primaryText(ctx)),
//                       decoration: InputDecoration(
//                         hintText: 'اكتب تعليقك هنا...',
//                         hintTextDirection: TextDirection.rtl,
//                         hintStyle: TextStyle(color: _secondaryText(ctx)),
//                         filled: true,
//                         fillColor: sheetDark
//                             ? AppColors.bgDark.withOpacity(0.7)
//                             : Colors.white,
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: _borderColor(ctx)),
//                         ),
//                         enabledBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: BorderSide(color: _borderColor(ctx)),
//                         ),
//                         focusedBorder: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(12),
//                           borderSide: const BorderSide(
//                             color: Color(0xff0861dd),
//                           ),
//                         ),
//                       ),
//                     ),
//                     const SizedBox(height: 16),
//                     BlocBuilder<ReviewSubmitCubit, ReviewSubmitState>(
//                       builder: (ctx, state) {
//                         final isLoading = state is ReviewSubmitLoading;
//                         return SizedBox(
//                           width: double.infinity,
//                           child: ElevatedButton(
//                             onPressed: selectedRating == 0 || isLoading
//                                 ? null
//                                 : () async {
//                                     final prefs =
//                                         await SharedPreferences.getInstance();
//                                     final token =
//                                         prefs.getString('token') ?? '';
//                                     ctx.read<ReviewSubmitCubit>().submit(
//                                       targetId: targetId,
//                                       targetType: targetType,
//                                       rating: selectedRating,
//                                       comment: commentController.text,
//                                       token: token,
//                                       reviewId: existingReview?.id,
//                                     );
//                                   },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: const Color(0xff0861dd),
//                               padding: const EdgeInsets.symmetric(vertical: 14),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(12),
//                               ),
//                             ),
//                             child: isLoading
//                                 ? const SizedBox(
//                                     width: 20,
//                                     height: 20,
//                                     child: CircularProgressIndicator(
//                                       color: Colors.white,
//                                       strokeWidth: 2,
//                                     ),
//                                   )
//                                 : Text(
//                                     existingReview != null
//                                         ? 'Update Review'
//                                         : 'Submit Review',
//                                     style: const TextStyle(
//                                       color: Colors.white,
//                                       fontSize: 15,
//                                       fontFamily: 'Agency',
//                                     ),
//                                   ),
//                           ),
//                         );
//                       },
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   Widget _reviewButton(
//     BuildContext context, {
//     required String targetId,
//     required String targetType,
//     ReviewDetails? existingReview,
//   }) {
//     final isEdit = existingReview != null;
//     final isDark = _isDark(context);
//     final accent = isDark ? Colors.blue.shade200 : const Color(0xff0861dd);

//     return Padding(
//       padding: const EdgeInsets.only(bottom: 12),
//       child: SizedBox(
//         width: double.infinity,
//         child: OutlinedButton.icon(
//           onPressed: () => _showReviewSheet(
//             context,
//             targetId: targetId,
//             targetType: targetType,
//             existingReview: existingReview,
//           ),
//           icon: Icon(
//             isEdit ? Icons.edit_outlined : Icons.star_outline_rounded,
//             color: accent,
//           ),
//           label: Text(
//             isEdit ? 'Edit Review' : 'Add Review',
//             style: TextStyle(color: accent, fontFamily: 'Agency'),
//           ),
//           style: OutlinedButton.styleFrom(
//             padding: const EdgeInsets.symmetric(vertical: 14),
//             side: BorderSide(color: accent),
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(12),
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   void showAppToast(
//     BuildContext context,
//     String message, {
//     bool isError = false,
//   }) {
//     showToast(
//       message,
//       context: context,
//       duration: const Duration(seconds: 2),
//       position: StyledToastPosition.bottom,
//       backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
//       textStyle: const TextStyle(color: Colors.white, fontSize: 13),
//       borderRadius: BorderRadius.circular(12),
//       animation: StyledToastAnimation.fade,
//     );
//   }
// }

// lib/Pages/AppointmentDetails/appointment_details_page.dart
// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:healthcareapp_try1/API/user_service.dart';
import 'package:healthcareapp_try1/API/prepare_meeting_service.dart';
import 'package:healthcareapp_try1/Bloc/Appointment_details_/appointment_details_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_events.dart';
import 'package:healthcareapp_try1/Bloc/Prepare_Meeting/prepare_meeting_state.dart';
import 'package:healthcareapp_try1/Bloc/User_Bloc/ReviewBloc/review_submit.cubit.dart';
import 'package:healthcareapp_try1/Buttons/buttons.dart';
import 'package:healthcareapp_try1/Models/AppointmentDetails/review_details.dart';
import 'package:healthcareapp_try1/Widgets/custom_loader1.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class AppointmentDetailsPage extends StatelessWidget {
  const AppointmentDetailsPage({super.key});

  bool _isDark(BuildContext context) =>
      Theme.of(context).brightness == Brightness.dark;

  Color _pageBg(BuildContext context) =>
      _isDark(context) ? AppColors.bgDark : Colors.grey.shade50;

  Color _cardBg(BuildContext context) =>
      _isDark(context) ? AppColors.surfaceDark : Colors.white;

  Color _primaryText(BuildContext context) =>
      _isDark(context) ? AppColors.textDark : AppColors.textLight;

  Color _secondaryText(BuildContext context) => _isDark(context)
      ? AppColors.textDark.withOpacity(0.72)
      : Colors.grey.shade700;

  Color _borderColor(BuildContext context) =>
      _isDark(context) ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg(context),
      body: BlocBuilder<AppointmentDetailsCubit, AppointmentDetailsState>(
        builder: (context, state) {
          if (state is AppointmentDetailsLoading) {
            return _buildSkeleton(context);
          }
          if (state is AppointmentDetailsError) {
            return _buildError(state.message, context);
          }
          if (state is DoctorAppointmentLoaded) {
            return _buildDoctor(state.data, context);
          }
          if (state is NurseAppointmentLoaded) {
            return _buildNurse(state.data, context);
          }
          if (state is LabAppointmentLoaded) {
            return _buildLab(state.data, context);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildDoctor(DoctorAppointmentDetails d, BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: d.doctorName,
            subtitle: 'Doctor · ${d.appointmentType}',
            status: d.status,
            context: context,
            stats: [
              _statItem(context, 'Date', d.date),
              _statItem(
                context,
                'Time',
                '${d.startTime.substring(0, 5)} – ${d.endTime.substring(0, 5)}',
              ),
              _statItem(context, 'Fee', '${d.fee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard(context, 'Appointment info', [
                  if (d.address != null)
                    _rowItem(context, 'Address', d.address!),
                  _rowItem(context, 'Payment', d.paymentType),
                  if (d.notes != null) _rowItem(context, 'Notes', d.notes!),
                ]),
                if (d.diagnosis != null || d.prescriptions != null)
                  _sectionCard(
                    context,
                    'Diagnosis & prescription',
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (d.diagnosis != null) ...[
                          _subLabel(context, 'Diagnosis'),
                          _arabicBox(
                            context,
                            d.diagnosis!,
                            _isDark(context)
                                ? AppColors.bgDark.withOpacity(0.6)
                                : Colors.grey.shade50,
                          ),
                          const SizedBox(height: 12),
                        ],
                        if (d.prescriptions != null) ...[
                          _subLabel(context, 'Prescription'),
                          _arabicBox(
                            context,
                            d.prescriptions!,
                            _isDark(context)
                                ? Colors.blue.withOpacity(0.14)
                                : Colors.blue.shade50,
                            textColor: _isDark(context)
                                ? Colors.blue.shade100
                                : Colors.blue.shade800,
                          ),
                        ],
                      ],
                    ),
                  ),
                if (d.requiredTests.isNotEmpty)
                  _sectionCard(
                    context,
                    'Required tests',
                    Column(
                      children: d.requiredTests
                          .map((t) => _testRow(context, t.testName, t.status))
                          .toList(),
                    ),
                  ),
                if (d.review != null) _reviewCard(context, d.review!),
                _reviewButton(
                  context,
                  targetId: d.doctorId,
                  targetType: 'Doctor',
                  existingReview: d.review,
                ),
                const SizedBox(height: 5),

                // ─── Online Button ───────────────────────────────────────
                // قبل الـ BlocProvider للـ Join Now، حط الـ condition دي
                if (d.appointmentType == 'Online') ...[
                  const SizedBox(height: 5),
                  BlocProvider(
                    create: (_) =>
                        PrepareMeetingBloc(repository: AppointmentRepository()),
                    child: BlocConsumer<PrepareMeetingBloc, PrepareMeetingState>(
                      listener: (ctx, state) async {
                        if (state is PrepareMeetingSuccess) {
                          final uri = Uri.parse(state.data.meetingUrl);
                          if (await canLaunchUrl(uri)) {
                            await launchUrl(
                              uri,
                              mode: LaunchMode.externalApplication,
                            );
                          } else {
                            showAppToast(
                              context,
                              'Could not open meeting link',
                              isError: true,
                            );
                          }
                        }
                        if (state is PrepareMeetingFailure) {
                          showAppToast(context, state.error, isError: true);
                        }
                      },
                      builder: (ctx, state) {
                        final isLoading = state is PrepareMeetingLoading;
                        final canJoin = _canJoinMeeting(
                          d.date,
                          d.startTime,
                          d.endTime,
                        );

                        return Column(
                          children: [
                            ButtonOfAuth(
                              onPressed: (!canJoin || isLoading)
                                  ? null
                                  : () async {
                                      final prefs =
                                          await SharedPreferences.getInstance();
                                      final token =
                                          prefs.getString('token') ?? '';
                                      ctx.read<PrepareMeetingBloc>().add(
                                        PrepareMeetingRequested(
                                          appointmentId: d.id,
                                          token: token,
                                        ),
                                      );
                                    },
                              fontcolor: Colors.white,
                              buttoncolor: (!canJoin || isLoading)
                                  ? AppColors.primary.withOpacity(0.4)
                                  : AppColors.primary,
                              buttonText: isLoading
                                  ? "Connecting..."
                                  : "Join Now",
                            ),
                            if (!canJoin) ...[
                              const SizedBox(height: 6),
                              Text(
                                _joinAvailableText(
                                  d.date,
                                  d.startTime,
                                  d.endTime,
                                ),
                                style: TextStyle(
                                  fontSize: 11,
                                  color: _secondaryText(context),
                                  fontFamily: 'Agency',
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ],
                        );
                      },
                    ),
                  ),
                ],
                // ──────────────────────────────────────────────────────────
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNurse(NurseAppointmentDetails n, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: n.nurseName,
            subtitle: 'Nurse · ${n.serviceType}',
            status: n.status,
            context: context,
            stats: [
              _statItem(context, 'Date', n.date),
              _statItem(
                context,
                'Shift',
                '${n.shiftStartTime.substring(0, 5)} – ${n.shiftEndTime.substring(0, 5)}',
              ),
              _statItem(context, 'Fee', '${n.totalFee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard(context, 'Appointment info', [
                  _rowItem(context, 'Service', n.serviceType),
                  if (n.address != null)
                    _rowItem(context, 'Address', n.address!),
                  if (n.hours != null)
                    _rowItem(context, 'Hours', '${n.hours}h'),
                  if (n.notes != null) _rowItem(context, 'Notes', n.notes!),
                ]),
                if (n.review != null) _reviewCard(context, n.review!),
                _reviewButton(
                  context,
                  targetId: n.nurseId,
                  targetType: 'Nurse',
                  existingReview: n.review,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLab(LabAppointmentDetails l, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildBlueHeader(
            name: l.labName,
            subtitle: 'Lab · ${l.appointmentType}',
            status: l.status,
            context: context,
            stats: [
              _statItem(context, 'Date', l.date),
              _statItem(context, 'Fee', '${l.totalFee.toStringAsFixed(0)} EGP'),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                _infoCard(context, 'Appointment info', [
                  if (l.address != null)
                    _rowItem(context, 'Address', l.address!),
                  if (l.notes != null) _rowItem(context, 'Notes', l.notes!),
                ]),
                if (l.testResults.isNotEmpty)
                  _sectionCard(
                    context,
                    'Test results',
                    Column(
                      children: l.testResults
                          .map((r) => _labResultItem(context, r))
                          .toList(),
                    ),
                  ),
                if (l.review != null) _reviewCard(context, l.review!),
                _reviewButton(
                  context,
                  targetId: l.labId,
                  targetType: 'Lab',
                  existingReview: l.review,
                ),
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBlueHeader({
    required String name,
    required String subtitle,
    required String status,
    required BuildContext context,
    required List<Widget> stats,
  }) {
    final isDark = _isDark(context);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: isDark
              ? [AppColors.surfaceDark, AppColors.primaryDark]
              : const [Color(0xff0A74FF), Color(0xff0047CC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
      child: Column(
        children: [
          Row(
            children: [
              GradientAvatar(name: name, size: 52, fontSize: 22),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      textDirection: name.getDirection,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cotta',
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.82),
                        fontSize: 13,
                        fontFamily: 'Agency',
                      ),
                    ),
                  ],
                ),
              ),
              _statusBadge(context, status),
              const SizedBox(width: 4),
              IconButton(
                icon: const Icon(
                  Icons.arrow_back_ios_new,
                  color: Colors.white,
                  size: 18,
                ),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(children: stats.map((s) => Expanded(child: s)).toList()),
        ],
      ),
    );
  }

  Widget _statItem(BuildContext context, String label, String value) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(_isDark(context) ? 0.10 : 0.15),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white.withOpacity(_isDark(context) ? 0.08 : 0.0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.white.withOpacity(0.75),
            ),
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(BuildContext context, String title, List<Widget> rows) {
    return _sectionCard(context, title, Column(children: rows));
  }

  Widget _sectionCard(BuildContext context, String title, Widget child) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: _cardBg(context),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: _borderColor(context)),
        boxShadow: [
          BoxShadow(
            color: _isDark(context)
                ? Colors.black.withOpacity(0.16)
                : Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            title.toUpperCase(),
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: _secondaryText(context),
              letterSpacing: 0.6,
            ),
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }

  Widget _rowItem(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              label,
              style: TextStyle(fontSize: 13, color: _secondaryText(context)),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              textDirection: value.getDirection,
              textAlign: value.getTextAlign,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: _primaryText(context),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _testRow(BuildContext context, String name, String status) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 7),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Text(
              name,
              style: TextStyle(
                fontSize: 13,
                fontFamily: 'Agency',
                color: _primaryText(context),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _statusBadge(context, status),
        ],
      ),
    );
  }

  Widget _labResultItem(BuildContext context, LabTestResult r) {
    final isDark = _isDark(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: _borderColor(context)),
        borderRadius: BorderRadius.circular(10),
        color: isDark ? AppColors.bgDark.withOpacity(0.35) : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  r.testName,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: _primaryText(context),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                r.value.toStringAsFixed(2),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isDark
                      ? Colors.blue.shade200
                      : const Color(0xff0861dd),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            r.summary,
            style: TextStyle(
              fontSize: 12,
              color: _secondaryText(context),
              height: 1.4,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _statusBadge(context, r.status),
              if (r.resultFileUrl.isNotEmpty)
                GestureDetector(
                  onTap: () => launchUrl(
                    Uri.parse(r.resultFileUrl),
                    mode: LaunchMode.externalApplication,
                  ),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isDark
                            ? Colors.blue.withOpacity(0.28)
                            : Colors.blue.shade200,
                      ),
                      borderRadius: BorderRadius.circular(8),
                      color: isDark ? Colors.blue.withOpacity(0.08) : null,
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.download_outlined,
                          size: 14,
                          color: isDark
                              ? Colors.blue.shade200
                              : Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Download PDF',
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? Colors.blue.shade200
                                : Colors.blue.shade700,
                            fontFamily: 'Agency',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _reviewCard(BuildContext context, ReviewDetails r) {
    return _sectionCard(
      context,
      'Patient review',
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GradientAvatar(name: r.patientName, size: 36, fontSize: 14),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      r.patientName,
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: _primaryText(context),
                      ),
                    ),
                    Text(
                      '${r.date.day}/${r.date.month}/${r.date.year}${r.isUpdated ? ' · edited' : ''}',
                      style: TextStyle(
                        fontSize: 11,
                        color: _secondaryText(context),
                      ),
                    ),
                  ],
                ),
              ),
              Row(
                children: List.generate(
                  5,
                  (i) => Icon(
                    i < r.rating
                        ? Icons.star_rounded
                        : Icons.star_outline_rounded,
                    size: 16,
                    color: i < r.rating ? Colors.amber : Colors.grey.shade300,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _arabicBox(
            context,
            r.comment,
            _isDark(context)
                ? AppColors.bgDark.withOpacity(0.6)
                : Colors.grey.shade50,
          ),
        ],
      ),
    );
  }

  Widget _arabicBox(
    BuildContext context,
    String text,
    Color bg, {
    Color? textColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        text,
        textDirection: text.getDirection,
        textAlign: text.getTextAlign,
        style: TextStyle(
          fontSize: 13,
          height: 1.5,
          color: textColor ?? _primaryText(context),
        ),
      ),
    );
  }

  Widget _subLabel(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(bottom: 4),
    child: Text(
      text,
      style: TextStyle(fontSize: 11, color: _secondaryText(context)),
    ),
  );

  Widget _statusBadge(BuildContext context, String status) {
    final isDark = _isDark(context);

    Color bg;
    Color fg;
    switch (status) {
      case 'Completed':
      case 'ResultsDone':
        bg = isDark ? Colors.green.withOpacity(0.14) : Colors.green.shade50;
        fg = isDark ? Colors.green.shade200 : Colors.green.shade800;
        break;
      case 'Pending':
        bg = isDark ? Colors.orange.withOpacity(0.14) : Colors.orange.shade50;
        fg = isDark ? Colors.orange.shade200 : Colors.orange.shade800;
        break;
      case 'Confirmed':
        bg = isDark ? Colors.blue.withOpacity(0.14) : Colors.blue.shade50;
        fg = isDark ? Colors.blue.shade200 : Colors.blue.shade800;
        break;
      case 'Cancelled':
        bg = isDark ? Colors.red.withOpacity(0.14) : Colors.red.shade50;
        fg = isDark ? Colors.red.shade200 : Colors.red.shade800;
        break;
      default:
        bg = isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100;
        fg = isDark ? AppColors.textLight : Colors.grey.shade700;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.circle, size: 6, color: fg),
          const SizedBox(width: 5),
          Text(
            status,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: fg,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSkeleton(BuildContext context) => Center(
    child: CustomSpinner(
      size: 40,
      color: _isDark(context) ? AppColors.textLight : const Color(0xff0861dd),
    ),
  );

  Widget _buildError(String msg, BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.error_outline, color: Colors.red.shade300, size: 48),
        const SizedBox(height: 12),
        Text(
          msg,
          style: TextStyle(
            color: _isDark(context) ? Colors.red.shade300 : Colors.red.shade700,
          ),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Go back'),
        ),
      ],
    ),
  );

  void _showReviewSheet(
    BuildContext context, {
    required String targetId,
    required String targetType,
    ReviewDetails? existingReview,
  }) {
    final isDark = _isDark(context);
    int selectedRating = existingReview?.rating ?? 0;
    final commentController = TextEditingController(
      text: existingReview?.comment ?? '',
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => BlocProvider(
        create: (_) => ReviewSubmitCubit(UserService()),
        child: StatefulBuilder(
          builder: (ctx, setSheetState) {
            final sheetDark = _isDark(ctx);

            return BlocListener<ReviewSubmitCubit, ReviewSubmitState>(
              listener: (ctx, state) {
                if (state is ReviewSubmitSuccess) {
                  context.read<AppointmentDetailsCubit>().refresh().then((_) {
                    Navigator.pop(ctx);
                    showToast(
                      existingReview != null
                          ? 'تم تعديل التقييم بنجاح'
                          : 'تم إرسال التقييم بنجاح',
                    );
                  });
                }
                if (state is ReviewSubmitError) {
                  showToast(state.message);
                }
              },
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  20,
                  16,
                  MediaQuery.of(ctx).viewInsets.bottom + 20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Center(
                      child: Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: sheetDark
                              ? Colors.white24
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      existingReview != null
                          ? 'Edit your review'
                          : 'Add your review',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Cotta',
                        color: _primaryText(ctx),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          5,
                          (i) => GestureDetector(
                            onTap: () =>
                                setSheetState(() => selectedRating = i + 1),
                            child: Icon(
                              i < selectedRating
                                  ? Icons.star_rounded
                                  : Icons.star_outline_rounded,
                              size: 40,
                              color: i < selectedRating
                                  ? Colors.amber
                                  : (sheetDark
                                        ? Colors.white24
                                        : Colors.grey.shade300),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: commentController,
                      maxLines: 3,
                      textDirection: TextDirection.rtl,
                      style: TextStyle(color: _primaryText(ctx)),
                      decoration: InputDecoration(
                        hintText: 'اكتب تعليقك هنا...',
                        hintTextDirection: TextDirection.rtl,
                        hintStyle: TextStyle(color: _secondaryText(ctx)),
                        filled: true,
                        fillColor: sheetDark
                            ? AppColors.bgDark.withOpacity(0.7)
                            : Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _borderColor(ctx)),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: _borderColor(ctx)),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(
                            color: Color(0xff0861dd),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    BlocBuilder<ReviewSubmitCubit, ReviewSubmitState>(
                      builder: (ctx, state) {
                        final isLoading = state is ReviewSubmitLoading;
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: selectedRating == 0 || isLoading
                                ? null
                                : () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    final token =
                                        prefs.getString('token') ?? '';
                                    ctx.read<ReviewSubmitCubit>().submit(
                                      targetId: targetId,
                                      targetType: targetType,
                                      rating: selectedRating,
                                      comment: commentController.text,
                                      token: token,
                                      reviewId: existingReview?.id,
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff0861dd),
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: isLoading
                                ? const SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: Colors.white,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    existingReview != null
                                        ? 'Update Review'
                                        : 'Submit Review',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 15,
                                      fontFamily: 'Agency',
                                    ),
                                  ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _reviewButton(
    BuildContext context, {
    required String targetId,
    required String targetType,
    ReviewDetails? existingReview,
  }) {
    final isEdit = existingReview != null;
    final isDark = _isDark(context);
    final accent = isDark ? Colors.blue.shade200 : const Color(0xff0861dd);

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _showReviewSheet(
            context,
            targetId: targetId,
            targetType: targetType,
            existingReview: existingReview,
          ),
          icon: Icon(
            isEdit ? Icons.edit_outlined : Icons.star_outline_rounded,
            color: accent,
          ),
          label: Text(
            isEdit ? 'Edit Review' : 'Add Review',
            style: TextStyle(color: accent, fontFamily: 'Agency'),
          ),
          style: OutlinedButton.styleFrom(
            padding: const EdgeInsets.symmetric(vertical: 14),
            side: BorderSide(color: accent),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
    );
  }

  void showAppToast(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    showToast(
      message,
      context: context,
      duration: const Duration(seconds: 2),
      position: StyledToastPosition.bottom,
      backgroundColor: isError ? Colors.red.shade600 : Colors.green.shade600,
      textStyle: const TextStyle(color: Colors.white, fontSize: 13),
      borderRadius: BorderRadius.circular(12),
      animation: StyledToastAnimation.fade,
    );
  }

  bool _canJoinMeeting(String date, String startTime, String endTime) {
    try {
      final now = DateTime.now();

      // date زي "2025-06-15", startTime زي "14:30:00"
      final dateParts = date.split('-');
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      final startDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      final openFrom = startDateTime.subtract(const Duration(minutes: 15));
      return now.isAfter(openFrom) && now.isBefore(endDateTime);
    } catch (_) {
      return false;
    }
  }

  String _joinAvailableText(String date, String startTime, String endTime) {
    try {
      final now = DateTime.now();
      final dateParts = date.split('-');
      final startParts = startTime.split(':');
      final endParts = endTime.split(':');

      final startDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(startParts[0]),
        int.parse(startParts[1]),
      );

      final endDateTime = DateTime(
        int.parse(dateParts[0]),
        int.parse(dateParts[1]),
        int.parse(dateParts[2]),
        int.parse(endParts[0]),
        int.parse(endParts[1]),
      );

      final openFrom = startDateTime.subtract(const Duration(minutes: 15));

      if (now.isAfter(endDateTime)) return 'Meeting has ended';

      final diff = openFrom.difference(now);
      if (diff.inDays > 0) {
        return 'Available in ${diff.inDays}d ${diff.inHours % 24}h';
      }
      if (diff.inHours > 0) {
        return 'Available in ${diff.inHours}h ${diff.inMinutes % 60}m';
      }
      return 'Available in ${diff.inMinutes}m';
    } catch (_) {
      return '';
    }
  }
}
