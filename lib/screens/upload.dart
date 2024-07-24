import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:note_bot/screens/bottomnavbar.dart';
import 'package:note_bot/screens/pdfpreview.dart';
import 'package:note_bot/screens/sidebar.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:loader_overlay/loader_overlay.dart';

class UploadScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return UploadPage();
  }
}

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  PlatformFile? _selectedFile;
  bool _isUploading = false;
  String _notesheet = "";
  GenerativeModel? _model;
  List<String> allowed_extensions = ['jpg', 'png'];

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
        _model = GenerativeModel(
            model: 'gemini-1.5-pro',
            apiKey: apiKey,
            systemInstruction: Content.system("""
          Create a note sheet for the file with keypoints and summary.
Provide the output in the following JSON format only, with no additional text:

{
  "title": "A concise, descriptive title for the overall notes",
  "summary": "A brief (2-3 sentences) summary of the main points",
  "notes": [
    ["Subheading 1", "Content for subheading 1. Use *asterisks* for emphasis and - for bullet points."],
    ["Subheading 2", "Content for subheading 2"],
    ...
  ]
}

Guidelines:
1. Include 5-7 key points with brief explanations for each.
2. Each tuple in the "notes" list should have a subheading as the first element and the corresponding content as the second element.
3. Use *asterisks* to indicate emphasized text and - for bullet points in the content.

If you're unable to generate notes from the given content, please respond with:
{
  "error": "Brief explanation of why notes couldn't be generated"
}

This output will be used to generate a PDF, so adhere strictly to the JSON format specified."""));
      });
    } catch (e) {
      print('Error loading API key: $e');
    }
  }

  Future<void> _pickFile() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: allowed_extensions,
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

  Future<void> _showAlertDialog({required String alertText}) async {

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Error'),
          content: Text(alertText),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _processFile() async {
    if (_selectedFile == null || _model == null) {
      _showAlertDialog(alertText: 'No file selected or model not initialized');
      return;
    } else if (!allowed_extensions.contains(_selectedFile!.extension)) {
      _showAlertDialog(alertText: 'Invalid Extension');
      return;
    }
      setState(() {
        _isUploading = true;
        context.loaderOverlay.show();
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
        context.loaderOverlay.hide();
      });
    }
  }

  Future<void> _createNotesheet(Uint8List fileBytes) async {
    try {
      final imagePart = DataPart('image/jpeg', fileBytes);

      final content = [
        Content.multi([imagePart])
      ];

      final GenerateContentResponse response =
          await _model!.generateContent(content);

      setState(() {
        _notesheet = response.text!;
      });

      print('Notesheet received: ${response.text}');
      Navigator.of(context).push(MaterialPageRoute(builder: (context) {
        return PdfPreviewPage(_notesheet);
      }));
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
        body: LoaderOverlay(
          overlayColor: Color.fromARGB(168, 74, 74, 74),
          child: Stack(
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
                                    left: 30.0,
                                    top: 70.0,
                                  ),
                                  child: SizedBox(
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
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        _selectedFile != null
                                            ? Text(
                                                'Selected file: ${_selectedFile!.name}',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24.0),
                                              )
                                            : Text(
                                                'No file selected',
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24.0),
                                              ),
                                        SizedBox(height: 20),
                                        ElevatedButton(
                                          onPressed: _isUploading
                                              ? null
                                              : _processFile,
                                          child: Text(_isUploading
                                              ? 'Processing...'
                                              : 'Process File'),
                                        ),
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
                                  bottom: BorderSide(color: Colors.white)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.only(bottom: 10.0),
                              child: Text(
                                "Upload",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color:
                                        const Color.fromARGB(255, 39, 36, 36),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(top: 30.0, bottom: 30.0),
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
                              height:
                                  MediaQuery.of(context).size.height - 250.0,
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
        ));
  }
}
