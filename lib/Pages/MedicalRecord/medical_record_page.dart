// // lib/Pages/MedicalRecord/medical_record_page.dart

// // ignore_for_file: deprecated_member_use, use_build_context_synchronously

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
// import 'package:healthcareapp_try1/Models/DetailsModel.dart/medical_record_model.dart';
// import 'package:healthcareapp_try1/core/gradient_avatar.dart';
// import 'package:skeletonizer/skeletonizer.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:healthcareapp_try1/core/string_extension.dart';

// class MedicalRecordPage extends StatefulWidget {
//   const MedicalRecordPage({super.key});

//   @override
//   State<MedicalRecordPage> createState() => _MedicalRecordPageState();
// }

// class _MedicalRecordPageState extends State<MedicalRecordPage> {
//   @override
//   void initState() {
//     super.initState();
//     context.read<MedicalRecordCubit>().fetchMedicalRecord(); // ✅
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.grey.shade50,
//       body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
//         builder: (context, state) {
//           if (state is MedicalRecordLoading) return _buildSkeleton();
//           if (state is MedicalRecordError) {
//             return _buildError(state.message, context);
//           }
//           if (state is MedicalRecordLoaded) {
//             return _buildContent(state.data, context);
//           }
//           return const SizedBox();
//         },
//       ),
//     );
//   }

//   // ─── Header ───
//   Widget _buildHeader(MedicalRecordModel r, BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         borderRadius: BorderRadius.only(
//           bottomLeft: Radius.circular(20),
//           bottomRight: Radius.circular(20),
//         ),
//         color: const Color(0xff0861dd),
//       ),
//       padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
//       child: Row(
//         children: [
//           GradientAvatar(name: r.name),
//           const SizedBox(width: 14),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   r.name,
//                   textDirection: r.name.getDirection,
//                   style: const TextStyle(
//                     color: Colors.white,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     fontFamily: 'Cotta',
//                   ),
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   '${r.gender} · ${r.weight.toStringAsFixed(0)} kg',
//                   style: TextStyle(
//                     color: Colors.white.withOpacity(0.8),
//                     fontSize: 13,
//                     fontFamily: 'Agency',
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           IconButton(
//             icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Content ───
//   Widget _buildContent(MedicalRecordModel r, BuildContext context) {
//     return SingleChildScrollView(
//       child: Column(
//         children: [
//           _buildHeader(r, context),
//           Padding(
//             padding: const EdgeInsets.all(16),
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 // Stats
//                 Row(
//                   children: [
//                     _statBox(
//                       'Weight',
//                       '${r.weight.toStringAsFixed(0)} kg',
//                       Colors.blue.shade50,
//                       Colors.blue.shade800,
//                     ),
//                     const SizedBox(width: 10),
//                     _statBox(
//                       'Diagnoses',
//                       '${r.diagnoses.length}',
//                       Colors.teal.shade50,
//                       Colors.teal.shade800,
//                     ),
//                     const SizedBox(width: 10),
//                     _statBox(
//                       'Required tests',
//                       '${r.pendingRequiredTests.length}',
//                       Colors.orange.shade50,
//                       Colors.orange.shade800,
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 16),

//                 // Medical Conditions
//                 _sectionTitle('Medical conditions'),
//                 const SizedBox(height: 10),
//                 _buildConditionsCard(r.medicalConditions),
//                 const SizedBox(height: 16),

//                 // Diagnoses
//                 _sectionTitle('Diagnoses'),
//                 const SizedBox(height: 10),
//                 ...r.diagnoses.map((d) => _buildDiagnosisCard(d)),
//                 const SizedBox(height: 16),

//                 // Lab Results
//                 _sectionTitle('Lab results'),
//                 const SizedBox(height: 10),
//                 ...r.labResults.map((l) => _buildLabResultCard(l)),
//                 const SizedBox(height: 16),

