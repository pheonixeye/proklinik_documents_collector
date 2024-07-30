import 'package:documents_collector/api/pocket_main.dart';
import 'package:pocketbase/pocketbase.dart';

const doctors = 'doctors';
const personalPhone = 'personal_phone';
const published = 'published';
const verified = 'verified';

class HxDoctor {
  const HxDoctor();

  Future<RecordModel> findDoctor(String phoneNumber) async {
    try {
      final result = await pb.collection(doctors).getFirstListItem(
            "$personalPhone = '$phoneNumber'",
          );
      return result;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }

  Future<RecordModel> updateDoctorVerification(String id) async {
    try {
      final result = await pb.collection(doctors).update(
        id,
        body: {
          verified: true,
        },
      );
      return result;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }

  Future<RecordModel> updateDoctorPublishState(String id) async {
    try {
      final result = await pb.collection(doctors).update(
        id,
        body: {
          published: true,
        },
      );
      return result;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }
}
