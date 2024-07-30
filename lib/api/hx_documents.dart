import 'package:documents_collector/api/pocket_main.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:pocketbase/pocketbase.dart';

const documents = 'documents';

class HxDocuments {
  HxDocuments(this.docId);

  final String docId;

  Future<RecordModel> checkIfDocumentExists() async {
    try {
      final result =
          await pb.collection(documents).getFirstListItem("doc_id = '$docId'");
      return result;
    } on ClientException catch (e) {
      if (kDebugMode) {
        print(e.response['message']);
      }
      try {
        final result = await pb.collection(documents).create(
          body: {
            'doc_id': docId,
          },
        );
        return result;
      } on ClientException catch (e) {
        throw Exception(e.response['message']);
      }
    }
  }

  Future<RecordModel> addDocumentToDoctorDocs({
    required String id,
    required String key,
    required List<int> fileBytes,
  }) async {
    try {
      final doctorDocuments = await pb.collection(documents).update(
        id,
        files: [
          http.MultipartFile.fromBytes(
            key,
            fileBytes,
            filename: key,
          ),
        ],
      );
      return doctorDocuments;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }

  static Future<Uri> getFileUrl(String id, String key) async {
    try {
      final record = await pb.collection(documents).getOne(id);
      final docKey = record.getStringValue(key);
      final uri = pb.files.getUrl(record, docKey);
      return uri;
    } on ClientException catch (e) {
      throw Exception(e.response['message']);
    }
  }
}
