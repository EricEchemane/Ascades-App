import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite/tflite.dart';

class UserWidget extends StatefulWidget {
  final GoogleSignInAccount user;
  final void Function() signOut;

  const UserWidget({Key? key, required this.user, required this.signOut})
      : super(key: key);

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
                  leading: GoogleUserCircleAvatar(identity: widget.user),
                  title: Text(widget.user.displayName!),
                  subtitle: Text(widget.user.email),
                  trailing: IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () {
                      showModalBottomSheet(
                          context: context,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          builder: (BuildContext context) {
                            return SizedBox(
                              height: 160,
                              child: Column(children: [
                                const SizedBox(
                                  height: 10,
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  onPressed: () {},
                                  child: const Text('Home'),
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  onPressed: () {},
                                  child: const Text('About'),
                                ),
                                MaterialButton(
                                  minWidth: width,
                                  height: 48,
                                  child: const Text('Sign out'),
                                  onPressed: widget.signOut,
                                ),
                              ]),
                            );
                          });
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
                        'Seems like the image is not skin 🤔',
                        style: TextStyle(fontSize: 18),
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
                      child: OutlinedButton(
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(7),
                          ))),
                          child: const Text('Reset'),
                          onPressed: clearImage),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
