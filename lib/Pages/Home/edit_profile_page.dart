// // ignore_for_file: use_build_context_synchronously, deprecated_member_use

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:healthcareapp_try1/API/auth_service.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
// import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';
// import 'package:healthcareapp_try1/Buttons/buttons.dart';
// import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
// import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
// import 'package:shared_preferences/shared_preferences.dart';

// class EditProfilePage extends StatefulWidget {
//   final PatientProfile profile;
//   const EditProfilePage({super.key, required this.profile});

//   @override
//   State<EditProfilePage> createState() => _EditProfilePageState();
// }

// class _EditProfilePageState extends State<EditProfilePage> {
//   final nameController = TextEditingController();
//   final phoneController = TextEditingController();
//   final addressController = TextEditingController();
//   final cityController = TextEditingController();
//   final weightController = TextEditingController();
//   final addressUrlController = TextEditingController();

//   String userId = "";
//   List<String> _cities = [];
//   String? _selectedCity;
//   bool _citiesError = false;

//   @override
//   void initState() {
//     super.initState();
//     nameController.text = widget.profile.name;
//     phoneController.text = widget.profile.phoneNumber;
//     addressController.text = widget.profile.address;
//     cityController.text = widget.profile.city;
//     weightController.text = widget.profile.weight?.toString() ?? "";
//     addressUrlController.text = widget.profile.addressUrl ?? "";
//     _selectedCity = widget.profile.city;
//     getUserId();
//     _loadCities();
//   }

//   Future<void> _loadCities() async {
//     try {
//       final cities = await AuthService().getCities();
//       if (mounted) {
//         setState(() {
//           _cities = cities;
//           if (!_cities.contains(_selectedCity)) {
//             _selectedCity = null;
//           }
//         });
//       }
//     } catch (e) {
//       if (mounted) {
//         setState(() => _citiesError = true);
//       }
//     }
//   }

//   Future<void> getUserId() async {
//     final prefs = await SharedPreferences.getInstance();
//     userId = prefs.getString("userId") ?? "";
//   }

//   @override
//   void dispose() {
//     nameController.dispose();
//     phoneController.dispose();
//     addressController.dispose();
//     cityController.dispose();
//     weightController.dispose();
//     addressUrlController.dispose();
//     super.dispose();
//   }

//   // دالة مساعدة لتنسيق حقول الإدخال لتناسب الـ Dark Mode
//   InputDecoration _buildInputDecoration(
//     BuildContext context,
//     String label,
//     IconData icon,
//   ) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return InputDecoration(
//       labelText: label,
//       labelStyle: TextStyle(
//         color: isDark ? Colors.grey[400] : Colors.grey[700],
//       ),
//       prefixIcon: Icon(icon, color: primaryColor),
//       filled: true,
//       fillColor: isDark ? AppColors.surfaceDark : Colors.white,
//       border: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide(
//           color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
//         ),
//       ),
//       enabledBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide(
//           color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
//         ),
//       ),
//       focusedBorder: OutlineInputBorder(
//         borderRadius: BorderRadius.circular(15),
//         borderSide: BorderSide(color: primaryColor, width: 2),
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isDark = Theme.of(context).brightness == Brightness.dark;
//     final primaryColor = Theme.of(context).colorScheme.primary;

