import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/change_notifiers/new_note_controllers.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import 'package:note_app/widgets/note_metadata.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../widgets/confirmation_dialog.dart';
import '../widgets/dialog_card.dart';
import '../widgets/note_toolbar.dart';

class NewOrEditPage extends StatefulWidget {
  const NewOrEditPage({required this.isNewNote, super.key});

  final bool isNewNote;

  @override
  State<NewOrEditPage> createState() => _NewOrEditPageState();
}

class _NewOrEditPageState extends State<NewOrEditPage> {
  TextEditingController _titleController = TextEditingController();
  late NewNoteController newNoteController;
  late final TextEditingController titleController;
  late final FocusNode focusNode;
  late final QuillController quillController;

  // Style cho các trường metadata
  static const TextStyle metadataStyle = TextStyle(
    fontWeight: FontWeight.bold,
    color: gray500,
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    quillController =
        QuillController.basic()..addListener(() {
          newNoteController.content = quillController.document;
        });

    newNoteController = context.read<NewNoteController>();
    // titleController = TextEditingController();
    _titleController = TextEditingController(text: newNoteController.title);

    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timestamp =
          DateTime.now()
              .millisecondsSinceEpoch; // Lưu ý: Thường dùng millisecondsSinceEpoch để tránh overflow
      if (widget.isNewNote) {
        focusNode.requestFocus();
        newNoteController.readOnly = false;
        // newNoteController.setTimestamp(timestamp); // Uncomment nếu cần lưu timestamp
      } else {
        newNoteController.readOnly = true;
        quillController.document = newNoteController.content;
      }
    });
  }

  @override
  void dispose() {
    // titleController.dispose();
    quillController
        .dispose(); // Sửa: Dispose quillController thay vì _controller
    _titleController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvoked: (didPop) async {
          if (didPop) return;

          if (!newNoteController.canSaveNote) {
            Navigator.pop(context);
            return;
          }
          final bool? shouldSave = await showDialog<bool?>(
            context: context,
            builder: (_) => DialogCard(child: ConfirmationDialog()),
          );
          if (shouldSave == null) return;

          if (!context.mounted) return;
          if (shouldSave) {
            newNoteController.saveNote(context);
          }
          Navigator.pop(context);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: true,
          appBar: AppBar(
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: NoteIconButtonOutlined(
                key: UniqueKey(),
                icon: FontAwesomeIcons.chevronLeft,
                onPressed: () => Navigator.maybePop(context),
              ),
            ),
            title: Text(
              widget.isNewNote ? 'Ghi chú mới' : 'Sửa ghi chú',
              style: TextStyle(fontSize: 24),
            ),
            actions: [
              Selector<NewNoteController, bool>(
                selector:
                    (context, newNoteController) => newNoteController.readOnly,
                builder:
                    (context, readOnly, child) => NoteIconButtonOutlined(
                      key: UniqueKey(),
                      icon:
                          readOnly
                              ? FontAwesomeIcons.pen
                              : FontAwesomeIcons.bookOpen,
                      onPressed: () {
                        setState(() {
                          newNoteController.readOnly = !readOnly;

                          if (newNoteController.readOnly) {
                            FocusScope.of(context).unfocus();
                            // focusNode.unfocus();
                          } else {
                            focusNode.requestFocus();
                          }
                        });
                      },
                    ),
              ),
              Selector<NewNoteController, bool>(
                selector:
                    (_, newNoteController) => newNoteController.canSaveNote,
                builder:
                    (_, canSaveNote, __) => NoteIconButtonOutlined(
                      key: UniqueKey(),
                      icon: FontAwesomeIcons.check,
                      onPressed:
                          canSaveNote
                              ? () {
                                newNoteController.saveNote(context);
                                Navigator.pop(context);
                              }
                              : null,
                    ),
              ),
            ],
          ),
          body: Selector<NewNoteController, bool>(
            selector: (_, controller) => controller.readOnly,
            builder:
                (_, readOnly, __) => Stack(
                  children: [
                    SingleChildScrollView(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Selector<NewNoteController, bool>(
                            selector:
                                (context, controller) => controller.readOnly,
                            builder:
                                (context, readOnly, child) => TextField(
                                  // controller: titleController,
                                  controller: _titleController,
                                  style: const TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Tiêu đề',
                                    hintStyle: TextStyle(color: gray300),
                                    border: InputBorder.none,
                                  ),
                                  canRequestFocus: !readOnly,
                                  onChanged: (newValue) {
                                    newNoteController.title = newValue;
                                  },
                                ),
                          ),
                         NoteMetadata(note: newNoteController.note,),
                          const Divider(
                            thickness: 1,
                            color: Colors.grey,
                            height: 20,
                          ),
                          SizedBox(
                            height: 300,
                            child: QuillEditor.basic(
                              controller: quillController,
                              // Sửa: Dùng quillController thay _controller
                              config: QuillEditorConfig(
                                placeholder: 'Nhập ghi chú',
                                expands: true,
                              ),
                              focusNode: focusNode,
                            ),
                          ),
                          const SizedBox(height: 80),
                        ],
                      ),
                    ),
                    if (!readOnly)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: NoteToolbar(
                          controller: quillController,
                        ), // Sửa: Dùng quillController thay _controller
                      ),
                  ],
                ),
          ),
        ),
      ),
    );
  }
}
