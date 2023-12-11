import 'dart:io';

import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:rupee_app/database/user_controller.dart';
import 'package:rupee_app/model/db_user.dart';
import 'package:rupee_app/screens/home/account/account.dart';

class ScreenEditProfile extends StatelessWidget {
  const ScreenEditProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(colors: [Colors.red, Colors.orange]),
          ),
          child: Column(
            children: [
              SizedBox(
                child: Column(
                  children: [
                    SizedBox(
                      height: 60,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ScreenAccount()));
                      },
                      child: Row(
                        children: [
                          SizedBox(
                            width: 25,
                          ),
                          Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                          Text(
                            'Back',
                            style: TextStyle(
                              fontSize: 25,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                height: 110,
              ),
              ClipRRect(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30)),
                child: Container(
                  color: Colors.white,
                  height: 780,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ValueListenableBuilder<Box<UserModel>>(
                        valueListenable:
                            Hive.box<UserModel>('userProfileBox').listenable(),
                        builder: (context, box, child) {
                          final UserProfileFunctions profileFunctions =
                              UserProfileFunctions();
                          final List<UserModel> profileDetailsList =
                              profileFunctions.getAllProfileDetails();

                          if (profileDetailsList.isNotEmpty) {
                            final UserModel profileDetails =
                                profileDetailsList.first;
                            // Check if the user has added a photo
                            if (profileDetails.imagePath != null &&
                                profileDetails.imagePath!.isNotEmpty) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenAccount(),
                                    ),
                                  );
                                },
                                child: Container(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(20),
                                    child: Image.file(
                                      File(profileDetails.imagePath!),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                  height: 80,
                                  width: 80,
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
                              );
                            }
                          }
                          // Default image if no photo is added
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ScreenAccount(),
                                ),
                              );
                            },
                            child: Container(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.asset(
                                  'assets/profile.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              height: 80,
                              width: 80,
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
                          );
                        },
                      ),
                      Text('Edit your photo'),
                      SizedBox(
                        height: 30,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 25),
                        child: Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.black),
                          ),
                          child: TextField(
                            style:
                                TextStyle(fontSize: 20), // Adjust the text size
                            decoration: InputDecoration(
                              hintText: 'Edit your name',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 25),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.black),
                      //     ),
                      //     child: TextField(
                      //       style:
                      //           TextStyle(fontSize: 20), // Adjust the text size
                      //       decoration: InputDecoration(
                      //         hintText: 'Enter your Email',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 25),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.black),
                      //     ),
                      //     child: TextField(
                      //       style:
                      //           TextStyle(fontSize: 20), // Adjust the text size
                      //       decoration: InputDecoration(
                      //         hintText: 'Enter your Country',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
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
                      // SizedBox(
                      //   height: 30,
                      // ),
                      // Padding(
                      //   padding: EdgeInsets.symmetric(horizontal: 25),
                      //   child: Container(
                      //     decoration: BoxDecoration(
                      //       borderRadius: BorderRadius.circular(10),
                      //       border: Border.all(color: Colors.black),
                      //     ),
                      //     child: TextField(
                      //       style:
                      //           TextStyle(fontSize: 20), // Adjust the text size
                      //       decoration: InputDecoration(
                      //         hintText: 'Enter your Password',
                      //         border: OutlineInputBorder(
                      //           borderRadius: BorderRadius.circular(10),
                      //         ),
                      //       ),
                      //     ),
                      //   ),
                      // ),
                      SizedBox(
                        height: 30,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ScreenAccount()));
                        },
                        child: Text(
                          'Update',
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
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