//                 // Pending Tests
//                 if (r.pendingRequiredTests.isNotEmpty) ...[
//                   _sectionTitle('Required tests'),
//                   const SizedBox(height: 10),
//                   _buildPendingTests(r.pendingRequiredTests),
//                 ],
//                 const SizedBox(height: 30),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Stat Box ───
//   Widget _statBox(String label, String value, Color bg, Color textColor) {
//     return Expanded(
//       child: Container(
//         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
//         decoration: BoxDecoration(
//           color: bg,
//           borderRadius: BorderRadius.circular(12),
//         ),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               label,
//               style: TextStyle(
//                 fontSize: 11,
//                 color: textColor.withOpacity(0.7),
//                 fontFamily: 'Agency',
//               ),
//             ),
//             const SizedBox(height: 4),
//             Text(
//               value,
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: textColor,
//                 fontFamily: 'Cotta',
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildConditionsCard(MedicalConditions c) {
//     final conditions = [
//       {'label': 'Diabetes', 'value': c.hasDiabetes},
//       {'label': 'Blood pressure', 'value': c.hasBloodPressure},
//       {'label': 'Asthma', 'value': c.hasAsthma},
//       {'label': 'Heart disease', 'value': c.hasHeartDisease},
//       {'label': 'Kidney disease', 'value': c.hasKidneyDisease},
//       {'label': 'Arthritis', 'value': c.hasArthritis},
//       {'label': 'Cancer', 'value': c.hasCancer},
//       {'label': 'High cholesterol', 'value': c.hasHighCholesterol},
//     ];

//     // ✅ فلتر الـ true فقط
//     final activeConditions = conditions
//         .where((e) => e['value'] == true)
//         .toList();
//     final hasOther = c.otherMedicalConditions != null;

//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           // ✅ لو مفيش حاجة خالص
//           if (activeConditions.isEmpty && !hasOther)
//             Row(
//               children: [
//                 Icon(
//                   Icons.check_circle_outline,
//                   size: 18,
//                   color: Colors.green.shade600,
//                 ),
//                 const SizedBox(width: 8),
//                 Text(
//                   'No medical conditions recorded',
//                   style: TextStyle(
//                     fontSize: 13,
//                     color: Colors.green.shade700,
//                     fontFamily: 'Agency',
//                   ),
//                 ),
//               ],
//             )
//           else
//             Wrap(
//               spacing: 8,
//               runSpacing: 8,
//               children: activeConditions.map((e) {
//                 return Container(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 12,
//                     vertical: 7,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.red.shade50,
//                     borderRadius: BorderRadius.circular(8),
//                     border: Border.all(color: Colors.red.shade200),
//                   ),
//                   child: Row(
//                     mainAxisSize: MainAxisSize.min,
//                     children: [
//                       Icon(Icons.circle, size: 10, color: Colors.red.shade700),
//                       const SizedBox(width: 6),
//                       Text(
//                         e['label'] as String,
//                         style: TextStyle(
//                           fontSize: 12,
//                           fontFamily: 'Agency',
//                           color: Colors.red.shade800,
//                         ),
//                       ),
//                     ],
//                   ),
//                 );
//               }).toList(),
//             ),

//           if (hasOther) ...[
//             const SizedBox(height: 10),
//             Container(
//               width: double.infinity,
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.grey.shade50,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Text(
//                 c.otherMedicalConditions!,
//                 style: const TextStyle(
//                   fontSize: 13,
//                   fontFamily: 'Agency',
//                   color: Color(0xff0861dd),
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   Widget _buildSkeleton() {
//     return Skeletonizer(
//       enabled: true,
//       effect: const ShimmerEffect(
//         baseColor: Color(0xFFE0E0E0),
//         highlightColor: Color(0xFFF5F5F5),
//       ),
//       child: SingleChildScrollView(
//         physics: const NeverScrollableScrollPhysics(),
//         child: Column(
//           children: [
//             // Header Skeleton
//             Container(
//               color: const Color(0xff0861dd),
//               padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
//               child: Row(
//                 children: [
//                   const CircleAvatar(radius: 28, backgroundColor: Colors.white),
//                   const SizedBox(width: 14),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Container(width: 140, height: 18, color: Colors.white),
//                         const SizedBox(height: 6),
//                         Container(width: 90, height: 13, color: Colors.white),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),

//             Padding(
//               padding: const EdgeInsets.all(16),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Stats
//                   Row(
//                     children: List.generate(
//                       3,
//                       (i) => Expanded(
//                         child: Container(
//                           margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
//                           height: 70,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Conditions Section
//                   Container(
//                     width: 160,
//                     height: 16,
//                     color: Colors.grey.shade300,
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Wrap(
//                       spacing: 8,
//                       runSpacing: 8,
//                       children: List.generate(
//                         4,
//                         (_) => Container(
//                           width: 100,
//                           height: 32,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade200,
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Diagnoses Section
//                   Container(
//                     width: 120,
//                     height: 16,
//                     color: Colors.grey.shade300,
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 130,
//                               height: 15,
//                               color: Colors.grey.shade300,
//                             ),
//                             Container(
//                               width: 70,
//                               height: 24,
//                               decoration: BoxDecoration(
//                                 color: Colors.grey.shade200,
//                                 borderRadius: BorderRadius.circular(6),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           width: 80,
//                           height: 12,
//                           color: Colors.grey.shade200,
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           width: double.infinity,
//                           height: 12,
//                           color: Colors.grey.shade200,
//                         ),
//                         const SizedBox(height: 6),
//                         Container(
//                           width: 200,
//                           height: 12,
//                           color: Colors.grey.shade200,
//                         ),
//                         const SizedBox(height: 12),
//                         Container(
//                           width: double.infinity,
//                           height: 44,
//                           decoration: BoxDecoration(
//                             color: Colors.grey.shade100,
//                             borderRadius: BorderRadius.circular(10),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 20),

//                   // Lab Results Section
//                   Container(
//                     width: 110,
//                     height: 16,
//                     color: Colors.grey.shade300,
//                   ),
//                   const SizedBox(height: 10),
//                   Container(
//                     padding: const EdgeInsets.all(16),
//                     decoration: BoxDecoration(
//                       color: Colors.white,
//                       borderRadius: BorderRadius.circular(16),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 100,
//                               height: 15,
//                               color: Colors.grey.shade300,
//                             ),
//                             Container(
//                               width: 80,
//                               height: 12,
//                               color: Colors.grey.shade200,
//                             ),
//                           ],
//                         ),
//                         const Divider(height: 20),
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Container(
//                               width: 150,
//                               height: 13,
//                               color: Colors.grey.shade300,
//                             ),
//                             Container(
//                               width: 40,
//                               height: 18,
//                               color: Colors.grey.shade200,
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 8),
//                         Container(
//                           width: double.infinity,
//                           height: 12,
//                           color: Colors.grey.shade200,
//                         ),
//                         const SizedBox(height: 6),
//                         Container(
//                           width: 180,
//                           height: 12,
//                           color: Colors.grey.shade200,
//                         ),
//                         const SizedBox(height: 10),
//                         Container(
//                           width: 160,
//                           height: 34,
//                           decoration: BoxDecoration(
//                             border: Border.all(color: Colors.grey.shade300),
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   // ─── Diagnosis Card ───
//   Widget _buildDiagnosisCard(DiagnosisModel d) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Text(
//                     d.doctorName,
//                     textDirection: d.doctorName.getDirection,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       fontFamily: 'Cotta',
//                     ),
//                   ),
//                 ),
//               ),
//               _serviceTag(d.appointmentType),
//             ],
//           ),
//           const SizedBox(height: 4),
//           Text(
//             d.appointmentDate,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade500,
//               fontFamily: 'Agency',
//             ),
//           ),
//           const SizedBox(height: 12),
//           Text(
//             'Diagnosis',
//             style: TextStyle(
//               fontSize: 11,
//               color: Colors.grey.shade500,
//               fontFamily: 'Agency',
//             ),
//           ),
//           const SizedBox(height: 4),
//           Text(
//             d.diagnosis,
//             textDirection: d.diagnosis.getDirection,
//             textAlign: d.diagnosis.getTextAlign,
//             style: const TextStyle(fontSize: 14, height: 1.5),
//           ),
//           const SizedBox(height: 12),

//           // Prescription
//           Container(
//             width: double.infinity,
//             padding: const EdgeInsets.all(12),
//             decoration: BoxDecoration(
//               color: Colors.blue.shade50,
//               borderRadius: BorderRadius.circular(10),
//               border: Border.all(color: Colors.blue.shade100),
//             ),
//             child: Row(
//               children: [
//                 Icon(
//                   Icons.medication_outlined,
//                   size: 16,
//                   color: Colors.blue.shade700,
//                 ),
//                 const SizedBox(width: 8),
//                 Expanded(
//                   child: Text(
//                     d.prescription,
//                     textDirection: d.prescription.getDirection,
//                     textAlign: d.prescription.getTextAlign,
//                     style: TextStyle(
//                       fontSize: 13,
//                       color: Colors.blue.shade800,
//                       fontFamily: 'Agency',
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           if (d.requiredTests.isNotEmpty) ...[
//             const SizedBox(height: 12),
//             Text(
//               'Required tests',
//               style: TextStyle(
//                 fontSize: 11,
//                 color: Colors.grey.shade500,
//                 fontFamily: 'Agency',
//               ),
//             ),
//             const SizedBox(height: 6),
//             ...d.requiredTests.map(
//               (t) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Text(
//                       t.testName,
//                       style: const TextStyle(
//                         fontSize: 13,
//                         fontFamily: 'Agency',
//                       ),
//                     ),
//                     _statusBadge(t.status),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ],
//       ),
//     );
//   }

//   // ─── Lab Result Card ───
//   Widget _buildLabResultCard(LabResultModel lab) {
//     return Container(
//       margin: const EdgeInsets.only(bottom: 12),
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Row(
//             children: [
//               Expanded(
//                 child: Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 10),
//                   child: Text(
//                     lab.labName,
//                     textDirection: lab.labName.getDirection,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 15,
//                       fontFamily: 'Cotta',
//                     ),
//                   ),
//                 ),
//               ),
//               _serviceTag(lab.appointmentType),
//             ],
//           ),
//           Text(
//             lab.appointmentDate,
//             style: TextStyle(
//               fontSize: 12,
//               color: Colors.grey.shade500,
//               fontFamily: 'Agency',
//             ),
//           ),
//           const Divider(height: 20),
//           ...lab.results.map(
//             (r) => Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Expanded(
//                       child: Text(
//                         r.testName,
//                         style: const TextStyle(
//                           fontSize: 13,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ),
//                     Text(
//                       r.value.toStringAsFixed(2),
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontWeight: FontWeight.bold,
//                         color: Color(0xff0861dd),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: 4),
//                 Text(
//                   r.summary,
//                   textDirection: r.summary.getDirection,
//                   textAlign: r.summary.getTextAlign,
//                   style: TextStyle(
//                     fontSize: 12,
//                     color: Colors.grey.shade600,
//                     height: 1.4,
//                   ),
//                 ),
//                 const SizedBox(height: 8),
//                 if (r.resultFileUrl.isNotEmpty)
//                   GestureDetector(
//                     onTap: () async {
//                       final String rawUrl = r.resultFileUrl
//                           .trim(); // تنظيف الرابط من أي مسافات
//                       if (rawUrl.isEmpty) return;

//                       final Uri url = Uri.parse(rawUrl);

//                       try {
//                         // جرب الفتح مباشرة بدون canLaunchUrl للتأكد
//                         // لأن canLaunchUrl أحياناً تعطي false كاذبة إذا كانت الصلاحيات ناقصة
//                         await launchUrl(
//                           url,
//                           mode: LaunchMode.externalApplication,
//                         );
//                       } catch (e) {
//                         debugPrint('Error launching URL: $e');
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           SnackBar(content: Text('Could not open file: $e')),
//                         );
//                       }
//                     },

//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 12,
//                         vertical: 8,
//                       ),
//                       decoration: BoxDecoration(
//                         border: Border.all(color: Colors.blue.shade200),
//                         borderRadius: BorderRadius.circular(8),
//                       ),
//                       child: Row(
//                         mainAxisSize: MainAxisSize.min,
//                         children: [
//                           Icon(
//                             Icons.download_outlined,
//                             size: 16,
//                             color: Colors.blue.shade700,
//                           ),
//                           const SizedBox(width: 6),
//                           Text(
//                             'Download result PDF',
//                             style: TextStyle(
//                               fontSize: 13,
//                               color: Colors.blue.shade700,
//                               fontFamily: 'Agency',
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 const SizedBox(height: 4),
//                 _statusBadge(r.status),
//                 const SizedBox(height: 8),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   // ─── Pending Tests ───
//   // Widget _buildPendingTests(List<RequiredTest> tests) {
//   //   return Container(
//   //     padding: const EdgeInsets.all(16),
//   //     decoration: _cardDecoration(),
//   //     child: Column(
//   //       children: tests
//   //           .map(
//   //             (t) => Padding(
//   //               padding: const EdgeInsets.symmetric(vertical: 5),
//   //               child: Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   Row(
//   //                     children: [
//   //                       Container(
//   //                         width: 8,
//   //                         height: 8,
//   //                         decoration: const BoxDecoration(
//   //                           color: Colors.orange,
//   //                           shape: BoxShape.circle,
//   //                         ),
//   //                       ),
//   //                       const SizedBox(width: 10),
//   //                       Text(
//   //                         t.testName,
//   //                         style: const TextStyle(
//   //                           fontSize: 13,
//   //                           fontFamily: 'Agency',
//   //                         ),
//   //                       ),
//   //                     ],
//   //                   ),

//   //                   IconButton(
//   //                     onPressed: () {},
//   //                     icon: Icon(
//   //                       Icons.search_sharp,
//   //                       size: 35,
//   //                       color: Colors.deepOrange,
//   //                     ),
//   //                   ),
//   //                 ],
//   //               ),
//   //             ),
//   //           )
//   //           .toList(),
//   //     ),
//   //   );
//   // }

//   Widget _buildPendingTests(List<RequiredTest> tests) {
//     return Container(
//       padding: const EdgeInsets.all(16),
//       decoration: _cardDecoration(),
//       child: Column(
//         children: tests
//             .map(
//               (t) => Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 5),
//                 child: Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     Row(
//                       children: [
//                         Container(
//                           width: 8,
//                           height: 8,
//                           decoration: const BoxDecoration(
//                             color: Colors.orange,
//                             shape: BoxShape.circle,
//                           ),
//                         ),
//                         const SizedBox(width: 10),
//                         Text(
//                           t.testName,
//                           style: const TextStyle(
//                             fontSize: 13,
//                             fontFamily: 'Agency',
//                           ),
//                         ),
//                       ],
//                     ),

//                     // ✅ زرار السيرش
//                     GestureDetector(
//                       onTap: () {
//                         Navigator.pop(context); // تقفل Medical Record
//                         Navigator.pop(context);
//                         context.read<NavigationBloc>().add(
//                           TabChanged(1, initialTestIds: [t.testId]),
//                         );
//                       },
//                       child: Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 10,
//                           vertical: 6,
//                         ),
//                         decoration: BoxDecoration(
//                           color: Colors.deepOrange.shade50,
//                           borderRadius: BorderRadius.circular(8),
//                           border: Border.all(color: Colors.deepOrange.shade200),
//                         ),
//                         child: Row(
//                           children: [
//                             Icon(
//                               Icons.search,
//                               size: 16,
//                               color: Colors.deepOrange.shade700,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               'Find lab',
//                               style: TextStyle(
//                                 fontSize: 12,
//                                 color: Colors.deepOrange.shade700,
//                                 fontFamily: 'Agency',
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             )
//             .toList(),
//       ),
//     );
//   }

//   // ─── Helpers ───
//   Widget _sectionTitle(String title) => Text(
//     title,
//     style: const TextStyle(
//       fontSize: 16,
//       fontWeight: FontWeight.bold,
//       fontFamily: 'Cotta',
//     ),
//   );

//   Widget _serviceTag(String type) => Container(
//     padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//     decoration: BoxDecoration(
//       color: Colors.blue.shade50,
//       borderRadius: BorderRadius.circular(6),
//     ),
//     child: Text(
//       type,
//       style: TextStyle(
//         fontSize: 11,
//         color: Colors.blue.shade800,
//         fontFamily: 'Agency',
//       ),
//     ),
//   );

//   Widget _statusBadge(String status) {
//     final isCompleted = status == 'Completed';
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
//       decoration: BoxDecoration(
//         color: isCompleted ? Colors.green.shade50 : Colors.orange.shade50,
//         borderRadius: BorderRadius.circular(6),
//       ),
//       child: Text(
//         status,
//         style: TextStyle(
//           fontSize: 11,
//           fontFamily: 'Agency',
//           color: isCompleted ? Colors.green.shade800 : Colors.orange.shade800,
//         ),
//       ),
//     );
//   }

//   BoxDecoration _cardDecoration() => BoxDecoration(
//     color: Colors.white,
//     borderRadius: BorderRadius.circular(16),
//     border: Border.all(color: Colors.grey.shade100),
//     boxShadow: [
//       BoxShadow(
//         color: Colors.black.withOpacity(0.03),
//         blurRadius: 8,
//         offset: const Offset(0, 2),
//       ),
//     ],
//   );

//   Widget _buildError(String msg, BuildContext context) => Center(
//     child: Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       children: [
//         Text(msg, style: const TextStyle(color: Colors.red)),
//         const SizedBox(height: 12),
//         ElevatedButton(
//           onPressed: () =>
//               context.read<MedicalRecordCubit>().fetchMedicalRecord(),
//           child: const Text('Try again'),
//         ),
//       ],
//     ),
//   );
// }

// lib/Pages/MedicalRecord/medical_record_page.dart

// ignore_for_file: deprecated_member_use, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/MedicalRecordBloc/medical_record_cubit.dart';
import 'package:healthcareapp_try1/Bloc/NavigationBloc/navigation_bloc.dart';
import 'package:healthcareapp_try1/Models/DetailsModel.dart/medical_record_model.dart';
import 'package:healthcareapp_try1/core/gradient_avatar.dart';
import 'package:healthcareapp_try1/core/string_extension.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:url_launcher/url_launcher.dart';

class MedicalRecordPage extends StatefulWidget {
  const MedicalRecordPage({super.key});

  @override
  State<MedicalRecordPage> createState() => _MedicalRecordPageState();
}

class _MedicalRecordPageState extends State<MedicalRecordPage> {
  @override
  void initState() {
    super.initState();
    context.read<MedicalRecordCubit>().fetchMedicalRecord();
  }

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  Color get _pageBg => _isDark ? AppColors.bgDark : Colors.grey.shade50;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.grey.shade800;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.72) : Colors.grey.shade600;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      body: BlocBuilder<MedicalRecordCubit, MedicalRecordState>(
        builder: (context, state) {
          if (state is MedicalRecordLoading) return _buildSkeleton();
          if (state is MedicalRecordError) {
            return _buildError(state.message, context);
          }
          if (state is MedicalRecordLoaded) {
            return _buildContent(state.data, context);
          }
          return const SizedBox();
        },
      ),
    );
  }

  Widget _buildHeader(MedicalRecordModel r, BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
        color: _isDark ? AppColors.primaryDark : AppColors.primary,
      ),
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
      child: Row(
        children: [
          GradientAvatar(name: r.name),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  r.name,
                  textDirection: r.name.getDirection,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Cotta',
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${r.gender} · ${r.weight.toStringAsFixed(0)} kg',
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.82),
                    fontSize: 13,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  Widget _buildContent(MedicalRecordModel r, BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _buildHeader(r, context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _statBox(
                      'Weight',
                      '${r.weight.toStringAsFixed(0)} kg',
                      _isDark
                          ? Colors.blue.withOpacity(0.16)
                          : Colors.blue.shade50,
                      _isDark ? Colors.blue.shade200 : Colors.blue.shade800,
                    ),
                    const SizedBox(width: 10),
                    _statBox(
                      'Diagnoses',
                      '${r.diagnoses.length}',
                      _isDark
                          ? Colors.teal.withOpacity(0.16)
                          : Colors.teal.shade50,
                      _isDark ? Colors.teal.shade200 : Colors.teal.shade800,
                    ),
                    const SizedBox(width: 10),
                    _statBox(
                      'Required tests',
                      '${r.pendingRequiredTests.length}',
                      _isDark
                          ? Colors.orange.withOpacity(0.16)
                          : Colors.orange.shade50,
                      _isDark ? Colors.orange.shade200 : Colors.orange.shade800,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                _sectionTitle('Medical conditions'),
                const SizedBox(height: 10),
                _buildConditionsCard(r.medicalConditions),
                const SizedBox(height: 16),
                _sectionTitle('Diagnoses'),
                const SizedBox(height: 10),
                ...r.diagnoses.map((d) => _buildDiagnosisCard(d)),
                const SizedBox(height: 16),
                _sectionTitle('Lab results'),
                const SizedBox(height: 10),
                ...r.labResults.map((l) => _buildLabResultCard(l)),
                const SizedBox(height: 16),
                if (r.pendingRequiredTests.isNotEmpty) ...[
                  _sectionTitle('Required tests'),
                  const SizedBox(height: 10),
                  _buildPendingTests(r.pendingRequiredTests),
                ],
                const SizedBox(height: 30),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value, Color bg, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 11,
                color: textColor.withOpacity(0.75),
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: textColor,
                fontFamily: 'Cotta',
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConditionsCard(MedicalConditions c) {
    final conditions = [
      {'label': 'Diabetes', 'value': c.hasDiabetes},
      {'label': 'Blood pressure', 'value': c.hasBloodPressure},
      {'label': 'Asthma', 'value': c.hasAsthma},
      {'label': 'Heart disease', 'value': c.hasHeartDisease},
      {'label': 'Kidney disease', 'value': c.hasKidneyDisease},
      {'label': 'Arthritis', 'value': c.hasArthritis},
      {'label': 'Cancer', 'value': c.hasCancer},
      {'label': 'High cholesterol', 'value': c.hasHighCholesterol},
    ];

    final activeConditions = conditions
        .where((e) => e['value'] == true)
        .toList();
    final hasOther =
        c.otherMedicalConditions != null &&
        c.otherMedicalConditions!.trim().isNotEmpty;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (activeConditions.isEmpty && !hasOther)
            Row(
              children: [
                Icon(
                  Icons.check_circle_outline,
                  size: 18,
                  color: Colors.green.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  'No medical conditions recorded',
                  style: TextStyle(
                    fontSize: 13,
                    color: _isDark
                        ? Colors.green.shade300
                        : Colors.green.shade700,
                    fontFamily: 'Agency',
                  ),
                ),
              ],
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: activeConditions.map((e) {
                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 7,
                  ),
                  decoration: BoxDecoration(
                    color: _isDark
                        ? Colors.red.withOpacity(0.14)
                        : Colors.red.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: _isDark
                          ? Colors.red.withOpacity(0.25)
                          : Colors.red.shade200,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.circle, size: 10, color: Colors.red.shade700),
                      const SizedBox(width: 6),
                      Text(
                        e['label'] as String,
                        style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: _isDark
                              ? Colors.red.shade200
                              : Colors.red.shade800,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          if (hasOther) ...[
            const SizedBox(height: 10),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: _isDark
                    ? AppColors.bgDark.withOpacity(0.65)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                c.otherMedicalConditions!,
                style: TextStyle(
                  fontSize: 13,
                  fontFamily: 'Agency',
                  color: _isDark
                      ? Colors.blue.shade200
                      : const Color(0xff0861dd),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSkeleton() {
    final skeletonBase = _isDark
        ? AppColors.surfaceDark
        : const Color(0xFFE0E0E0);
    final skeletonHighlight = _isDark
        ? AppColors.bgDark
        : const Color(0xFFF5F5F5);
    final skeletonBlock = _isDark
        ? AppColors.bgDark.withOpacity(0.85)
        : Colors.grey.shade200;
    final skeletonBlock2 = _isDark
        ? AppColors.bgDark.withOpacity(0.65)
        : Colors.grey.shade300;

    return Skeletonizer(
      enabled: true,
      effect: ShimmerEffect(
        baseColor: skeletonBase,
        highlightColor: skeletonHighlight,
      ),
      child: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          children: [
            Container(
              color: _isDark ? AppColors.surfaceDark : const Color(0xff0861dd),
              padding: const EdgeInsets.fromLTRB(16, 50, 16, 20),
              child: Row(
                children: [
                  CircleAvatar(radius: 28, backgroundColor: skeletonHighlight),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 140,
                          height: 18,
                          color: skeletonHighlight,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          width: 90,
                          height: 13,
                          color: skeletonHighlight,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: List.generate(
                      3,
                      (i) => Expanded(
                        child: Container(
                          margin: EdgeInsets.only(right: i < 2 ? 10 : 0),
                          height: 70,
                          decoration: BoxDecoration(
                            color: skeletonBlock,
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(width: 160, height: 16, color: skeletonBlock2),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: List.generate(
                        4,
                        (_) => Container(
                          width: 100,
                          height: 32,
                          decoration: BoxDecoration(
                            color: skeletonBlock,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(width: 120, height: 16, color: skeletonBlock2),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 130,
                              height: 15,
                              color: skeletonBlock2,
                            ),
                            Container(
                              width: 70,
                              height: 24,
                              decoration: BoxDecoration(
                                color: skeletonBlock,
                                borderRadius: BorderRadius.circular(6),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(width: 80, height: 12, color: skeletonBlock),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: skeletonBlock,
                        ),
                        const SizedBox(height: 6),
                        Container(width: 200, height: 12, color: skeletonBlock),
                        const SizedBox(height: 12),
                        Container(
                          width: double.infinity,
                          height: 44,
                          decoration: BoxDecoration(
                            color: _isDark
                                ? AppColors.bgDark.withOpacity(0.65)
                                : Colors.grey.shade100,
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(width: 110, height: 16, color: skeletonBlock2),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _cardBg,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 100,
                              height: 15,
                              color: skeletonBlock2,
                            ),
                            Container(
                              width: 80,
                              height: 12,
                              color: skeletonBlock,
                            ),
                          ],
                        ),
                        Divider(height: 20, color: _borderColor),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: 150,
                              height: 13,
                              color: skeletonBlock2,
                            ),
                            Container(
                              width: 40,
                              height: 18,
                              color: skeletonBlock,
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: double.infinity,
                          height: 12,
                          color: skeletonBlock,
                        ),
                        const SizedBox(height: 6),
                        Container(width: 180, height: 12, color: skeletonBlock),
                        const SizedBox(height: 10),
                        Container(
                          width: 160,
                          height: 34,
                          decoration: BoxDecoration(
                            border: Border.all(color: _borderColor),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiagnosisCard(DiagnosisModel d) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    d.doctorName,
                    textDirection: d.doctorName.getDirection,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Cotta',
                      color: _primaryText,
                    ),
                  ),
                ),
              ),
              _serviceTag(d.appointmentType),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            d.appointmentDate,
            style: TextStyle(
              fontSize: 12,
              color: _secondaryText,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Diagnosis',
            style: TextStyle(
              fontSize: 11,
              color: _secondaryText,
              fontFamily: 'Agency',
            ),
          ),
          const SizedBox(height: 4),
          Text(
            d.diagnosis,
            textDirection: d.diagnosis.getDirection,
            textAlign: d.diagnosis.getTextAlign,
            style: TextStyle(fontSize: 14, height: 1.5, color: _primaryText),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.blue.withOpacity(0.14)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isDark
                    ? Colors.blue.withOpacity(0.24)
                    : Colors.blue.shade100,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.medication_outlined,
                  size: 16,
                  color: _isDark ? Colors.blue.shade200 : Colors.blue.shade700,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    d.prescription,
                    textDirection: d.prescription.getDirection,
                    textAlign: d.prescription.getTextAlign,
                    style: TextStyle(
                      fontSize: 13,
                      color: _isDark
                          ? Colors.blue.shade100
                          : Colors.blue.shade800,
                      fontFamily: 'Agency',
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (d.requiredTests.isNotEmpty) ...[
            const SizedBox(height: 12),
            Text(
              'Required tests',
              style: TextStyle(
                fontSize: 11,
                color: _secondaryText,
                fontFamily: 'Agency',
              ),
            ),
            const SizedBox(height: 6),
            ...d.requiredTests.map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        t.testName,
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Agency',
                          color: _primaryText,
                        ),
                      ),
                    ),
                    _statusBadge(t.status),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLabResultCard(LabResultModel lab) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Text(
                    lab.labName,
                    textDirection: lab.labName.getDirection,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      fontFamily: 'Cotta',
                      color: _primaryText,
                    ),
                  ),
                ),
              ),
              _serviceTag(lab.appointmentType),
            ],
          ),
          Text(
            lab.appointmentDate,
            style: TextStyle(
              fontSize: 12,
              color: _secondaryText,
              fontFamily: 'Agency',
            ),
          ),
          Divider(height: 20, color: _borderColor),
          ...lab.results.map(
            (r) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        r.testName,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: _primaryText,
                        ),
                      ),
                    ),
                    Text(
                      r.value.toStringAsFixed(2),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _isDark
                            ? Colors.blue.shade200
                            : const Color(0xff0861dd),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  r.summary,
                  textDirection: r.summary.getDirection,
                  textAlign: r.summary.getTextAlign,
                  style: TextStyle(
                    fontSize: 12,
                    color: _secondaryText,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 8),
                if (r.resultFileUrl.isNotEmpty)
                  GestureDetector(
                    onTap: () async {
                      final rawUrl = r.resultFileUrl.trim();
                      if (rawUrl.isEmpty) return;

                      final url = Uri.parse(rawUrl);

                      try {
                        await launchUrl(
                          url,
                          mode: LaunchMode.externalApplication,
                        );
                      } catch (e) {
                        debugPrint('Error launching URL: $e');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Could not open file: $e')),
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _isDark
                              ? Colors.blue.withOpacity(0.3)
                              : Colors.blue.shade200,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        color: _isDark ? Colors.blue.withOpacity(0.08) : null,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.download_outlined,
                            size: 16,
                            color: _isDark
                                ? Colors.blue.shade200
                                : Colors.blue.shade700,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Download result PDF',
                            style: TextStyle(
                              fontSize: 13,
                              color: _isDark
                                  ? Colors.blue.shade200
                                  : Colors.blue.shade700,
                              fontFamily: 'Agency',
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                const SizedBox(height: 4),
                _statusBadge(r.status),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPendingTests(List<RequiredTest> tests) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: _cardDecoration(),
      child: Column(
        children: tests
            .map(
              (t) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              t.testName,
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Agency',
                                color: _primaryText,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.pop(context);
                        context.read<NavigationBloc>().add(
                          TabChanged(1, initialTestIds: [t.testId]),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: _isDark
                              ? Colors.deepOrange.withOpacity(0.14)
                              : Colors.deepOrange.shade50,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: _isDark
                                ? Colors.deepOrange.withOpacity(0.28)
                                : Colors.deepOrange.shade200,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.search,
                              size: 16,
                              color: _isDark
                                  ? Colors.deepOrange.shade200
                                  : Colors.deepOrange.shade700,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'Find lab',
                              style: TextStyle(
                                fontSize: 12,
                                color: _isDark
                                    ? Colors.deepOrange.shade200
                                    : Colors.deepOrange.shade700,
                                fontFamily: 'Agency',
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }

  Widget _sectionTitle(String title) => Text(
    title,
    style: TextStyle(
      fontSize: 16,
      fontWeight: FontWeight.bold,
      fontFamily: 'Cotta',
      color: _primaryText,
    ),
  );

  Widget _serviceTag(String type) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(
      color: _isDark ? Colors.blue.withOpacity(0.14) : Colors.blue.shade50,
      borderRadius: BorderRadius.circular(6),
    ),
    child: Text(
      type,
      style: TextStyle(
        fontSize: 11,
        color: _isDark ? Colors.blue.shade200 : Colors.blue.shade800,
        fontFamily: 'Agency',
      ),
    ),
  );

  Widget _statusBadge(String status) {
    final isCompleted = status == 'Completed';

    final bgColor = isCompleted
        ? (_isDark ? Colors.green.withOpacity(0.14) : Colors.green.shade50)
        : (_isDark ? Colors.orange.withOpacity(0.14) : Colors.orange.shade50);

    final textColor = isCompleted
        ? (_isDark ? Colors.green.shade200 : Colors.green.shade800)
        : (_isDark ? Colors.orange.shade200 : Colors.orange.shade800);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        status,
        style: TextStyle(fontSize: 11, fontFamily: 'Agency', color: textColor),
      ),
    );
  }

  BoxDecoration _cardDecoration() => BoxDecoration(
    color: _cardBg,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(color: _borderColor),
    boxShadow: [
      BoxShadow(
        color: _isDark
            ? Colors.black.withOpacity(0.18)
            : Colors.black.withOpacity(0.03),
        blurRadius: 8,
        offset: const Offset(0, 2),
      ),
    ],
  );

  Widget _buildError(String msg, BuildContext context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          msg,
          style: TextStyle(color: _isDark ? Colors.red.shade300 : Colors.red),
        ),
        const SizedBox(height: 12),
        ElevatedButton(
          onPressed: () =>
              context.read<MedicalRecordCubit>().fetchMedicalRecord(),
          child: const Text('Try again'),
        ),
      ],
    ),
  );
}
