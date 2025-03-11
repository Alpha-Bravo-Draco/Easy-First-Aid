import 'dart:io';
import 'dart:typed_data';
import 'package:firebase_ml_model_downloader/firebase_ml_model_downloader.dart';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';

class Analyzeimage extends StatefulWidget {
  @override
  _AnalyzeimageState createState() => _AnalyzeimageState();
}

class _AnalyzeimageState extends State<Analyzeimage> {
  File? _imageFile;
  String? _predictedLabel;
  String? _cureSteps;
  Interpreter? interpreter;
  bool _dialogOpen = true;
  bool _isProcessing = false;
  bool _isResultDisplayed = false; // State for result container
  bool _isCureStepsLoading = false; // State for cure steps loader
  bool _isCureStepsDisplayed = false; // State for cure steps container

  @override
  void initState() {
    super.initState();
    loadModel();
    _openImagePickerDialog();
  }

  Future<void> loadModel() async {
    final conditions = FirebaseModelDownloadConditions();
    FirebaseModelDownloader.instance
        .getModel('FAmodel', FirebaseModelDownloadType.localModel, conditions)
        .then((customModel) async {
      interpreter = await Interpreter.fromFile(customModel.file);
    }).catchError((error) {
      print('Error downloading model: $error');
    });
  }

  Future<void> _getImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      _imageFile = File(pickedFile.path);

      Uint8List imageBytes = _imageFile!.readAsBytesSync();
      List<List<List<List<double>>>> preprocessedImage =
          await preprocessImage(imageBytes);

      setState(() {
        _isProcessing = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      await predictImage(preprocessedImage);

      setState(() {
        _isProcessing = false;
        _isResultDisplayed = true; // Show result container
      });

      // Show cure steps loader after the result container
      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isCureStepsLoading = true;
      });

      await Future.delayed(const Duration(seconds: 2));
      setState(() {
        _isCureStepsLoading = false;
        _isCureStepsDisplayed = true; // Show cure steps container
      });
    } else {
      setState(() {
        _dialogOpen = false;
      });
    }
  }

  Future<List<List<List<List<double>>>>> preprocessImage(
      Uint8List imageBytes) async {
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Failed to decode image.");
    }

    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    return List.generate(
      1,
      (_) => List.generate(
        224,
        (i) => List.generate(
          224,
          (j) {
            int pixel = resizedImage.getPixel(j, i);
            return [
              img.getRed(pixel) / 255.0,
              img.getGreen(pixel) / 255.0,
              img.getBlue(pixel) / 255.0
            ];
          },
        ),
      ),
    );
  }

  Future<void> predictImage(List<List<List<List<double>>>> input) async {
    if (interpreter == null) {
      print("Interpreter not loaded.");
      return;
    }

    var outputTensor = List.filled(1, List.filled(4, 0.0));
    interpreter!.allocateTensors();
    interpreter!.run(input, outputTensor);

    List<double> probabilities = List<double>.from(outputTensor[0]);
    double maxProbability = probabilities.reduce((a, b) => a > b ? a : b);
    int classIdx = probabilities.indexOf(maxProbability);

    double confidenceThreshold = 0.75;
    if (maxProbability >= confidenceThreshold) {
      String label = ['Acne', 'Bruises', 'Burns', 'Cut'][classIdx];
      setState(() {
        _predictedLabel = label;
      });

      _cureSteps = getCureSteps(label);
    } else {
      setState(() {
        _predictedLabel = 'Uncertain Prediction';
        _cureSteps = null;
      });
    }
  }

  Future<void> _openImagePickerDialog() async {
    await Future.delayed(Duration.zero);
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black.withOpacity(0.8),
      builder: (context) => AlertDialog(
        title: const Text('Select Image'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera),
              title: const Text('Camera'),
              onTap: () {
                _getImage(ImageSource.camera);
                Navigator.of(context).pop();
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                _getImage(ImageSource.gallery);
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    ).then((_) {
      setState(() {
        _dialogOpen = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1d2630),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(0xFF1d2630),
        foregroundColor: Colors.white,
        title: const Text("Analyze Image"),
        centerTitle: true,
      ),
      body: _dialogOpen
          ? Container()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    Center(
                      child: _imageFile == null
                          ? Container()
                          : Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.white, width: 3),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: Image.file(
                                  _imageFile!,
                                  width: 350,
                                  height: 250,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 20),
                    _isProcessing
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: Colors.white,
                            ),
                          )
                        : Column(
                            children: [
                              if (_isResultDisplayed) ...[
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Result',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1d2630),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        height: 60,
                                        padding: const EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1d2630),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "It's $_predictedLabel",
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.w700,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              if (_isCureStepsLoading)
                                const Column(
                                  children: [
                                    CircularProgressIndicator(
                                      color: Colors.white,
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      'Suggesting Cure Steps...',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              if (_isCureStepsDisplayed && _cureSteps != null)
                                Container(
                                  width: double.infinity,
                                  padding: const EdgeInsets.all(2),
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(
                                        color: Colors.white, width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Padding(
                                        padding: EdgeInsets.only(left: 5),
                                        child: Text(
                                          'Cure Steps',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: Color(0xFF1d2630),
                                          ),
                                        ),
                                      ),
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(4),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF1d2630),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Text(
                                          _cureSteps!,
                                          style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.w400,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                  ],
                ),
              ),
            ),
    );
  }

  String getCureSteps(String label) {
    switch (label) {
      case 'Acne':
        return "- Cleanse your face with a gentle cleanser twice a day.\n"
            "- Use a salicylic acid or benzoyl peroxide-based treatment.\n"
            "- Avoid touching or picking at pimples.\n"
            "- Moisturize with non-comedogenic products.\n"
            "- Consult a dermatologist if acne persists.";
      case 'Bruises':
        return "- Apply an ice pack for 15-20 minutes every hour in the first day.\n"
            "- Elevate the affected area to reduce swelling.\n"
            "- Avoid putting pressure on the bruise.\n"
            "- Use over-the-counter pain relievers if necessary.\n"
            "- Monitor for signs of severe injury or infection.";
      case 'Burns':
        return "- Rinse the burn with cool (not cold) water for 10-15 minutes.\n"
            "- Avoid applying ice or butter to the burn.\n"
            "- Cover with a clean, non-stick sterile bandage.\n"
            "- Take pain relievers if needed for discomfort.\n"
            "- Seek medical attention if the burn is deep or covers a large area.";
      case 'Cut':
        return "- Rinse the cut with clean water to remove debris.\n"
            "- Stop bleeding by applying gentle pressure with a clean cloth.\n"
            "- Apply an antibiotic ointment to prevent infection.\n"
            "- Cover with a sterile adhesive bandage or gauze.\n"
            "- Change the dressing daily and monitor for signs of infection.";
      default:
        return "No specific cure steps available. Please consult a healthcare provider.";
    }
  }

  @override
  void dispose() {
    interpreter?.close();
    super.dispose();
  }
}
