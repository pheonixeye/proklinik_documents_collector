import 'package:documents_collector/api/hx_user.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PxUserModel extends ChangeNotifier {
  final HxUser usersService;

  RecordAuth? _model;
  RecordAuth? get model => _model;

  PxUserModel({required this.usersService});

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      _model = await usersService.login(
        email: email,
        password: password,
      );
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
