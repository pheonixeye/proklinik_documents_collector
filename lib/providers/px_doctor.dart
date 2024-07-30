import 'package:documents_collector/api/hx_doctor.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PxDoctor extends ChangeNotifier {
  final HxDoctor doctorsService;

  PxDoctor({required this.doctorsService});

  RecordModel? _doctor;
  RecordModel? get doctor => _doctor;

  Future<void> fetchDoctorByPhoneNumber(String phoneNumber) async {
    try {
      _doctor = await doctorsService.findDoctor(phoneNumber);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateDoctorVerifiedState() async {
    try {
      _doctor = await doctorsService.updateDoctorVerification(_doctor!.id);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> updateDoctorPublishedState() async {
    try {
      _doctor = await doctorsService.updateDoctorPublishState(_doctor!.id);
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }
}
