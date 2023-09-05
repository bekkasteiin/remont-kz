// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';

class FileService {
  static Future<File?> getImage(BuildContext context) async {
    final picker = ImagePicker();
    try {
      File? file;
      final pickerFile = await picker.getImage(
        source: ImageSource.gallery,
      );
      if (pickerFile != null) {
        file = File(pickerFile.path);
      } else {
        final snackBar = SnackBar(content: Text('No image selected'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return file;
    } on PlatformException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }

  static Future<File?> getImageCamera(BuildContext context) async {
    final picker = ImagePicker();
    try {
      File? file;
      final pickerFile = await picker.getImage(
        source: ImageSource.camera,
      );
      if (pickerFile != null) {
        file = File(pickerFile.path);
      } else {
        final snackBar = SnackBar(content: Text('No image selected'));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      return file;
    } on PlatformException catch (e) {
      final snackBar = SnackBar(content: Text(e.message.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (e) {
      final snackBar = SnackBar(content: Text(e.toString()));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
    return null;
  }
}