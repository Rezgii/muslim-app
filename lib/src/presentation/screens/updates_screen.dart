import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim/src/core/utils/const/app_colors.dart';
import 'package:muslim/src/data/models/update_model.dart';

class UpdatesScreen extends StatelessWidget {
  const UpdatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Updates'.tr),
        surfaceTintColor: Colors.transparent,
        backgroundColor: AppColors.backgroundColor,
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: 3,
          itemBuilder: (context, index) {
            return _buildItem(UpdateModel(
                title: 'This is new update',
                description: 'i am adding new section for updates'));
          },
        ),
      )),
    );
  }

  Widget _buildItem(UpdateModel update) {
    return Container();
  }
}
