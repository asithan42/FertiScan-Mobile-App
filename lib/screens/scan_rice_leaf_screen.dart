import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:fertiscanapp/constant/colors.dart';
import 'package:fertiscanapp/services/upload_service.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:path_provider/path_provider.dart';

class ScanRiceLeafScreen extends StatefulWidget {
  const ScanRiceLeafScreen({super.key});

  @override
  State<ScanRiceLeafScreen> createState() => _ScanRiceLeafScreenState();
}

class _ScanRiceLeafScreenState extends State<ScanRiceLeafScreen> {
  CameraController? _cameraController;
  late List<CameraDescription> _cameras;
  bool _isCameraInitialized = false;
  final int _selectedCameraIndex = 0;
  final storage = GetStorage();
  File? _capturedImage;
  bool _showPreview = false;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  

  Future<void> _initCamera() async {
    _cameras = await availableCameras();
    _initializeCamera(_selectedCameraIndex);
  }

  Future<void> _initializeCamera(int cameraIndex) async {
    _cameraController?.dispose();
    _cameraController = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.medium,
    );

    try {
      await _cameraController!.initialize();
      setState(() {
        _isCameraInitialized = true;
      });
    } catch (e) {
      debugPrint("Camera init error: $e");
    }
  }

  Future<void> _takePhoto() async {
    if (!_cameraController!.value.isInitialized) return;

    // Delete the previous image if it exists
    if (_capturedImage != null && await _capturedImage!.exists()) {
      await _capturedImage!.delete();
    }

    final XFile file = await _cameraController!.takePicture();
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String imagePath =
        '${appDir.path}/leaf_image_${DateTime.now().millisecondsSinceEpoch}.jpg';

    final File savedImage = await File(file.path).copy(imagePath);

    // Crop the image with limited controls (no rotation/scale), rectangular shape
    final croppedFile = await ImageCropper().cropImage(
      sourcePath: savedImage.path,
      aspectRatio: const CropAspectRatio(ratioX: 4, ratioY: 3),

      uiSettings: [
        AndroidUiSettings(
          toolbarTitle: 'Adjust the rice leaf Area',
          toolbarColor: Colors.green,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: true,
          hideBottomControls: true,
          showCropGrid: true,
        ),
        IOSUiSettings(
          title: 'Crop rice leaf',
          aspectRatioLockEnabled: true,
          rotateButtonsHidden: true,
          rotateClockwiseButtonHidden: true,
          aspectRatioPickerButtonHidden: true,
        ),
      ],
    );

    if (croppedFile != null) {
      setState(() {
        _capturedImage = File(croppedFile.path);
        _showPreview = true;
      });
    }
  }


// This function handles the image upload process
  Future<void> _handleImageUpload() async {
    if (_capturedImage == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      final uploadService = UploadService();
      final result = await uploadService
          .uploadLeafImage(_capturedImage!)
          .timeout(const Duration(seconds: 10)); // Add timeout

      if (result != null) {
        Navigator.pop(context, result);
      } else {
        Get.snackbar(
          'Upload Failed',
          'No response from server',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } on SocketException catch (_) {
      Get.snackbar(
        'Connection Error',
        'Please check your internet connection',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } on TimeoutException catch (_) {
      Get.snackbar(
        'Timeout Error',
        'Server took too long to respond',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Upload Error',
        'Failed to upload image: ${e.toString()}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Scan rice leaf',
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
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body:
          _isCameraInitialized
              ? _showPreview
                  ? Column(
                    children: [
                      Expanded(
                        child: Center(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              _capturedImage!,
                              width: 400,
                              height: 300,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8,
                        ),
                        child: Text(
                          'Is this image clear and not croped any part? \nIf not, please retake the photo.',
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
                              setState(() {
                                _showPreview = false;
                                _capturedImage = null;
                              });
                            },
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: Colors.red),
                            ),
                            child: const Text(
                              'Retake Photo',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                          ElevatedButton(
                            onPressed: _isUploading ? null : _handleImageUpload,
                            child:
                                _isUploading
                                    ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    )
                                    : const Text('Done'),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                    ],
                  )
                  : Column(
                    children: [
                      Expanded(
                        child: Stack(
                          children: [
                            Center(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: SizedBox(
                                    width: 370,
                                    height: 270,
                                    child: FittedBox(
                                      fit: BoxFit.cover,
                                      child: SizedBox(
                                        width:
                                            _cameraController!
                                                .value
                                                .previewSize!
                                                .height,
                                        height:
                                            _cameraController!
                                                .value
                                                .previewSize!
                                                .width,
                                        child: CameraPreview(
                                          _cameraController!,
                                        ),
                                      ),
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
                                  border: Border.all(
                                    color: kGreenColor2,
                                    width: 5,
                                  ),
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
                          'Please align the leaf within the frame',
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
                          onPressed: _takePhoto,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green[700],
                            padding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 14,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                          ),
                          child: const Text(
                            'Take Photo',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
              : const Center(child: CircularProgressIndicator()),
    );
  }
  
}
