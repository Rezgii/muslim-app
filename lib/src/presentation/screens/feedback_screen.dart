import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/config/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  final bool isFeedback;

  const FeedbackScreen({super.key, required this.isFeedback});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendMessage() async {
    final String text = _feedbackController.text.trim();
    if (text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Enter Text First'.tr)),
      );
      return;
    }

    final subject = widget.isFeedback ? 'User Feedback' : 'Problem Report';
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'abderrazzakkbelghite@gmail.com', // your email
      query: encodeQueryParameters({'subject': subject, 'body': text}),
    );

    try {
      await launchUrl(emailUri);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Some Error Occurred. Try Again Later'.tr)),
      );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    final isFeedback = widget.isFeedback;
    return Scaffold(
      appBar: AppBar(
        title: Text(isFeedback ? 'Send Feedback'.tr : 'Report a Problem'.tr),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
                  controller: _feedbackController,
                  decoration: InputDecoration(
                    labelText: isFeedback
                        ? 'Your Opinion'.tr
                        : 'Describe the Problem'.tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                16.verticalSpace,
                ElevatedButton(
                  onPressed: _sendMessage,
                  child: Text('Send'.tr),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
