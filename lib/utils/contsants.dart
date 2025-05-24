
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

Color borderColor= const Color.fromARGB(255, 2, 50, 114);



 Future<void> uploadVideoFile(Uint8List fileBytes, String filename,mController) async {
    final uri = Uri.parse('http://127.0.0.1:8000/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
      ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    mController.saveDir.value = jsonDecode(responseBody)['saved_to'];

    if (response.statusCode == 200) {
      print('Upload successful');
      print(mController.saveDir);
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }

   Future<void> uploadModelFile(Uint8List fileBytes, String filename,mController) async {
    final uri = Uri.parse('http://127.0.0.1:8000/upload');
    final request = http.MultipartRequest('POST', uri)
      ..files.add(http.MultipartFile.fromBytes(
        'file',
        fileBytes,
        filename: filename,
      ));

    final response = await request.send();
    final responseBody = await response.stream.bytesToString();
    mController.modelPath.value = jsonDecode(responseBody)['saved_to'];

    if (response.statusCode == 200) {
      print('Upload successful');
      print(mController.modelPath.value);
    } else {
      print('Upload failed: ${response.statusCode}');
    }
  }