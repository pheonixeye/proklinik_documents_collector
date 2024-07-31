import 'package:cached_network_image/cached_network_image.dart';
import 'package:documents_collector/api/hx_documents.dart';
import 'package:documents_collector/providers/px_doctor.dart';
import 'package:documents_collector/providers/px_documents.dart';
import 'package:documents_collector/widgets/central_loading.dart';
import 'package:documents_collector/widgets/image_source_dialog.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class DoctorDocsPage extends StatefulWidget {
  const DoctorDocsPage({super.key});

  @override
  State<DoctorDocsPage> createState() => _DoctorDocsPageState();
}

class _DoctorDocsPageState extends State<DoctorDocsPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<PxDoctor, PxDocuments>(
      builder: (context, d, docs, _) {
        return Scaffold(
          appBar: AppBar(
            title: Text('Dr. ${d.doctor!.data['name_en']}'),
          ),
          body: Builder(
            builder: (context) {
              while (docs.documents == null) {
                return const CentralLoading();
              }
              return ListView(
                children: [
                  ...docs.documentKeys.map((e) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card.outlined(
                        elevation: 6,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ListTile(
                            title: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(e),
                            ),
                            subtitle: FutureBuilder(
                              future:
                                  HxDocuments.getFileUrl(docs.documents!.id, e),
                              builder: (context, snapshot) {
                                while (docs.documents == null) {
                                  return const Center(
                                    child: Text('No Image Found'),
                                  );
                                }
                                return CachedNetworkImage(
                                  imageUrl: snapshot.data.toString(),
                                  progressIndicatorBuilder:
                                      (context, url, downloadProgress) =>
                                          LinearProgressIndicator(
                                              value: downloadProgress.progress),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              },
                            ),
                            trailing: IconButton.outlined(
                              onPressed: () async {
                                BuildContext? dialogContext;
                                final ImageSource? source =
                                    await showDialog<ImageSource>(
                                  context: context,
                                  builder: (context) {
                                    return const ImageSourceModal();
                                  },
                                );
                                if (source == null) {
                                  return;
                                }
                                final picker = ImagePicker();
                                try {
                                  final result =
                                      await picker.pickImage(source: source);
                                  if (result == null) {
                                    return;
                                  }

                                  if (context.mounted) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        dialogContext = context;
                                        return const Material(
                                          type: MaterialType.card,
                                          child: CentralLoading(),
                                        );
                                      },
                                    );
                                  }
                                  final bytes = await result.readAsBytes();
                                  await docs
                                      .addDoctorDocoument(e, bytes)
                                      .whenComplete(() {
                                    Navigator.pop(dialogContext!);
                                  });
                                } catch (e) {
                                  if (context.mounted) {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          e.toString(),
                                        ),
                                      ),
                                    );
                                  }
                                }
                              },
                              icon: const Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),
        );
      },
    );
  }
}
