import 'package:documents_collector/api/hx_documents.dart';
import 'package:documents_collector/pages/doctor_docs_page.dart';
import 'package:documents_collector/providers/px_doctor.dart';
import 'package:documents_collector/providers/px_documents.dart';
import 'package:documents_collector/widgets/central_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final formKey = GlobalKey<FormState>();
  late final TextEditingController _srcController = TextEditingController();

  @override
  void dispose() {
    _srcController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('ProKliniK Assisstant'),
      ),
      body: Consumer<PxDoctor>(
        builder: (context, d, _) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Form(
                  key: formKey,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            controller: _srcController,
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              hintText: "Search By Phone Number.",
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.digitsOnly
                            ],
                            keyboardType: TextInputType.phone,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Enter Phone Number.';
                              }
                              if (value.length < 11) {
                                return 'Enter a Correct Mobile Number (11-Digits)';
                              }
                              return null;
                            },
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: FloatingActionButton(
                          heroTag: 'src-btn',
                          onPressed: () async {
                            if (formKey.currentState!.validate()) {
                              BuildContext? dialogContext;
                              showDialog(
                                context: context,
                                builder: (context) {
                                  dialogContext = context;
                                  return const CentralLoading();
                                },
                              );
                              await d
                                  .fetchDoctorByPhoneNumber(_srcController.text)
                                  .whenComplete(() {
                                Navigator.pop(dialogContext!);
                              });
                            }
                          },
                          child: const Icon(Icons.search),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Builder(
                  builder: (context) {
                    while (d.doctor == null) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text("Search Result."),
                        ),
                      );
                    }
                    return ListView.builder(
                      itemCount: 1,
                      itemBuilder: (context, index) {
                        return Card.outlined(
                          elevation: 6,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              leading: Builder(
                                builder: (context) {
                                  final verified =
                                      d.doctor!.data['verified'] as bool;
                                  final published =
                                      d.doctor!.data['published'] as bool;
                                  Color color(bool isTrue) =>
                                      isTrue ? Colors.green : Colors.red;
                                  return Column(
                                    children: [
                                      Icon(
                                        verified ? Icons.verified : Icons.close,
                                        color: color(verified),
                                      ),
                                      Icon(
                                        published
                                            ? Icons.public
                                            : Icons.public_off,
                                        color: color(published),
                                      ),
                                    ],
                                  );
                                },
                              ),
                              title: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(d.doctor!.data['name_en']),
                              ),
                              subtitle: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(d.doctor!.data['personal_phone']),
                              ),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        ChangeNotifierProvider(
                                      create: (context) => PxDocuments(
                                        docId: d.doctor!.id,
                                        documentsService:
                                            HxDocuments(d.doctor!.id),
                                      ),
                                      child: const DoctorDocsPage(),
                                    ),
                                  ),
                                );
                              },
                              trailing: PopupMenuButton(
                                itemBuilder: (context) {
                                  return [
                                    PopupMenuItem(
                                      child: const Text('Verify'),
                                      onTap: () async {
                                        BuildContext? dialogContext;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            dialogContext = context;
                                            return const CentralLoading();
                                          },
                                        );
                                        await d
                                            .updateDoctorVerifiedState()
                                            .whenComplete(() {
                                          Navigator.pop(dialogContext!);
                                        });
                                      },
                                    ),
                                    PopupMenuItem(
                                      child: const Text('Publish'),
                                      onTap: () async {
                                        BuildContext? dialogContext;
                                        showDialog(
                                          context: context,
                                          builder: (context) {
                                            dialogContext = context;
                                            return const CentralLoading();
                                          },
                                        );
                                        await d
                                            .updateDoctorPublishedState()
                                            .whenComplete(() {
                                          Navigator.pop(dialogContext!);
                                        });
                                      },
                                    ),
                                  ];
                                },
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
