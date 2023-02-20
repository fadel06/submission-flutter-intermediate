import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../provider/story_create_provider.dart';
import 'camera_screen.dart';

class StoryCreateScreen extends StatefulWidget {
  final Function onSend;

  const StoryCreateScreen({super.key, required this.onSend});

  @override
  State<StoryCreateScreen> createState() => _StoryCreateScreenState();
}

class _StoryCreateScreenState extends State<StoryCreateScreen> {
  final descriptionController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Create Story"),
          ),
          body: SafeArea(
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  Expanded(
                    flex: 3,
                    child:
                        context.watch<StoryCreateProvider>().imagePath == null
                            ? const Align(
                                alignment: Alignment.center,
                                child: Icon(
                                  Icons.image,
                                  size: 100,
                                ),
                              )
                            : _showImage(),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () => _onGalleryView(),
                          child: const Text("Gallery"),
                        ),
                        ElevatedButton(
                          onPressed: () => _onCameraView(),
                          child: const Text("Camera"),
                        ),
                        ElevatedButton(
                          onPressed: () => _onCustomCameraView(),
                          child: const Text("Custom Camera"),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: TextFormField(
                        controller: descriptionController,
                        decoration: const InputDecoration(
                          hintText: "Enter description",
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter description.';
                          }
                          return null;
                        },
                      ),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.all(16.0),
                    width: MediaQuery.of(context).size.width,
                    child: context.watch<StoryCreateProvider>().isUploading
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: () {
                              if (formKey.currentState!.validate()) {
                                var description = descriptionController.text;
                                _onUpload(description);
                              }
                              // widget.onSend();
                            },
                            child: const Text("Send"),
                          ),
                  )
                ],
              ),
            ),
          )),
    );
  }

  _onUpload(String description) async {
    final provider = context.read<StoryCreateProvider>();
    final ScaffoldMessengerState scaffoldMessengerState =
        ScaffoldMessenger.of(context);

    final imagePath = provider.imagePath;
    final imageFile = provider.imageFile;
    if (imagePath == null || imageFile == null) return;

    final fileName = imageFile.name;
    final bytes = await imageFile.readAsBytes();

    final newBytes = await provider.compressImage(bytes);

    await provider.storeStory(newBytes, fileName, description);

    if (provider.commonResponse != null) {
      provider.clearImage();
      descriptionController.text = '';
    }

    scaffoldMessengerState.showSnackBar(
      SnackBar(content: Text(provider.message)),
    );
  }

  _onGalleryView() async {
    final provider = context.read<StoryCreateProvider>();

    final isMacOS = defaultTargetPlatform == TargetPlatform.macOS;
    final isLinux = defaultTargetPlatform == TargetPlatform.linux;
    if (isMacOS || isLinux) return;

    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
        await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCameraView() async {
    final provider = context.read<StoryCreateProvider>();

    final isAndroid = defaultTargetPlatform == TargetPlatform.android;
    final isiOS = defaultTargetPlatform == TargetPlatform.iOS;
    final isNotMobile = !(isAndroid || isiOS);
    if (isNotMobile) return;

    final ImagePicker picker = ImagePicker();

    final XFile? pickedFile = await picker.pickImage(
      source: ImageSource.camera,
    );

    if (pickedFile != null) {
      provider.setImageFile(pickedFile);
      provider.setImagePath(pickedFile.path);
    }
  }

  _onCustomCameraView() async {
    final provider = context.read<StoryCreateProvider>();
    final navigator = Navigator.of(context);

    final cameras = await availableCameras();

    final XFile? resultImageFile = await navigator.push(
      MaterialPageRoute(
        builder: (context) => CameraScreen(
          cameras: cameras,
        ),
      ),
    );

    if (resultImageFile != null) {
      provider.setImageFile(resultImageFile);
      provider.setImagePath(resultImageFile.path);
    }
  }

  Widget _showImage() {
    final imagePath = context.read<StoryCreateProvider>().imagePath;
    return kIsWeb
        ? Image.network(
            imagePath.toString(),
            fit: BoxFit.contain,
          )
        : Image.file(
            File(imagePath.toString()),
            fit: BoxFit.contain,
          );
  }

  Future<bool> _onWillPop() async {
    final provider = context.read<StoryCreateProvider>();
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('The image will clear'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () {
                  provider.clearImage();
                  Navigator.of(context).pop(true);
                },
                child: const Text('Yes'),
              ),
            ],
          ),
        )) ??
        false;
  }
}
