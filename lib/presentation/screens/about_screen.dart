import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About Ascades'),
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Colors.white,
          statusBarIconBrightness: Brightness.dark,
          statusBarBrightness: Brightness.dark, // For iOS (dark icons)
        ),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            "           Skin cancer is a type of cancer that develops in the skin tissue, causing serious harm to healthy tissues, disability, and even death. In the Philippines, one out of every 50 Filipinos will be diagnosed with skin cancer at some point in their lives. Fortunately, it can be easily dealt with if detected at an early stage. Although skin cancer does not discriminate based on age or ethnicity, the following characteristics might enhance a person's chances of getting detected. The accuracy of diagnosis and the early proper treatment can minimize and control the harmful effects of skin cancer. Due to the similar shape of the lesion between skin cancer and benign tumor lesions, physicians consume muchmore time in diagnosing these lesions. The system developed in this study could detect skin cancer through image processing using the Convolutional Neural Network (CNN). The proposed model consists of three hidden layers with an RGB channel of 3 x 3 for each layer respectively. The researchers use the HAM10000 dataset to train the model in cnn. The dataset has the seven types of skin cancer namely actinic keratoses and intraepithelial carcinoma, benign keratosis-like lesions, basal cell carcinoma, melanoma, dermatofibroma, melanocytic nevi, and vascular lesions.",
            style: TextStyle(height: 1.5, fontSize: 16),
            textAlign: TextAlign.justify,
          )),
    );
  }
}
