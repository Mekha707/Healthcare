// ignore_for_file: deprecated_member_use, unused_local_variable

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class AmbulancePage extends StatefulWidget {
  const AmbulancePage({super.key});

  @override
  State<AmbulancePage> createState() => _AmbulancePageState();
}

class _AmbulancePageState extends State<AmbulancePage> {
  final _formKey = GlobalKey<FormState>();

  bool selectedForm = false;

  final TextEditingController _nameController = TextEditingController(
    text: "Mekha Morcos",
  );

  final TextEditingController _phoneController = TextEditingController(
    text: "0666666666",
  );

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.only(bottom: 50),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            child: Column(
              children: [
                _buildMainAmbulanceCard(),
                const SizedBox(height: 20),

                _buildEmergencyResponseCard(),
                const SizedBox(height: 20),
                AnimatedSwitcher(
                  duration: Duration(milliseconds: 400),
                  child: selectedForm
                      ? _buildEmergencyForm()
                      : _buildRequestActionCard(),
                ),
                const SizedBox(height: 20),

                _buildAmbulanceFeatures(
                  color: theme.colorScheme.error,
                  icon: FontAwesomeIcons.truckMedical,
                  title: "Advanced Life Support",
                  subTitle:
                      "All ambulances equipped with ALS equipment and trained paramedics",
                ),

                const SizedBox(height: 20),

                _buildAmbulanceFeatures(
                  color: theme.colorScheme.primary,
                  icon: FontAwesomeIcons.clock,
                  title: "Rapid Response",
                  subTitle:
                      "Average response time of 8-12 minutes across all service areas",
                ),

                const SizedBox(height: 20),

                _buildAmbulanceFeatures(
                  color: Colors.green,
                  icon: FontAwesomeIcons.circleCheck,
                  title: "24/7 Availability",
                  subTitle:
                      "Round-the-clock emergency medical services every day of the year",
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainAmbulanceCard() {
    return Container(
      width: double.infinity,
      height: 220,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25),
        image: const DecorationImage(
          image: AssetImage("assets/images/ambulance_demo.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Colors.black.withOpacity(0.7), Colors.transparent],
          ),
        ),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.bottomLeft,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Emergency Ambulance\nService",
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              "24/7 Emergency Medical Transport - Fast and Reliable",
              style: Theme.of(
                context,
              ).textTheme.bodySmall?.copyWith(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyResponseCard() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: theme.colorScheme.error.withOpacity(0.05),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.error.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: theme.colorScheme.error.withOpacity(0.1),
                child: Icon(
                  Icons.notifications_active_outlined,
                  color: theme.colorScheme.error,
                ),
              ),
              const SizedBox(width: 15),
              Text(
                "24/7 Emergency Response",
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 15),
          Text(
            "Our ambulances are equipped with advanced life support systems and staffed by trained paramedics ready to respond to your emergency.",
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 20),

          _buildInfoRow(
            Icons.access_time,
            "Average response time: 8-12 minutes",
          ),
          const SizedBox(height: 12),
          _buildInfoRow(
            Icons.phone_in_talk,
            "Emergency Hotline: 123",
            isBold: true,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, {bool isBold = false}) {
    final theme = Theme.of(context);

    return Row(
      children: [
        Icon(icon, size: 18, color: theme.colorScheme.error),
        const SizedBox(width: 10),
        Text(
          text,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            color: isBold
                ? theme.colorScheme.error
                : theme.textTheme.bodyMedium?.color,
          ),
        ),
      ],
    );
  }

  Widget _buildRequestActionCard() {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: theme.colorScheme.error),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: theme.colorScheme.error.withOpacity(0.1),
            child: Icon(
              FontAwesomeIcons.truckMedical,
              color: theme.colorScheme.error,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            "Need Emergency Medical Transport?",
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Request an ambulance immediately. Our team will respond within minutes.",
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium,
          ),
          const SizedBox(height: 25),
          ElevatedButton.icon(
            onPressed: () {
              setState(() {
                selectedForm = true;
              });
            },
            icon: const Icon(Icons.emergency),
            label: const Text("Request Ambulance Now"),
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.error,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 50),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyForm() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(0xffd51934),
          width: 1.5,
        ), // الإطار الأحمر كما في الصورة
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الهيدر الخاص بالنموذج
            const Row(
              children: [
                Icon(
                  FontAwesomeIcons.truckMedical,
                  color: Color(0xffd51934),
                  size: 20,
                ),
                SizedBox(width: 10),
                Text(
                  "Emergency Ambulance Request",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    fontFamily: 'Cotta',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              "Fill in the details below. Our team will be dispatched immediately.",
              style: TextStyle(fontSize: 13, fontFamily: 'Agency'),
            ),
            const SizedBox(height: 5),

            // الحقول
            _buildFieldLabel("Patient Name *"),
            _buildTextField(_nameController, "Enter patient name"),

            _buildFieldLabel("Contact Number *"),
            _buildTextField(
              _phoneController,
              "Enter contact number",
              isPhone: true,
            ),

            _buildFieldLabel("Emergency Location *"),
            _buildTextField(
              null,
              "Complete address with landmark",
              icon: Icons.location_on_outlined,
            ),

            _buildFieldLabel("Type of Emergency *"),
            _buildDropdownField(),

            _buildFieldLabel("Additional Details"),
            _buildTextField(
              null,
              "Describe the emergency situation...",
              isLongText: true,
            ),

            const Text(
              "Any additional information that can help the medical team prepare",
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),

            const SizedBox(height: 30),

            // الأزرار السفلية
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      setState(() {
                        selectedForm = false;
                      });
                    },
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: AppColors.primaryDark),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                    child: const Text("Cancel"),
                  ),
                ),
                const SizedBox(width: 15),
                Expanded(
                  flex: 2,
                  child: ElevatedButton.icon(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // تنفيذ الطلب
                      }
                    },
                    icon: const Icon(Icons.emergency, size: 18),
                    label: const Text("Dispatch Ambulance Now"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xffd51934),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAmbulanceFeatures({
    required String title,
    required String subTitle,
    required IconData icon,
    required Color color,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(25),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark ? AppColors.primary : Color(0xffc4d1d6),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(icon, color: color, size: 30),
          ),
          const SizedBox(height: 20),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Cotta',
            ),
          ),
          const SizedBox(height: 10),
          Text(
            subTitle,
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, fontFamily: 'Agency'),
          ),
        ],
      ),
    );
  }

  //   // ميثود مساعدة لبناء الحقل النصي
  Widget _buildTextField(
    TextEditingController? controller,
    String hint, {
    bool isPhone = false,
    bool isLongText = false,
    IconData? icon,
  }) {
    final theme = Theme.of(context); // 👈 أضف دي
    final isDark = theme.brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      maxLines: isLongText ? 4 : 1,
      keyboardType: isPhone ? TextInputType.phone : TextInputType.text,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(
          color: Colors.grey,
          fontSize: 13,
          fontFamily: 'Agency',
        ),
        prefixIcon: icon != null
            ? Icon(icon, size: 18, color: Colors.grey)
            : null,
        filled: true,
        fillColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,

        contentPadding: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 12,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Colors.grey.shade200),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Colors.red),
        ),
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return "This field is required";
        }
        if (isPhone && value.length < 10) {
          return "Invalid phone number";
        }
        return null;
      },
    );
  }

  // ميثود مساعدة لبناء عنوان الحقل
  Widget _buildFieldLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0, top: 10),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
      ),
    );
  }

  //   // ميثود القائمة المنسدلة (Type of Emergency)
  Widget _buildDropdownField() {
    String? selectedEmergency;
    final theme = Theme.of(context); // 👈 أضف دي
    final isDark = theme.brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: const Text(
            "Select emergency type",
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),
          isExpanded: true,
          items: [
            "Heart Attack",
            "Accident",
            "Stroke",
            "Breathing Issue",
            "Poisoning",
            "Other",
          ].map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
          onChanged: (val) {
            setState(() {
              selectedEmergency = val;
            });
          },
        ),
      ),
    );
  }
}
