import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:file_picker/file_picker.dart';
import 'dart:io';

void main() {
  runApp(FileSharingApp());
}

class FileSharingApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'File Sharing App',
      home: FileSharingScreen(),
    );
  }
}

class FileSharingScreen extends StatefulWidget {
  @override
  _FileSharingScreenState createState() => _FileSharingScreenState();
}

class _FileSharingScreenState extends State<FileSharingScreen> {
  File? _selectedFile;

  Future<void> _selectFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();
    if (result != null) {
      File file = File(result.files.single.path!);
      setState(() {
        _selectedFile = file;
      });
    }
  }

// ...

Future<void> _uploadFile() async {
  if (_selectedFile != null) {
    var request = http.MultipartRequest(
      'POST',
      Uri.parse('http://localhost:3000/upload'),
// Replace 'your_actual_server_ip' with the correct IP address
    );
    request.files.add(
      http.MultipartFile.fromBytes(
        'file',
        await _selectedFile!.readAsBytes(),
        filename: _selectedFile!.path.split('/').last,
      ),
    );

    try {
      var response = await request.send();
      if (response.statusCode == 200) {
        print('File uploaded to the server');
      } else {
        print('File upload failed');
      }
    } catch (e) {
      print('Error uploading file: $e');
    }
  }
}

// ...

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File Sharing App'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            if (_selectedFile != null)
              Text('Selected File: ${_selectedFile!.path.split('/').last}')
            else
              Text('No file selected'),
            ElevatedButton(
              onPressed: _selectFile,
              child: Text('Select File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _uploadFile,
              child: Text('Upload File'),
            ),
          ],
        ),
      ),
    );
  }
}
