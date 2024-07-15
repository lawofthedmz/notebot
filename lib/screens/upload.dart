import 'dart:io';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'dart:typed_data';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/sidebar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'NoteBot',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: "Montserrat",
      ),
      home: UploadPage(),
    );
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
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
    try {
      String? apiKey = dotenv.env['API_KEY'];
      print(
          'API Key: $apiKey'); // Print the API key to verify it's loaded correctly
      if (apiKey == null || apiKey.isEmpty) {
        print('No API_KEY found in environment variables');
        return;
      }

      setState(() {
        _model = GenerativeModel(model: 'gemini-pro-vision', apiKey: apiKey);
      });
    } catch (e) {
      print('Error loading API key: $e');
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx', 'jpg', 'png'],
    );

    if (result != null) {
      setState(() {
        _selectedFile = result.files.single;
      });
      print('Selected file: ${_selectedFile!.name}');
    } else {
      print('No file selected');
    }
  }

  Future<void> _processFile() async {
    if (_selectedFile == null || _model == null) {
      print('No file selected or model not initialized');
      return;
    }

    setState(() {
      _isUploading = true;
    });

    try {
      Uint8List? fileBytes;
      if (_selectedFile!.bytes != null) {
        fileBytes = _selectedFile!.bytes;
      } else if (_selectedFile!.path != null) {
        fileBytes = await File(_selectedFile!.path!).readAsBytes();
      } else {
        throw Exception('No valid file path or bytes available');
      }

      if (fileBytes == null) {
        throw Exception('Failed to read file bytes');
      }

      print('File bytes loaded, size: ${fileBytes.length}');
      await _createNotesheet(fileBytes);
    } catch (e) {
      print('Error during file processing: $e');
    } finally {
      setState(() {
        _isUploading = false;
      });
    }
  }

  Future<void> _createNotesheet(Uint8List fileBytes) async {
    try {
      final prompt = TextPart(
          "Create a note sheet for the file with keypoints and summary.");
      final imagePart = DataPart('image/jpeg', fileBytes);

      final content = [
        Content.multi([prompt, imagePart])
      ];

      final GenerateContentResponse response =
          await _model!.generateContent(content);

      setState(() {
        _notesheet = response.text;
      });

      print('Notesheet received: ${response.text}');
    } catch (e) {
      print('Error generating notesheet: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      bottomNavigationBar:
          MediaQuery.of(context).size.width < 800 ? BottomNavBar() : null,
      body: Stack(
        children: [
          // Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF712A89), Color(0xFF140609)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),
          // SVG Overlay
          Positioned.fill(
            child: SvgPicture.asset(
              'assets/background.svg',
              fit: BoxFit.cover,
            ),
          ),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              if (constraints.maxWidth > 800) {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Row(
                    children: <Widget>[
                      SizedBox(
                        height: constraints.maxHeight,
                        child: Sidebar(),
                      ),
                      Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 30.0, top: 70.0, bottom: 30.0),
                              child: SizedBox(
                                height: 30.0,
                                width: constraints.maxWidth / 3,
                                child: ElevatedButton(
                                  onPressed: _pickFile,
                                  child: Text('Pick File'),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 40.0),
                              child: SizedBox(
                                width: constraints.maxWidth / 2,
                                height: 300.0,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: <Widget>[
                                    ElevatedButton(
                                      onPressed:
                                          _isUploading ? null : _processFile,
                                      child: Text(_isUploading
                                          ? 'Processing...'
                                          : 'Process File'),
                                    ),
                                    SizedBox(height: 20),
                                    _selectedFile != null
                                        ? Text(
                                            'Selected file: ${_selectedFile!.name}')
                                        : Text('No file selected'),
                                    SizedBox(height: 20),
                                    _notesheet != null
                                        ? Text('Notesheet: $_notesheet')
                                        : Text('No notesheet available'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              } else {
                return SizedBox(
                  height: constraints.maxHeight,
                  width: constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30.0),
                        width: constraints.maxWidth,
                        decoration: BoxDecoration(
                            border: Border(
                                bottom: BorderSide(color: Colors.white))),
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 10.0),
                          child: Text(
                            "Upload",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20.0),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 30.0, bottom: 30.0),
                        child: SizedBox(
                          height: 30.0,
                          width: constraints.maxWidth - 150,
                          child: ElevatedButton(
                            onPressed: _pickFile,
                            child: Text('Pick File'),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: SizedBox(
                          width: constraints.maxWidth - 100.0,
                          height: MediaQuery.of(context).size.height - 250.0,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              ElevatedButton(
                                onPressed: _isUploading ? null : _processFile,
                                child: Text(_isUploading
                                    ? 'Processing...'
                                    : 'Process File'),
                              ),
                              SizedBox(height: 20),
                              _selectedFile != null
                                  ? Text(
                                      'Selected file: ${_selectedFile!.name}')
                                  : Text('No file selected'),
                              SizedBox(height: 20),
                              _notesheet != null
                                  ? Text('Notesheet: $_notesheet')
                                  : Text('No notesheet available'),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