//     return Scaffold(
//       backgroundColor: Theme.of(context).scaffoldBackgroundColor,
//       appBar: AppBar(
//         title: const Text("Edit Profile"),
//         backgroundColor: isDark
//             ? AppColors.surfaceDark
//             : const Color(0xff0861dd),
//         foregroundColor: Colors.white,
//         elevation: 0,
//       ),
//       body: BlocListener<ProfileCubit, ProfileState>(
//         listener: (context, state) {
//           if (state is ProfileUpdated) {
//             ScaffoldMessenger.of(context).showSnackBar(
//               const SnackBar(content: Text("Profile updated successfully")),
//             );
//             Navigator.pop(context);
//           }
//           if (state is ProfileError) {
//             ScaffoldMessenger.of(
//               context,
//             ).showSnackBar(SnackBar(content: Text(state.message)));
//           }
//         },
//         child: Padding(
//           padding: const EdgeInsets.all(20),
//           child: ListView(
//             children: [
//               TextField(
//                 controller: nameController,
//                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                 decoration: _buildInputDecoration(
//                   context,
//                   "Name",
//                   Icons.abc_sharp,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               TextField(
//                 controller: phoneController,
//                 keyboardType: TextInputType.phone,
//                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                 decoration: _buildInputDecoration(
//                   context,
//                   "Phone",
//                   Icons.phone_android,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               _citiesError
//                   ? const Text(
//                       "Failed to load cities",
//                       style: TextStyle(color: Colors.red),
//                     )
//                   : _cities.isEmpty
//                   ? const Center(child: CircularProgressIndicator())
//                   : DropdownButtonFormField<String>(
//                       dropdownColor: isDark
//                           ? AppColors.surfaceDark
//                           : Colors.white,
//                       style: TextStyle(
//                         color: isDark ? Colors.white : Colors.black,
//                       ),
//                       decoration: _buildInputDecoration(
//                         context,
//                         "City",
//                         Icons.location_city,
//                       ),
//                       value: _selectedCity,
//                       items: _cities
//                           .map(
//                             (city) => DropdownMenuItem(
//                               value: city,
//                               child: Text(city),
//                             ),
//                           )
//                           .toList(),
//                       onChanged: (city) {
//                         setState(() {
//                           _selectedCity = city;
//                           cityController.text = city ?? "";
//                         });
//                       },
//                     ),
//               const SizedBox(height: 15),

//               TextField(
//                 controller: addressController,
//                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                 decoration: _buildInputDecoration(
//                   context,
//                   "Address",
//                   Icons.home,
//                 ),
//               ),
//               const SizedBox(height: 15),

