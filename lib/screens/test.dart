import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
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
    const apiKey = String.fromEnvironment('API_KEY');
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

  Future<void> _processVideoInChunks() async {
    if (_selectedFile == null || _model == null) return;

    setState(() {
      _isUploading = true;
    });

    try {
      // Get the video bytes
      Uint8List? videoBytes;
      if (_selectedFile!.bytes != null) {
        videoBytes = _selectedFile!.bytes;
      } else if (_selectedFile!.path != null) {
        videoBytes = await File(_selectedFile!.path!).readAsBytes();
      } else {
        throw Exception('No valid file path or bytes available');
      }

      // Ensure videoBytes is not null before proceeding
      if (videoBytes == null) {
        throw Exception('Failed to read video bytes');
      }

      // Split the video into chunks of 20MB or less
      const int chunkSize = 20 * 1024 * 1024; // 20MB chunk size
      List<Uint8List> chunks = [];
      for (int i = 0; i < videoBytes.length; i += chunkSize) {
        int end = (i + chunkSize < videoBytes.length)
            ? i + chunkSize
            : videoBytes.length;
        chunks.add(videoBytes.sublist(i, end));
      }

      for (int i = 0; i < chunks.length; i++) {
        print('Uploading chunk $i');
        await _uploadChunk(chunks[i], i);
      }

      // Combine results to create notesheet
      await _createNotesheet();
    } catch (e) {
      print('Error during video processing: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _uploadChunk(Uint8List chunk, int index) async {
    const apiKey = String.fromEnvironment('API_KEY');
    if (apiKey.isEmpty) {
      print('No API_KEY environment variable');
      return;
    }

    try {
      String apiUrl =
          "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash-latest:generateContent?key=$apiKey";
      var response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/octet-stream",
          "Chunk-Index": "$index",
        },
        body: chunk,
      );

      if (response.statusCode == 200) {
        print('Chunk $index upload successful');
      } else {
        print('Error uploading chunk $index: ${response.body}');
      }
    } catch (e) {
      print('Error uploading chunk $index: $e');
    }
  }

  Future<void> _createNotesheet() async {
    // Create the content for the model with the base64 data as part of the prompt
    final content = [
      Content.multi([
        TextPart("Generate a notesheet for the uploaded video chunks."),
      ])
    ];

    // Call the model's generateContent method
    final GenerateContentResponse response =
        await _model!.generateContent(content);

    setState(() {
      _notesheet = response.text;
    });

    print('Notesheet received: ${response.text}');
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
              onPressed: _isUploading ? null : _processVideoInChunks,
              child: Text(
                  _isUploading ? 'Processing...' : 'Process Video in Chunks'),
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
