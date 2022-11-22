import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagepicker_app/view_images.dart';

class UploadMultipleImages extends StatefulWidget {
  const UploadMultipleImages({Key? key}) : super(key: key);

  @override
  State<UploadMultipleImages> createState() => _UploadMultipleImagesState();
}

class _UploadMultipleImagesState extends State<UploadMultipleImages> {

  final ImagePicker _picker = ImagePicker();
  List<XFile> _selectedFiles = [];
  FirebaseStorage _storageRef = FirebaseStorage.instance;
  List<String> _arrImageUrls = [];
  int uploadItem = 0;
  bool _isUploading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: _isUploading
              ? showLoading()
              : Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () {
                              selectImage();
                            },
                            child: Text(
                              'Select Images',
                              style: TextStyle(color: Colors.orange),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 15
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: () {
                            if(_selectedFiles.isNotEmpty)
                              {
                                uploadFunction(_selectedFiles);
                              }else
                                {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content:Text("Please Select Images"),),);
                                }
                          },
                          icon: Icon(Icons.file_upload),
                          label: Text('Upload'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                        ),
                        SizedBox(
                          width: 15.0,
                        ),
                        ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => ViewImages()),
                            );
                          },
                          icon: Icon(Icons.remove_red_eye),
                          label: Text('View'),
                          style: ButtonStyle(
                            backgroundColor:
                                MaterialStateProperty.all(Colors.orange),
                          ),
                        ),
                      ],
                    ),
                    _selectedFiles.length == 0
                        ? const Padding(
                            padding: EdgeInsets.fromLTRB(0, 100, 0, 0),
                            child: Text("No Image Selected"),
                          )
                        : Expanded(
                            child: GridView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: _selectedFiles.length,
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3),
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: Image.file(
                                      File(_selectedFiles[index].path),
                                      fit: BoxFit.cover,
                                    ),
                                  );
                                }),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget showLoading() {
    return Center(
      child: Column(
        children: [
          Text("Uploading : " +
              uploadItem.toString() +
              "/" +
              _selectedFiles.length.toString()),
          SizedBox(
            height: 30,
          ),
          CircularProgressIndicator()
        ],
      ),
    );
  }

  void uploadFunction(List<XFile> _images) {
    setState(() {
      _isUploading = true;
    });
    for (int i = 0; i < _images.length; i++) {
      var imageUlr = uploadFile(_images[i]);
      _arrImageUrls.add(imageUlr.toString());
    }
  }

  Future<String> uploadFile(XFile _image) async {
    Reference reference =
        _storageRef.ref().child("multiple_images").child(_image.name);
    UploadTask uploadTask = reference.putFile(File(_image.path));
    await uploadTask.whenComplete(() {
      setState(() {
        uploadItem ++;
        if(uploadItem == _selectedFiles.length)
        {
          _isUploading = false;
          uploadItem = 0;
        }
      });
    });
    return await reference.getDownloadURL();
  }

  Future<void> selectImage() async {
    if (_selectedFiles != null) {
      _selectedFiles.clear();
    }
    try {
      final List<XFile>? imgs = await _picker.pickMultiImage();
      if (imgs!.isNotEmpty) {
        _selectedFiles.addAll(imgs);
      }
      print("List of Selected images:" + imgs.toString());
    } catch (e) {
      print("Something wrong." + e.toString());
    }
    setState(() {});
  }
}
