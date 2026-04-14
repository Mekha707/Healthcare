// ignore_for_file: use_key_in_widget_constructors, unused_element, unnecessary_cast

import 'dart:developer';
import 'dart:io';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:healthcareapp_try1/Bloc/ChatBloc/chat_cubit.dart';
import 'package:healthcareapp_try1/Bloc/ChatBloc/chat_state.dart';
import 'package:healthcareapp_try1/Models/AI/chat_response.dart';
import 'package:healthcareapp_try1/Models/Users_Models/doctor_model.dart';
import 'package:healthcareapp_try1/Pages/Booking/universal_details_page.dart';
import 'package:healthcareapp_try1/Widgets/typing_indicator.dart';

class HealthChatScreen extends StatefulWidget {
  @override
  State<HealthChatScreen> createState() => _HealthChatScreenState();
}

class _HealthChatScreenState extends State<HealthChatScreen> {
  final TextEditingController _controller = TextEditingController();

  String? selectedImagePath;

  @override
  void initState() {
    super.initState();
    context.read<ChatCubit>().loadHistory();
  }

  void showToast(String message, {bool isError = false}) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: isError ? Colors.red : Colors.black87,
      textColor: Colors.white,
      fontSize: 13,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.grey.shade100,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 10),

              Expanded(
                child: BlocConsumer<ChatCubit, ChatState>(
                  listener: (context, state) {
                    if (state is ChatError) {
                      showToast(state.message, isError: true);
                    }
                  },
                  builder: (context, state) {
                    // ... داخل الـ builder: (context, state)
                    return Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        border: Border.all(color: Colors.blue),
                      ),
                      child: Column(
                        children: [
                          _buildListTileHeader(),
                          const Divider(height: 1),

                          Expanded(
                            child: BlocBuilder<ChatCubit, ChatState>(
                              builder: (context, state) {
                                // بنجيب التاريخ من الـ Cubit مباشرة
                                final cubit = context.watch<ChatCubit>();
                                final history = cubit.history;
                                if (state is ChatInitial && history.isEmpty) {
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
                                    // لو وصلنا لآخر العنصر والـ state بتعمل تحميل، اظهر الـ Loader
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
                                            color: Colors.grey.shade100,
                                            borderRadius: BorderRadius.circular(
                                              12,
                                            ),
                                          ),
                                          child: const TypingIndicator(),
                                        ),
                                      );
                                    }

                                    final msg = history[index] as ChatMessage;
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
                                            msg.doctors!.isNotEmpty)
                                          _buildDoctorsList(msg.doctors!),

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

  // --- Widgets Methods ---
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
          color: isAi ? Colors.grey.shade100 : Colors.blue.shade100,
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
            color: isAi ? Colors.black87 : Colors.blue.shade900,
          ),
        ),
      ),
    );
  }

  // تغيير اسم المتغير ليكون أشمل
  String? selectedFilePath;

  Widget _buildInputField(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // معاينة الملف فوق الحقل
          if (selectedFilePath != null) _buildFilePreview(),

          Row(
            children: [
              // حقل الكتابة
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: 'Describe symptoms...',
                    hintStyle: TextStyle(fontSize: 14, fontFamily: 'Agency'),
                    filled: true,
                    fillColor: Colors.grey.shade50,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                  ),
                ),
              ),

              // زرار المشبك (Attachment)
              IconButton(
                icon: const Icon(Icons.attach_file, color: Colors.blue),
                onPressed: () async {
                  log(
                    "Attachment button pressed!",
                  ); // عشان نتأكد في الـ Console
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

              // زرار الإرسال
              CircleAvatar(
                backgroundColor: Colors.blue,
                child: IconButton(
                  icon: const Icon(
                    Icons.send_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  onPressed: () {
                    if (_controller.text.trim().isNotEmpty ||
                        selectedFilePath != null) {
                      context.read<ChatCubit>().sendSymptoms(
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

  // ويدجت صغيرة لمعاينة الملف المختار
  Widget _buildFilePreview() {
    bool isImage =
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
              color: Colors.blue.shade50,
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
                : const Icon(Icons.description, size: 40, color: Colors.blue),
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

  // --- باقي الـ Widgets بتاعتك زي ما هي ---
  Widget _buildListTileHeader() {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.blue.shade50,
        child: const Icon(Icons.smart_toy_outlined, color: Colors.blue),
      ),
      title: const Text(
        'AI Health Assistant',
        style: TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Cotta'),
      ),
      subtitle: const Text(
        'Powered by advanced medical AI',
        style: TextStyle(fontSize: 12, fontFamily: 'Agency'),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          fontFamily: 'Cotta',
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
          color: Colors.grey.shade600,
          fontFamily: 'Agency',
        ),
      ),
    );
  }

  Widget _buildDisclaimerCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const Icon(Icons.error_outline, color: Colors.orange, size: 20),
          const SizedBox(width: 10),
          const Expanded(
            child: Text(
              'This AI is for informational purposes only and not a substitute for professional medical advice.',
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey,
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
        const Text(
          "الأطباء المقترحون لك:",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Cotta',
          ),
        ),

        const SizedBox(height: 6),

        // ✅ التخصص الرئيسي
        Text(
          "التخصص المقترح: ${doctors.first.specialty}",
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
            fontFamily: 'Cotta',
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
                    color: Colors.blue.shade50,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.blue.shade100),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const CircleAvatar(
                        backgroundColor: Colors.white,
                        child: Icon(Icons.person, color: Colors.blue),
                      ),
                      const SizedBox(height: 5),

                      Text(
                        aiDoc.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Agency',
                        ),
                      ),

                      // ✅ التخصص كـ Chip
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          aiDoc.specialty,
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                            color: Color(0xff0861dd),
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
                            style: const TextStyle(fontSize: 12),
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
