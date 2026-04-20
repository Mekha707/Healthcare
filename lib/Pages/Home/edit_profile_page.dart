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
import 'package:healthcareapp_try1/Buttons/buttons.dart';
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
          if (!_cities.contains(_selectedCity)) {
            _selectedCity = null;
          }
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() => _citiesError = true);
      }
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

  // دالة مساعدة لتنسيق حقول الإدخال لتناسب الـ Dark Mode
  InputDecoration _buildInputDecoration(
    BuildContext context,
    String label,
    IconData icon,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return InputDecoration(
      labelText: label,
      labelStyle: TextStyle(
        color: isDark ? Colors.grey[400] : Colors.grey[700],
      ),
      prefixIcon: Icon(icon, color: primaryColor),
      filled: true,
      fillColor: isDark ? AppColors.surfaceDark : Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(
          color: isDark ? Colors.grey[800]! : Colors.grey[300]!,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(15),
        borderSide: BorderSide(color: primaryColor, width: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text("Edit Profile"),
        backgroundColor: isDark
            ? AppColors.surfaceDark
            : const Color(0xff0861dd),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: BlocListener<ProfileCubit, ProfileState>(
        listener: (context, state) {
          if (state is ProfileUpdated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully")),
            );
            Navigator.pop(context);
          }
          if (state is ProfileError) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: ListView(
            children: [
              TextField(
                controller: nameController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _buildInputDecoration(
                  context,
                  "Name",
                  Icons.abc_sharp,
                ),
              ),
              const SizedBox(height: 15),

              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _buildInputDecoration(
                  context,
                  "Phone",
                  Icons.phone_android,
                ),
              ),
              const SizedBox(height: 15),

              _citiesError
                  ? const Text(
                      "Failed to load cities",
                      style: TextStyle(color: Colors.red),
                    )
                  : _cities.isEmpty
                  ? const Center(child: CircularProgressIndicator())
                  : DropdownButtonFormField<String>(
                      dropdownColor: isDark
                          ? AppColors.surfaceDark
                          : Colors.white,
                      style: TextStyle(
                        color: isDark ? Colors.white : Colors.black,
                      ),
                      decoration: _buildInputDecoration(
                        context,
                        "City",
                        Icons.location_city,
                      ),
                      value: _selectedCity,
                      items: _cities
                          .map(
                            (city) => DropdownMenuItem(
                              value: city,
                              child: Text(city),
                            ),
                          )
                          .toList(),
                      onChanged: (city) {
                        setState(() {
                          _selectedCity = city;
                          cityController.text = city ?? "";
                        });
                      },
                    ),
              const SizedBox(height: 15),

              TextField(
                controller: addressController,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _buildInputDecoration(
                  context,
                  "Address",
                  Icons.home,
                ),
              ),
              const SizedBox(height: 15),

              // ── Location Button ───────────────────────────────────
              BlocBuilder<RegisterBloc, RegisterState>(
                builder: (context, state) {
                  bool hasUrl = state.addressurl != null;
                  return GestureDetector(
                    onTap: () => _getCurrentLocation(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                        vertical: 15,
                      ),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.surfaceDark : Colors.white,
                        border: Border.all(
                          color: hasUrl
                              ? Colors.lightGreen
                              : (isDark
                                    ? Colors.grey[800]!
                                    : Colors.grey[300]!),
                          width: hasUrl ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            hasUrl ? Icons.location_on : Icons.my_location,
                            color: hasUrl ? Colors.lightGreen : primaryColor,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              hasUrl
                                  ? 'Location captured ✓'
                                  : 'Get Current Location (Optional)',
                              style: TextStyle(
                                color: hasUrl
                                    ? Colors.lightGreen
                                    : (isDark
                                          ? Colors.grey[400]
                                          : Colors.grey[600]),
                                fontSize: 14,
                              ),
                            ),
                          ),
                          if (hasUrl)
                            GestureDetector(
                              onTap: () => context.read<RegisterBloc>().add(
                                LocationCleared(),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.grey,
                                size: 18,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 15),

              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                style: TextStyle(color: isDark ? Colors.white : Colors.black),
                decoration: _buildInputDecoration(
                  context,
                  "Weight (Optional)",
                  Icons.monitor_weight,
                ),
              ),
              const SizedBox(height: 30),

              // ── Save Button ───────────────────────────────────────
              BlocBuilder<ProfileCubit, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileUpdating) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  return ButtonOfAuth(
                    buttonText: "Save Changes",
                    buttoncolor: isDark ? primaryColor : Colors.grey.shade50,
                    fontcolor: isDark ? Colors.white : Colors.lightGreen,
                    borderSide: BorderSide(
                      color: isDark ? Colors.transparent : Colors.lightGreen,
                    ),
                    onPressed: () async {
                      if (userId.isEmpty) await getUserId();
                      if (userId.isEmpty) return; // Handle session expired

                      if (nameController.text.isEmpty ||
                          phoneController.text.isEmpty ||
                          addressController.text.isEmpty ||
                          cityController.text.isEmpty) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("Please fill in all required fields"),
                            backgroundColor: Colors.red,
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
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _getCurrentLocation(BuildContext context) async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permission denied')),
          );
          return;
        }
      }
      if (permission == LocationPermission.deniedForever) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please enable location from settings')),
        );
        return;
      }

      final Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      final String mapsUrl =
          "https://www.google.com/maps?q=${position.latitude},${position.longitude}";

      if (context.mounted) {
        context.read<RegisterBloc>().add(LocationChanged(mapsUrl));
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Location captured ✓'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Failed to get location: $e')));
      }
    }
  }
}
