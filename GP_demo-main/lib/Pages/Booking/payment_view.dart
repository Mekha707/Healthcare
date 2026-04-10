import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class PaymentScreen extends StatefulWidget {
  final String paymentUrl;

  const PaymentScreen({super.key, required this.paymentUrl});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            // ممكن تظهر Loading Spinner هنا
          },
          onPageFinished: (String url) {
            // تخفي الـ Spinner
          },
          onNavigationRequest: (request) {
            // بنشيك لو الرابط يحتوي على كلمة النجاح اللي السيرفر بيبعتها
            if (request.url.contains('success=true') ||
                request.url.contains('status=success')) {
              // بنقفل الـ BottomSheet وبنبعت معاه قيمة true عشان نعرف الصفحة اللي تحتها إن الدفع تم
              Navigator.pop(context, true);
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Online Payment"),
        backgroundColor: Colors.white,
      ),
      body: WebViewWidget(controller: controller),
    );
  }
}

class PaymentBottomSheet extends StatefulWidget {
  final String paymentUrl;
  const PaymentBottomSheet({super.key, required this.paymentUrl});

  @override
  State<PaymentBottomSheet> createState() => _PaymentBottomSheetState();
}

class _PaymentBottomSheetState extends State<PaymentBottomSheet> {
  late final WebViewController controller;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageFinished: (_) => setState(() => isLoading = false),
          onNavigationRequest: (request) {
            if (request.url.contains('success=true')) {
              Navigator.pop(context); // اقفل الـ Bottom Sheet لما ينجح
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.paymentUrl));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      padding: const EdgeInsets.only(bottom: 20, left: 20, right: 20),
      margin: const EdgeInsets.only(bottom: 1),
      child: Column(
        children: [
          // شريط صغير للسحب (Handle)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 10),
            width: 40,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const Text(
            "Secure Payment",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Expanded(
            child: Stack(
              children: [
                WebViewWidget(controller: controller),
                if (isLoading) const Center(child: CircularProgressIndicator()),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
