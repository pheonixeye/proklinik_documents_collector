import 'package:documents_collector/api/hx_documents.dart';
import 'package:documents_collector/api/pocket_main.dart';
import 'package:flutter/material.dart';
import 'package:pocketbase/pocketbase.dart';

class PxDocuments extends ChangeNotifier {
  final String docId;
  final HxDocuments documentsService;

  PxDocuments({
    required this.docId,
    required this.documentsService,
  }) {
    fetchDocumentsOfOneDoctor();
  }

  final List<String> documentKeys = [
    'national_id_card_front',
    'national_id_card_back',
    'practice_permit',
    'syndicate_card',
    'specialist_cert',
    'consultant_cert',
    'contract_page_one',
    'contract_page_two',
    'contract_page_three',
  ];

  RecordModel? _documents;
  RecordModel? get documents => _documents;

  Future<void> fetchDocumentsOfOneDoctor() async {
    try {
      _documents = await documentsService.checkIfDocumentExists();
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addDoctorDocoument(String key, List<int> fileBytes) async {
    try {
      _documents = await documentsService.addDocumentToDoctorDocs(
        id: _documents!.id,
        key: key,
        fileBytes: fileBytes,
      );
      notifyListeners();
    } catch (e) {
      throw Exception(e);
    }
  }

  String imgUri(String key) {
    try {
      final uri = pb.files.getUrl(_documents!, key);
      // print(uri.toString());
      return uri.toString();
    } catch (e) {
      throw Exception(e);
    }
  }
}
