// ignore_for_file: use_key_in_widget_constructors, unused_element, unnecessary_cast, unnecessary_null_comparison

import 'dart:developer';
import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/AI_Chat_Bloc/ai_chat_cubit.dart';
import 'package:healthcareapp_try1/Bloc/AI_Chat_Bloc/ai_chat_state.dart';
import 'package:healthcareapp_try1/Models/AI/ai_chat_response.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/universal_details_page.dart';
import 'package:healthcareapp_try1/Widgets/typing_indicator.dart';
import 'package:healthcareapp_try1/core/theme/app_colors.dart';

class HealthChatScreen extends StatefulWidget {
  @override
  State<HealthChatScreen> createState() => _HealthChatScreenState();
}

class _HealthChatScreenState extends State<HealthChatScreen> {
  final TextEditingController _controller = TextEditingController();

  String? selectedImagePath;
  String? selectedFilePath;

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;
  Color get _pageBg => _isDark ? AppColors.bgDark : Colors.grey.shade100;
  Color get _cardBg => _isDark ? AppColors.surfaceDark : Colors.white;
  Color get _primaryText => _isDark ? AppColors.textDark : Colors.black87;
  Color get _secondaryText =>
      _isDark ? AppColors.textDark.withOpacity(0.7) : Colors.grey.shade600;
  Color get _borderColor =>
      _isDark ? Colors.white.withOpacity(0.08) : Colors.grey.shade200;
  Color get _accent => _isDark ? Colors.blue.shade200 : Colors.blue;
  Color get _bubbleAiBg =>
      _isDark ? AppColors.bgDark.withOpacity(0.85) : Colors.grey.shade100;
  Color get _bubbleUserBg =>
      _isDark ? Colors.blue.withOpacity(0.18) : Colors.blue.shade100;

  @override
  void initState() {
    super.initState();
    context.read<AiChatCubit>().loadHistory();
  }