//               // ── Location Button ───────────────────────────────────
//               BlocBuilder<RegisterBloc, RegisterState>(
//                 builder: (context, state) {
//                   bool hasUrl = state.addressurl != null;
//                   return GestureDetector(
//                     onTap: () => _getCurrentLocation(context),
//                     child: Container(
//                       padding: const EdgeInsets.symmetric(
//                         horizontal: 15,
//                         vertical: 15,
//                       ),
//                       decoration: BoxDecoration(
//                         color: isDark ? AppColors.surfaceDark : Colors.white,
//                         border: Border.all(
//                           color: hasUrl
//                               ? Colors.lightGreen
//                               : (isDark
//                                     ? Colors.grey[800]!
//                                     : Colors.grey[300]!),
//                           width: hasUrl ? 2 : 1,
//                         ),
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Row(
//                         children: [
//                           Icon(
//                             hasUrl ? Icons.location_on : Icons.my_location,
//                             color: hasUrl ? Colors.lightGreen : primaryColor,
//                           ),
//                           const SizedBox(width: 10),
//                           Expanded(
//                             child: Text(
//                               hasUrl
//                                   ? 'Location captured ✓'
//                                   : 'Get Current Location (Optional)',
//                               style: TextStyle(
//                                 color: hasUrl
//                                     ? Colors.lightGreen
//                                     : (isDark
//                                           ? Colors.grey[400]
//                                           : Colors.grey[600]),
//                                 fontSize: 14,
//                               ),
//                             ),
//                           ),
//                           if (hasUrl)
//                             GestureDetector(
//                               onTap: () => context.read<RegisterBloc>().add(
//                                 LocationCleared(),
//                               ),
//                               child: const Icon(
//                                 Icons.close,
//                                 color: Colors.grey,
//                                 size: 18,
//                               ),
//                             ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//               const SizedBox(height: 15),

//               TextField(
//                 controller: weightController,
//                 keyboardType: TextInputType.number,
//                 style: TextStyle(color: isDark ? Colors.white : Colors.black),
//                 decoration: _buildInputDecoration(
//                   context,
//                   "Weight (Optional)",
//                   Icons.monitor_weight,
//                 ),
//               ),
//               const SizedBox(height: 30),

//               // ── Save Button ───────────────────────────────────────
//               BlocBuilder<ProfileCubit, ProfileState>(
//                 builder: (context, state) {
//                   if (state is ProfileUpdating) {
//                     return const Center(child: CircularProgressIndicator());
//                   }
//                   return ButtonOfAuth(
//                     buttonText: "Save Changes",
//                     buttoncolor: isDark ? primaryColor : Colors.grey.shade50,
//                     fontcolor: isDark ? Colors.white : Colors.lightGreen,
//                     borderSide: BorderSide(
//                       color: isDark ? Colors.transparent : Colors.lightGreen,
//                     ),
//                     onPressed: () async {
//                       if (userId.isEmpty) await getUserId();
//                       if (userId.isEmpty) return; // Handle session expired

//                       if (nameController.text.isEmpty ||
//                           phoneController.text.isEmpty ||
//                           addressController.text.isEmpty ||
//                           cityController.text.isEmpty) {
//                         ScaffoldMessenger.of(context).showSnackBar(
//                           const SnackBar(
//                             content: Text("Please fill in all required fields"),
//                             backgroundColor: Colors.red,
//                           ),
//                         );
//                         return;
//                       }

//                       context.read<ProfileCubit>().updateProfile(
//                         userId: userId,
//                         name: nameController.text,
//                         phoneNumber: phoneController.text,
//                         address: addressController.text,
//                         city: cityController.text,
//                         addressUrl: addressUrlController.text.isEmpty
//                             ? null
//                             : addressUrlController.text,
//                         weight: weightController.text.isEmpty
//                             ? null
//                             : double.tryParse(weightController.text),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   Future<void> _getCurrentLocation(BuildContext context) async {
//     try {
//       LocationPermission permission = await Geolocator.checkPermission();
//       if (permission == LocationPermission.denied) {
//         permission = await Geolocator.requestPermission();
//         if (permission == LocationPermission.denied) {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text('Location permission denied')),
//           );
//           return;
//         }
//       }
//       if (permission == LocationPermission.deniedForever) {
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(content: Text('Please enable location from settings')),
//         );
//         return;
//       }

//       final Position position = await Geolocator.getCurrentPosition(
//         desiredAccuracy: LocationAccuracy.high,
//       );

//       final String mapsUrl =
//           "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

//       if (context.mounted) {
//         context.read<RegisterBloc>().add(LocationChanged(mapsUrl));
//         ScaffoldMessenger.of(context).showSnackBar(
//           const SnackBar(
//             content: Text('Location captured ✓'),
//             backgroundColor: Colors.green,
//           ),
//         );
//       }
//     } catch (e) {
//       if (context.mounted) {
//         ScaffoldMessenger.of(
//           context,
//         ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
//       }
//     }
//   }
// }

// ignore_for_file: use_build_context_synchronously, deprecated_member_use

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:geolocator/geolocator.dart';
import 'package:healthcareapp_try1/API/auth_service.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_cubit.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/Patient_Profile.dart/patient_profile_state.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_bloc.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_event.dart';
import 'package:healthcareapp_try1/Bloc/Auth_Bloc/RegisterationBloc/register_state.dart';
import 'package:healthcareapp_try1/Models/Auth_Models/patient_profile_model.dart';
import 'package:healthcareapp_try1/core/Theme/app_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditProfilePage extends StatefulWidget {
  final PatientProfile profile;
  const EditProfilePage({super.key, required this.profile});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final addressController = TextEditingController();
  final cityController = TextEditingController();
  final weightController = TextEditingController();
  final addressUrlController = TextEditingController();

  String userId = "";
  List<String> _cities = [];
  String? _selectedCity;
  bool _citiesError = false;

  // ─── Theme helpers ────────────────────────────────────────────────────────
  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : const Color(0xfff4f7fb);
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _accent => _isDark ? Colors.blue.shade200 : const Color(0xff0861dd);
  Color get _primary => _isDark ? Colors.white : const Color(0xff0d1b4b);
  Color get _secondary => _isDark ? Colors.white60 : Colors.grey.shade600;
  Color get _iconBg => _isDark
      ? Colors.blue.shade900.withOpacity(0.35)
      : const Color(0xffe8f0fe);
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
  Color get _inputFill =>
      _isDark ? Colors.white.withOpacity(0.05) : Colors.grey.shade50;
  BoxShadow get _cardShadow => BoxShadow(
    color: _isDark ? Colors.black38 : Colors.black.withOpacity(0.06),
    blurRadius: 20,
    offset: const Offset(0, 6),
  );
  // ─────────────────────────────────────────────────────────────────────────

  @override
  void initState() {
    super.initState();
    nameController.text = widget.profile.name;
    phoneController.text = widget.profile.phoneNumber;
    addressController.text = widget.profile.address;
    cityController.text = widget.profile.city;
    weightController.text = widget.profile.weight?.toString() ?? "";
    addressUrlController.text = widget.profile.addressUrl ?? "";
    _selectedCity = widget.profile.city;
    getUserId();
    _loadCities();
  }

  Future<void> _loadCities() async {
    try {
      final cities = await AuthService().getCities();
      if (mounted) {
        setState(() {
          _cities = cities;
          if (!_cities.contains(_selectedCity)) _selectedCity = null;
        });
      }
    } catch (_) {
      if (mounted) setState(() => _citiesError = true);
    }
  }

  Future<void> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    userId = prefs.getString("userId") ?? "";
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    cityController.dispose();
    weightController.dispose();
    addressUrlController.dispose();
    super.dispose();
  }

  // ─── Shared field decoration ──────────────────────────────────────────────
  InputDecoration _fieldDecoration(String label, IconData icon) {
    final border = OutlineInputBorder(
      borderRadius: BorderRadius.circular(14),
      borderSide: BorderSide(color: _borderColor),
    );
    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: _secondary,
        fontFamily: 'Agency',
        fontSize: 13,
      ),
      prefixIcon: Container(
        margin: const EdgeInsets.all(10),
        padding: const EdgeInsets.all(7),
        decoration: BoxDecoration(
          color: _iconBg,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 15, color: _accent),
      ),
      filled: true,
      fillColor: _inputFill,
      border: border,
      enabledBorder: border,
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: _accent, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
    );
  }

  // ─── Shared card wrapper ──────────────────────────────────────────────────
  Widget _sectionCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [_cardShadow],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _iconBg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 16, color: _accent),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: _primary,
                  fontFamily: 'Cotta',
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Divider(
            color: _isDark ? Colors.white10 : Colors.grey.shade100,
            height: 1,
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _pageBg,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: _cardBg.withOpacity(0.85),
              shape: BoxShape.circle,
              boxShadow: [_cardShadow],
            ),
            child: Icon(Icons.arrow_back_ios_new, size: 16, color: _primary),
          ),
        ),
        title: Text(
          'Edit Profile',
          style: TextStyle(
            color: _primary,
            fontWeight: FontWeight.bold,
            fontFamily: 'Cotta',
            fontSize: 18,
          ),
        ),
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text("Profile updated successfully"),
                backgroundColor: Colors.green.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
            Navigator.pop(context);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red.shade600,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 110, 16, 32),
          child: Column(
            children: [
              // ── Personal info card ────────────────────────────────────────
              _sectionCard(
                title: 'Personal Information',
                icon: Icons.person_outline_rounded,
                children: [
                  _field(
                    nameController,
                    'Full Name',
                    Icons.badge_outlined,
                    TextInputType.name,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    phoneController,
                    'Phone Number',
                    Icons.phone_outlined,
                    TextInputType.phone,
                  ),
                  const SizedBox(height: 14),
                  _field(
                    weightController,
                    'Weight (kg)',
                    Icons.monitor_weight_outlined,
                    TextInputType.number,
                    hint: 'Optional',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // ── Location card ─────────────────────────────────────────────
              _sectionCard(
                title: 'Location',
                icon: Icons.location_on_outlined,
                children: [
                  // City dropdown
                  _citiesError
                      ? _errorChip('Failed to load cities')
                      : _cities.isEmpty
                      ? Center(
                          child: CircularProgressIndicator(
                            color: _accent,
                            strokeWidth: 2,
                          ),
                        )
                      : DropdownButtonFormField<String>(
                          dropdownColor: _cardBg,
                          style: TextStyle(
                            color: _primary,
                            fontFamily: 'Agency',
                            fontSize: 14,
                          ),
                          decoration: _fieldDecoration(
                            'City',
                            Icons.location_city_outlined,
                          ),
                          value: _selectedCity,
                          icon: Icon(
                            Icons.keyboard_arrow_down_rounded,
                            color: _secondary,
                          ),
                          items: _cities
                              .map(
                                (c) =>
                                    DropdownMenuItem(value: c, child: Text(c)),
                              )
                              .toList(),
                          onChanged: (city) => setState(() {
                            _selectedCity = city;
                            cityController.text = city ?? "";
                          }),
                        ),
                  const SizedBox(height: 14),
                  _field(
                    addressController,
                    'Address',
                    Icons.home_outlined,
                    TextInputType.streetAddress,
                  ),
                  const SizedBox(height: 14),
                  // GPS button
                  BlocBuilder<RegisterBloc, RegisterState>(
                    builder: (context, state) {
                      final hasUrl = state.addressurl != null;
                      return GestureDetector(
                        onTap: () => _getCurrentLocation(context),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 250),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: hasUrl
                                ? Colors.green.withOpacity(
                                    _isDark ? 0.15 : 0.08,
                                  )
                                : _inputFill,
                            border: Border.all(
                              color: hasUrl
                                  ? Colors.green.withOpacity(0.40)
                                  : _borderColor,
                              width: hasUrl ? 1.5 : 1,
                            ),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(7),
                                decoration: BoxDecoration(
                                  color: hasUrl
                                      ? Colors.green.withOpacity(0.15)
                                      : _iconBg,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  hasUrl
                                      ? Icons.location_on
                                      : Icons.my_location,
                                  size: 15,
                                  color: hasUrl ? Colors.green : _accent,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      hasUrl
                                          ? 'Location captured'
                                          : 'Get Current Location',
                                      style: TextStyle(
                                        fontFamily: 'Agency',
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: hasUrl ? Colors.green : _primary,
                                      ),
                                    ),
                                    Text(
                                      hasUrl ? 'Tap to update' : 'Optional',
                                      style: TextStyle(
                                        fontFamily: 'Agency',
                                        fontSize: 11,
                                        color: _secondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (hasUrl)
                                GestureDetector(
                                  onTap: () => context.read<RegisterBloc>().add(
                                    LocationCleared(),
                                  ),
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.12),
                                      shape: BoxShape.circle,
                                    ),
                                    child: const Icon(
                                      Icons.close,
                                      size: 14,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── Save button ───────────────────────────────────────────────
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  final isLoading = state is ProfileUpdating;
                  return SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : () => _onSave(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _accent,
                        disabledBackgroundColor: _isDark
                            ? Colors.white12
                            : Colors.grey.shade300,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                      child: isLoading
                          ? SizedBox(
                              width: 22,
                              height: 22,
                              child: CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2.5,
                              ),
                            )
                          : Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.white,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                const Text(
                                  'Save Changes',
                                  style: TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                    fontFamily: 'Agency',
                                  ),
                                ),
                              ],
                            ),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Helpers ──────────────────────────────────────────────────────────────

  Widget _field(
    TextEditingController controller,
    String label,
    IconData icon,
    TextInputType keyboard, {
    String? hint,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboard,
      style: TextStyle(color: _primary, fontFamily: 'Agency', fontSize: 14),
      decoration: _fieldDecoration(label, icon).copyWith(
        hintText: hint,
        hintStyle: TextStyle(
          color: _secondary,
          fontFamily: 'Agency',
          fontSize: 13,
        ),
      ),
    );
  }

  Widget _errorChip(String msg) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.red.withOpacity(0.30)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.error_outline, size: 14, color: Colors.red),
          const SizedBox(width: 6),
          Text(
            msg,
            style: const TextStyle(
              color: Colors.red,
              fontSize: 12,
              fontFamily: 'Agency',
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _onSave(BuildContext context) async {
    if (userId.isEmpty) await getUserId();
    if (userId.isEmpty) return;

    if (nameController.text.isEmpty ||
        phoneController.text.isEmpty ||
        addressController.text.isEmpty ||
        cityController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please fill in all required fields"),
          backgroundColor: Colors.red.shade600,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    context.read<ProfileCubit>().updateProfile(
      userId: userId,
      name: nameController.text,
      phoneNumber: phoneController.text,
      address: addressController.text,
      city: cityController.text,
      addressUrl: addressUrlController.text.isEmpty
          ? null
          : addressUrlController.text,
      weight: weightController.text.isEmpty
          ? null
          : double.tryParse(weightController.text),
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Location permission denied'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Please enable location from settings'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        return;
      }

      final pos = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      final url =
          "https://www.google.com/maps?q=${pos.latitude},${pos.longitude}";

      if (context.mounted) {
        context.read<RegisterBloc>().add(LocationChanged(url));
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Location captured ✓'),
            backgroundColor: Colors.green.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to get location: $e'),
            backgroundColor: Colors.red.shade600,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    }
  }
}
