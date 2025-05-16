// scan_rice_leaf_controller.dart
import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

import '../services/upload_service.dart';

class ScanRiceLeafController extends GetxController {
  CameraController? cameraController;
  late List<CameraDescription> cameras;
  bool isCameraInitialized = false;
  final int selectedCameraIndex = 0;
  final storage = GetStorage();

  File? capturedImage;
  bool showPreview = false;
  bool isUploading = false;

  final onUpdate = {}.obs;

  @override
  void onInit() {
    super.onInit();
    initCamera();
  }

  Future<void> initCamera() async {
    cameras = await availableCameras();
    await initializeCamera(selectedCameraIndex);
  }

  Future<void> initializeCamera(int cameraIndex) async {
    cameraController?.dispose();
    cameraController = CameraController(
      cameras[cameraIndex],
      ResolutionPreset.medium,
    );

    try {
      await cameraController!.initialize();
      isCameraInitialized = true;
      update();
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> takePhoto() async {
    if (!(cameraController?.value.isInitialized ?? false)) return;

    if (capturedImage != null && await capturedImage!.exists()) {
      await capturedImage!.delete();
    }

    final XFile file = await cameraController!.takePicture();
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath =
        '${appDir.path}/leaf_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final File savedImage = await File(file.path).copy(imagePath);

    final croppedFile = await ImageCropper().cropImage(
      sourcePath: savedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),
      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'scan_screen.toolbar_crop'.tr,
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          lockAspectRatio: true,
          hideBottomControls: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'scan_screen.crop_title'.tr,
          aspectRatioLockEnabled: true,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      capturedImage = File(croppedFile.path);
      showPreview = true;
      update();
    }
  }

  Future<void> handleImageUpload(BuildContext context) async {
    if (capturedImage == null) return;

    isUploading = true;
    update();

    try {
      final uploadService = UploadService();
      print( 'Uploading image: ${capturedImage!.path}');
      final result = await uploadService
          .uploadLeafImage(capturedImage!)
          .timeout(const Duration(seconds: 10));

      if (result != null) {
        Navigator.pop(context, result);
      } else {
        Get.snackbar(
          'scan_screen.upload_failed'.tr,
          'scan_screen.upload_no_response'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException {
      Get.snackbar(
        'scan_screen.connection_error'.tr,
        'scan_screen.check_connection'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on TimeoutException {
      Get.snackbar(
        'scan_screen.timeout_error'.tr,
        'scan_screen.timeout_response'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'scan_screen.upload_error'.tr,
        '${'scan_screen.upload_failed_msg'.tr} ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isUploading = false;
      update();
    }
  }

  @override
  void onClose() {
    cameraController?.dispose();
    super.onClose();
  }
}