  void showToast(String message, {bool isError = false}) {
    showToast(message);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: _pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Expanded(
                child: BlocConsumer<AiChatCubit, AiChatState>(
                  listener: (context, state) {
                    if (state is AiChatError) {
                      showToast(state.message, isError: true);
                    }
                  },
                  builder: (context, state) {
                    return Container(
                      decoration: BoxDecoration(
                        color: _cardBg,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(
                          color: _isDark ? _borderColor : Colors.blue,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: _isDark
                                ? Colors.black.withOpacity(0.18)
                                : Colors.black.withOpacity(0.04),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildListTileHeader(),
                          Divider(height: 1, color: _borderColor),
                          Expanded(
                            child: BlocBuilder<AiChatCubit, AiChatState>(
                              builder: (context, state) {
                                final cubit = context.watch<AiChatCubit>();
                                final history = cubit.history;

                                if (state is AiChatInitial && history.isEmpty) {
                                  return Center(
                                    child: _buildChatBubble(
                                      "Hello! I'm your AI health assistant...",
                                      isAi: true,
                                    ),
                                  );
                                }

                                return ListView.builder(
                                  padding: const EdgeInsets.all(16),
                                  itemCount:
                                      history.length + (cubit.isTyping ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == history.length &&
                                        cubit.isTyping) {
                                      return Align(
                                        alignment: Alignment.centerLeft,
                                        child: Container(
                                          margin: const EdgeInsets.only(
                                            bottom: 10,
                                            right: 40,
                                          ),
                                          padding: const EdgeInsets.all(12),
                                          decoration: BoxDecoration(
                                            color: _bubbleAiBg,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const TypingIndicator(),
                                        ),
                                      );
                                    }

                                    final msg = history[index] as AiChatMessage;
                                    return Column(
                                      crossAxisAlignment: msg.isUser
                                          ? CrossAxisAlignment.end
                                          : CrossAxisAlignment.start,
                                      children: [
                                        _buildChatBubble(
                                          msg.message,
                                          isAi: !msg.isUser,
                                        ),
                                        if (!msg.isUser &&
                                            msg.doctors != null &&
                                            msg.doctors.isNotEmpty)
                                          _buildDoctorsList(msg.doctors),
                                        const SizedBox(height: 20),
                                      ],
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                          _buildInputField(context),
                        ],
                      ),
                    );
                  },
                ),
              ),
              if (MediaQuery.of(context).viewInsets.bottom == 0)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: _buildDisclaimerCard(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildChatBubble(String text, {required bool isAi}) {
    return Align(
      alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: EdgeInsets.only(
          bottom: 10,
          right: isAi ? 40 : 0,
          left: isAi ? 0 : 40,
        ),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: isAi ? _bubbleAiBg : _bubbleUserBg,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(isAi ? 0 : 12),
            bottomRight: Radius.circular(isAi ? 12 : 0),
          ),
        ),
        child: Text(
          text,
          style: TextStyle(
            fontFamily: 'Agency',
            color: isAi
                ? _primaryText
                : (_isDark ? Colors.blue.shade100 : Colors.blue.shade900),
          ),
        ),
      ),
    );
  }

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: const BorderRadius.vertical(bottom: Radius.circular(15)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(_isDark ? 0.12 : 0.05),
            blurRadius: 5,
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (selectedFilePath != null) _buildFilePreview(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  style: TextStyle(
                    color: _primaryText,
                    fontSize: 14,
                    fontFamily: 'Agency',
                  ),
                  decoration: InputDecoration(
                    hintText: 'Describe symptoms...',
                    hintStyle: TextStyle(
                      fontSize: 14,
                      fontFamily: 'Agency',
                      color: _secondaryText,
                    ),
                    filled: true,
                    fillColor: _isDark
                        ? AppColors.bgDark.withOpacity(0.8)
                        : Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.attach_file, color: _accent),
                onPressed: () async {
                  log("Attachment button pressed!");
                  FilePickerResult? result = await FilePicker.platform
                      .pickFiles(
                        type: FileType.custom,
                        allowedExtensions: ['jpg', 'pdf', 'png', 'doc'],
                      );

                  if (result != null) {
                    setState(() {
                      selectedFilePath = result.files.single.path;
                    });
                  }
                },
              ),
              CircleAvatar(
                backgroundColor: _accent,
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty ||
                        selectedFilePath != null) {
                      context.read<AiChatCubit>().sendSymptoms(
                        _controller.text.trim(),
                        imagePath: selectedFilePath,
                      );
                      _controller.clear();
                      setState(() => selectedFilePath = null);
                    }
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFilePreview() {
    final isImage =
        selectedFilePath!.endsWith('.jpg') ||
        selectedFilePath!.endsWith('.png');

    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Stack(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              color: _isDark
                  ? Colors.blue.withOpacity(0.12)
                  : Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: isImage
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.file(
                      File(selectedFilePath!),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(Icons.description, size: 40, color: _accent),
          ),
          Positioned(
            right: -10,
            top: -10,
            child: IconButton(
              icon: const Icon(Icons.cancel, color: Colors.red, size: 20),
              onPressed: () => setState(() => selectedFilePath = null),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListTileHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: _isDark
            ? Colors.blue.withOpacity(0.12)
            : Colors.blue.shade50,
        child: Icon(Icons.smart_toy_outlined, color: _accent),
      ),
      title: Text(
        'AI Health Assistant',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontFamily: 'Cotta',
          color: _primaryText,
        ),
      ),
      subtitle: Text(
        'Powered by advanced medical AI',
        style: TextStyle(
          fontSize: 12,
          fontFamily: 'Agency',
          color: _secondaryText,
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cotta',
          color: _primaryText,
        ),
      ),
    );
  }

  Widget _buildSubText(String text) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: 14,
          color: _secondaryText,
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: _cardBg,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: _borderColor),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'This AI is for informational purposes only and not a substitute for professional medical advice.',
              style: TextStyle(
                fontSize: 11,
                color: _secondaryText,
                fontFamily: 'Agency',
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorsList(List<Doctor> doctors) {
    if (doctors.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "الأطباء المقترحون لك:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Cotta',
            color: _primaryText,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          "التخصص المقترح: ${doctors.first.specialty}",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Cotta',
            color: _primaryText,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 160,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: doctors.length,
            itemBuilder: (context, index) {
              final aiDoc = doctors[index];

              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProviderDetailsPage(
                        provider: aiDoc,
                        selectedServiceType: 'Clinic Visit',
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 150,
                  margin: const EdgeInsets.only(right: 10),
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: _isDark
                        ? Colors.blue.withOpacity(0.12)
                        : Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: _isDark
                          ? Colors.blue.withOpacity(0.2)
                          : Colors.blue.shade100,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        backgroundColor: _cardBg,
                        child: Icon(Icons.person, color: _accent),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        aiDoc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Agency',
                          color: _primaryText,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: _isDark
                              ? Colors.blue.withOpacity(0.18)
                              : Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          aiDoc.specialty,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: _isDark
                                ? Colors.blue.shade100
                                : const Color(0xff0861dd),
                          ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.star,
                            color: Colors.orange,
                            size: 14,
                          ),
                          Text(
                            aiDoc.rating.toString(),
                            style: TextStyle(fontSize: 12, color: _primaryText),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
