// ignore_for_file: prefer_const_constructors

import 'package:docs_clone/models/document_model.dart';
import 'package:docs_clone/models/error_model.dart';
import 'package:docs_clone/repository/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../colors/colors.dart';
import '../repository/document_repository.dart';
import '../repository/socket_repository.dart';

class DocumentView extends ConsumerStatefulWidget {
  final String id;

  const DocumentView({super.key, required this.id});

  @override
  ConsumerState<DocumentView> createState() => _DocumentViewState();
}

class _DocumentViewState extends ConsumerState<DocumentView> {
  TextEditingController titleController = TextEditingController(
    text: "Untitled Document",
  );
  final quill.QuillController _controller = quill.QuillController.basic();
  ErrorModel? errorModel;
  SocketRepository socketRepository = SocketRepository();

  @override
  void initState() {
    socketRepository.joinRoom(widget.id);
    fetchDocumentData();
    super.initState();
  }

  void fetchDocumentData() async {
    errorModel = await ref.read(documentRepositoryProvider).getDocById(
          ref.read(userProvider)!.token,
          widget.id,
        );

    if (errorModel!.data != null) {
      titleController.text = (errorModel!.data as DocumentModel).title;
      setState(() {});
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    super.dispose();
  }

  void updateTitle(WidgetRef ref, String title) {
    ref.read(documentRepositoryProvider).updateTitle(
          token: ref.read(userProvider)!.token,
          id: widget.id,
          title: title,
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kWhiteColor,
          elevation: 0,
          actions: [
            Row(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Image.asset(
                    'assets/images/docs-logo.png',
                    height: 40,
                  ),
                ),
                const SizedBox(width: 10),
                SizedBox(
                  width: 180,
                  child: TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      border: InputBorder.none,
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: kBlueColor,
                        ),
                      ),
                      contentPadding: EdgeInsets.only(left: 5),
                    ),
                    onSubmitted: (value) => updateTitle(ref, value),
                  ),
                ),
              ],
            ),
            SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(
                  Icons.lock,
                  size: 16,
                ),
                label: const Text('Share'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: kBlueColor,
                ),
              ),
            ),
          ],
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(5),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: kGreyColor,
                  width: 0.1,
                ),
              ),
            ),
          ),
        ),
        body: Column(
          children: [
            quill.QuillToolbar.basic(controller: _controller),
            Expanded(
              child: SizedBox(
                width: 700,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Card(
                    color: kWhiteColor,
                    elevation: 10,
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: quill.QuillEditor.basic(
                        controller: _controller,
                        readOnly: false, // true for view only mode
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ));
  }
}
