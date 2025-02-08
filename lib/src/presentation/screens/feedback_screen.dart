import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

class FeedbackScreen extends StatefulWidget {
  const FeedbackScreen({super.key});

  @override
  State<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends State<FeedbackScreen> {
  final TextEditingController _feedbackController = TextEditingController();

  Future<void> _sendFeedback() async {
    final String feedbackText = _feedbackController.text.trim();
    if (feedbackText.isNotEmpty) {
      final Uri emailUri = Uri(
        scheme: 'mailto',
        path:
            'abderrazzakkbelghite@gmail.com', // Replace with your email address
        query: encodeQueryParameters(
            <String, String>{'subject': 'User Feedback', 'body': feedbackText}),
      );

      try {
        await launchUrl(emailUri);
      } catch (e) {
        // Handle error
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Some Error Occured. Try Again Later'.tr)),
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Enter Text First'.tr)),
        );
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('feedback'.tr),
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
                    labelText: 'Your Opinion'.tr,
                    border: const OutlineInputBorder(),
                  ),
                ),
                16.verticalSpace,
                ElevatedButton(
                  onPressed: _sendFeedback,
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
