import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rupee_app/model/db_user.dart';

final ValueNotifier<List<UserModel>> userModelsNotifier =
    ValueNotifier<List<UserModel>>([]);

class UserProfileFunctions {
  List<UserModel> profileDetailsNotifier = [];

  final box = Hive.box<UserModel>('userProfileBox');

  Future<void> addProfileDetails(UserModel details) async {
    await box.put(details.id, details);
    log('Added profile details successfully');
    log(
      details.id,
    );
  }

  List<UserModel> getAllProfileDetails() {
    return box.values.toList();
  }
}
