import 'dart:io';
import 'package:ascades/presentation/screens/about_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class UserWidget extends StatefulWidget {
  const UserWidget({Key? key}) : super(key: key);

  @override
  State<UserWidget> createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  bool hasImageSelected = false;
  final ImagePicker _picker = ImagePicker();
  XFile? _selectedImage;
  dynamic _output;
  bool notRecognized = false;

  classifyImage() async {
    await loadSkinOrNotSkinModel();
    var output = await Tflite.runModelOnImage(path: _selectedImage!.path);

    if (output != null && output[0]["label"] == 'not_skin') {
      setState(() {
        notRecognized = true;
        _output = null;
      });
      return;
    }

    await loadMainModel();
    output = await Tflite.runModelOnImage(path: _selectedImage!.path);

    setState(() {
      _output = output?[0];
      notRecognized = false;
    });
  }

  loadMainModel() async {
    await Tflite.loadModel(
      model: "assets/models/skin_cancer.tflite",
      labels: "assets/labels/skin_cancer.txt",
    );
  }

  loadSkinOrNotSkinModel() async {
    await Tflite.loadModel(
      model: "assets/models/skin_or_not_skin.tflite",
      labels: "assets/labels/skin_or_not_skin.txt",
    );
  }

  @override
  void dispose() {
    Tflite.close();
    super.dispose();
  }

  clearImage() {
    setState(() {
      _selectedImage = null;
      _output = null;
      hasImageSelected = false;
      notRecognized = false;
    });
  }

  Future pickFromGallery() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.gallery);
    if (photo == null) return;
    setState(() {
      _selectedImage = photo;
      hasImageSelected = true;
    });
    classifyImage();
  }

  Future pickFromcamera() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo == null) return;
    setState(() {
      _selectedImage = photo;
      hasImageSelected = true;
    });
    classifyImage();
  }

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Container(
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 4,
                        offset:
                            const Offset(0, 4), // changes position of shadow
                      ),
                    ]),
                child: ListTile(
                  title: const Text(
                    'Ascades',
                    style: TextStyle(fontWeight: FontWeight.w900, fontSize: 18),
                  ),
                  subtitle: const Text('A Skin Cancer Detection Expert System'),
                  trailing: IconButton(
                    icon: const Icon(Icons.info_outline_rounded),
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const AboutScreen()),
                      );
                    },
                    color: Colors.brown,
                  ),
                ),
              ),
              Container(
                  margin: const EdgeInsets.only(top: 30),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset:
                              const Offset(0, 4), // changes position of shadow
                        ),
                      ]),
                  child: hasImageSelected
                      ? SizedBox(
                          width: width,
                          height: width,
                          child: Center(
                            child: Image(
                                image: FileImage(File(_selectedImage!.path)),
                                fit: BoxFit.fill),
                          ))
                      : SizedBox(
                          width: width,
                          height: width,
                          child: Center(
                              child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.image_rounded,
                                size: 100,
                                color: Colors.brown.shade100,
                              ),
                              const Text(
                                'No Image is selected',
                                style: TextStyle(fontSize: 21),
                              ),
                            ],
                          )))),
              const SizedBox(
                height: 20,
              ),
              notRecognized == true
                  ? const Padding(
                      padding: EdgeInsets.all(9.0),
                      child: Text(
                        'Seems like the image is not skin 🤔. Try another.',
                        style: TextStyle(fontSize: 18),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : Container(),
              _output != null
                  ? Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        'Skin Cancer: ${_output["label"]}',
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  : Container(),
              _output != null
                  ? Padding(
                      padding: const EdgeInsets.all(9.0),
                      child: Text(
                        'Accuracy: ${(_output["confidence"] * 100).toStringAsFixed(2)}%',
                        style: const TextStyle(fontSize: 18),
                      ),
                    )
                  : Container(),
              Container(
                margin: const EdgeInsets.only(top: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: width / 2.3,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                          onPressed: pickFromGallery,
                          child: const Text('Select from gallery')),
                    ),
                    SizedBox(
                      width: width / 2.3,
                      height: 50,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                          child: const Text('Capture from camera'),
                          onPressed: pickFromcamera),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: width,
                height: 50,
                child: OutlinedButton(
                    style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(7),
                    ))),
                    child: const Text('Reset'),
                    onPressed: clearImage),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
