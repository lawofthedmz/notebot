import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: TestScreen(),
    );
  }
}

class TestScreen extends StatefulWidget {
  @override
  _TestScreenState createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String? _notesheet;
  GenerativeModel? _model;

  @override
  void initState() {
    super.initState();
    _initializeModel();
  }

  void _initializeModel() async {
    final apiKey = const String.fromEnvironment('API_KEY');
    if (apiKey.isEmpty) {
      print('No API_KEY environment variable');
      return;
    }

    setState(() {
      _model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);
    });
  }

  Future<void> _pickVideo() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.video,
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
    } else {
      print('No file selected');
    }
  }

  Future<void> _uploadVideo() async {
    if (_selectedFile == null || _model == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get the video bytes
      Uint8List? videoBytes;
      if (_selectedFile!.bytes != null) {
        // If the file was picked on the web
        videoBytes = _selectedFile!.bytes;
      } else if (_selectedFile!.path != null) {
        // If the file was picked on a non-web platform
        videoBytes = await File(_selectedFile!.path!).readAsBytes();
      } else {
        throw Exception('No valid file path or bytes available');
      }

      // Upload the video to Firebase Storage
      String fileName = _selectedFile!.name;
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child('uploads/$fileName');
      UploadTask uploadTask = ref.putData(videoBytes!);

      TaskSnapshot snapshot = await uploadTask;
      String downloadUrl = await snapshot.ref.getDownloadURL();

      print('Upload successful. URL: $downloadUrl');

      // Send this URL to Gemini API
      await _sendToGemini(downloadUrl);
    } catch (e) {
      print('Error during video upload: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _sendToGemini(String downloadUrl) async {
    // Create the content for the model with the URL as part of the prompt
    final content = [
      Content.multi([
        TextPart("Generate a notesheet for this video: $downloadUrl"),
      ])
    ];

    // Call the model's generateContent method
    final response = await _model!.generateContent(content);

    setState(() {
      _notesheet = response.text;
    });

    print('Notesheet received: $_notesheet');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Test Screen'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: _pickVideo,
              child: Text('Pick Video'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isUploading ? null : _uploadVideo,
              child: Text(_isUploading ? 'Uploading...' : 'Upload Video'),
            ),
            SizedBox(height: 20),
            _selectedFile != null
                ? Text('Selected file: ${_selectedFile!.name}')
                : Text('No file selected'),
            SizedBox(height: 20),
            _notesheet != null
                ? Text('Notesheet: $_notesheet')
                : Text('No notesheet available'),
          ],
        ),
      ),
    );
  }
}
