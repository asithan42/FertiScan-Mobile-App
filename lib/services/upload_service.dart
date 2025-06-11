import 'dart:io';

import 'package:dio/dio.dart';

class UploadService {
  final Dio _dio = Dio();

  Future<String?> uploadLeafImage(File imageFile) async {
    const String url =
        'http://192.168.8.189:5000/upload-leaf'; // Change if needed

    try {
      String fileName = imageFile.path.split('/').last;

      FormData formData = FormData.fromMap({
        'image': await MultipartFile.fromFile(
          imageFile.path,
          filename: fileName,
        ),
      });

      Response response = await _dio.post(url, data: formData);
      print('Upload response: ${response.statusCode}');

      if (response.statusCode == 200) {
        return response
            .data['predicted_class']; // Ensure this matches your API response
      }
      return null;
    } catch (e) {
      print('Upload error: $e');
      return null;
    }
  }
}
