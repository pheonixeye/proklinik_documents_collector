import 'package:documents_collector/api/pocket_main.dart';
import 'package:pocketbase/pocketbase.dart';

const appUsers = 'app_users';

class HxUser {
  const HxUser();
  Future<RecordAuth> login({
    required String email,
    required String password,
  }) async {
    try {
      final result =
          await pb.collection(appUsers).authWithPassword(email, password);
      pb.authStore.save(result.token, result.record);
      return result;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }

  void logout() {
    pb.authStore.clear();
  }

  RecordAuth loginFromAuthStore() {
    try {
      final result = pb.authStore.model;
      return result;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }

  static Future<void> sendResetPasswordRequest(String email) async {
    try {
      await pb.collection(appUsers).requestPasswordReset(email);
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }
}
