// scan_rice_leaf_screen.dart

import 'package:camera/camera.dart';
import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/controllers/scan_rice_leaf_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

class ScanRiceLeafScreen extends StatelessWidget {
  const ScanRiceLeafScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ScanRiceLeafController());

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'scan_screen.title'.tr,
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 20,
              color: kGreenColor1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        backgroundColor: kWhiteColor,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: GetBuilder<ScanRiceLeafController>(
        builder:
            (_) =>
                controller.isCameraInitialized
                    ? controller.showPreview
                        ? _buildPreviewUI(controller, context)
                        : _buildCameraUI(controller)
                    : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _buildPreviewUI(
    ScanRiceLeafController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        Expanded(
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.file(
                controller.capturedImage!,
                width: 400,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
          child: Text(
            'scan_screen.retake_prompt'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: kGreyColor2,
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            OutlinedButton(
              onPressed: () {
                controller.showPreview = false;
                controller.capturedImage = null;
                controller.update();
              },
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Colors.red),
              ),
              child: Text(
                'scan_screen.retake_button'.tr,
                style: const TextStyle(color: Colors.red),
              ),
            ),
            ElevatedButton(
              onPressed:
                  controller.isUploading
                      ? null
                      : () => controller.handleImageUpload(context),
              child:
                  controller.isUploading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                      : Text('scan_screen.done_button'.tr),
            ),
          ],
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildCameraUI(ScanRiceLeafController controller) {
    return Column(
      children: [
        Expanded(
          child: Stack(
            children: [
              Center(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 370,
                    height: 270,
                    child: FittedBox(
                      fit: BoxFit.cover,
                      child: SizedBox(
                        width:
                            controller
                                .cameraController!
                                .value
                                .previewSize!
                                .height,
                        height:
                            controller
                                .cameraController!
                                .value
                                .previewSize!
                                .width,
                        child: CameraPreview(controller.cameraController!),
                      ),
                    ),
                  ),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: 370,
                  height: 270,
                  decoration: BoxDecoration(
                    border: Border.all(color: kGreenColor2, width: 5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'scan_screen.align_instruction'.tr,
            textAlign: TextAlign.center,
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(
                fontSize: 16,
                color: kGreyColor2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.only(bottom: 30, top: 16),
          child: ElevatedButton(
            onPressed: controller.takePhoto,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
            ),
            child: Text(
              'scan_screen.take_photo_button'.tr,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
