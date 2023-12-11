import 'dart:developer';
import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/home/main_home.dart';
import 'package:rupee_app/screens/home/screen_home.dart';

class ScreenLogin extends StatefulWidget {
  const ScreenLogin({Key? key});

  @override
  State<ScreenLogin> createState() => _ScreenLoginState();
}

class _ScreenLoginState extends State<ScreenLogin> {
  final TextEditingController _userNameController = TextEditingController();

  File? _image;

  Future<void> getImageFromGallery() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }

  Future<String?> saveImage(File image) async {
    try {
      print('7777');
      final appDocDir = await getApplicationDocumentsDirectory();
      final uniqueFileName = DateTime.now().millisecondsSinceEpoch.toString();
      final imagePath = "${appDocDir.path}/$uniqueFileName.jpg";
      await image.copy(imagePath);
      print('fffff');
      print(imagePath);
      return imagePath;
    } catch (e) {
      log("Error saving image: $e");
      return null;
    }
  }

  CountryCode? _selectedCountry;

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [Colors.red, Colors.orange],
            ),
          ),
          child: Column(
            children: [
              SizedBox(
                height: 100,
              ),
              Column(
                mainAxisAlignment:
                    MainAxisAlignment.center, // Align children in the center
                children: [
                  Image.asset(
                    'assets/Login_logo.png',
                    height: 150,
                    width: 150,
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Align text in the center
                    children: [
                      Text(
                        'Please finish to continue and get the',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Align text in the center
                    children: [
                      Text(
                        'best from our app',
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                  height: 540,
                  width: double.infinity,
                  color: Colors.white,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 50,
                        ),
                        GestureDetector(
                          onTap: () async {
                            showDialog(
                              context: context,
                              builder: (ctx) {
                                return AlertDialog(
                                  backgroundColor: Colors.black,
                                  content: Text(
                                    'Choose Image From ',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.w500),
                                  ),
                                  actions: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            getImageFromGallery();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.image,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () async {
                                            getImageFromCamera();
                                            Navigator.pop(context);
                                          },
                                          icon: Icon(
                                            Icons.camera_alt_rounded,
                                            color: Colors.white,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                );
                              },
                            );
                          },
                          child: Column(
                            children: [
                              _image != null
                                  ? Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.file(
                                          _image!,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Container(
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.asset(
                                          'assets/profile.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                      height: 100,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                          width: 5,
                                          color: Colors.black,
                                        ),
                                        borderRadius: BorderRadius.circular(25),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white,
                                            offset: Offset(5, 5),
                                          ),
                                        ],
                                      ),
                                    ),
                              Text('Add your photo'),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: Colors.black),
                            ),
                            child: TextFormField(
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Name is required';
                                }
                                return null;
                              },
                              controller: _userNameController,
                              style: TextStyle(
                                  fontSize: 20), // Adjust the text size
                              decoration: InputDecoration(
                                hintText: 'Enter your name',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 25),
                          child: Container(
                            height: 70,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: Colors.grey.shade700,
                                width: 2,
                              ),
                            ),
                            child: CountryCodePicker(
                              onChanged: (CountryCode countryCode) {
                                print("New Country selected: " +
                                    countryCode.toString());
                                _selectedCountry = countryCode;
                              },
                              initialSelection:
                                  'IN', // Initial selected country code
                              favorite: [
                                '+91',
                                'US'
                              ], // Optional. To show only specific countries
                              showCountryOnly:
                                  true, // Set to true to only show country names without flags
                              showFlagMain:
                                  true, // Set to false to hide the main flag
                              showFlagDialog:
                                  true, // Set to false to hide the flag dialog
                              builder: (CountryCode? countryCode) {
                                return Row(children: [
                                  SizedBox(
                                    width: 15,
                                  ),
                                  Image.asset(countryCode!.flagUri!,
                                      package: 'country_code_picker'),
                                  SizedBox(width: 8.0),
                                  Text(
                                    countryCode.name!,
                                    style: TextStyle(fontSize: 20),
                                  )
                                ]);
                              },
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 50,
                        ),
                        ElevatedButton(
                            child: Text(
                              'Finish',
                              style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromARGB(255, 245, 91, 1),
                              minimumSize: Size(200, 50),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                            onPressed: () async {
                              //  print('ddd');
                              //print(_userNameController);

                              if (_formKey.currentState != null &&
                                  _formKey.currentState!.validate()) {
                                final name = _userNameController.text.trim();
                              }
                              String? imagePath = _image?.path;
                              if (_image != null) {
                                imagePath = await saveImage(_image!);
                                if (imagePath == null) {
                                  print('something went wrong');
                                } else {
                                  print(imagePath);
                                }
                              }
                              if (_userNameController.text.isNotEmpty) {
                                {
                                  final UserModel details = UserModel(
                                    imagePath: _image != null
                                        ? _image!.path
                                        : null, // Add image path if available
                                    name: _userNameController.text,
                                    country: 'india',
                                  );

                                  await UserProfileFunctions()
                                      .addProfileDetails(details);

                                  //   print(
                                  //       "Diary Entry: key=${details.id}  Name=${details.name}, location=${details.profile},  ImagePath=${details.profile}");
                                  // } else {
                                  //   print('something missing');
                                  // }

                                  print(
                                      'key=${details.id}  Name=${details.name} image= ${details.imagePath} country= ${details.country}');

                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenMainHome(),
                                    ),
                                  );
                                }
                              } else {
                                print('data not found');
                              }
                            })
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> getImageFromCamera() async {
    final image = await ImagePicker().pickImage(source: ImageSource.camera);
    if (image == null) return;

    final imageTemporary = File(image.path);

    setState(() {
      _image = imageTemporary;
    });
  }
}
