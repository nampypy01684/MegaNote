import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/change_notifiers/new_note_controllers.dart';
import 'package:note_app/widgets/note_icon_button.dart';
import 'package:note_app/widgets/note_icon_button_outlined.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../widgets/note_toolbar.dart';

class NewOrEditPage extends StatefulWidget {
  const NewOrEditPage({required this.isNewNote, super.key});

  final bool isNewNote;

  @override
  State<NewOrEditPage> createState() => _NewOrEditPageState();
}

class _NewOrEditPageState extends State<NewOrEditPage> {
  final TextEditingController _titleController = TextEditingController();
  late NewNoteController newNoteController;
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

    quillController = QuillController.basic()
      ..addListener(() {
        newNoteController.content = quillController.document;
      });

    newNoteController = context.read<NewNoteController>();

    focusNode = FocusNode();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final timestamp = DateTime.now().microsecondsSinceEpoch; // Lưu ý: Thường dùng millisecondsSinceEpoch để tránh overflow
      if (widget.isNewNote) {
        focusNode.requestFocus();
        newNoteController.readOnly = false;
        // newNoteController.setTimestamp(timestamp); // Uncomment nếu cần lưu timestamp
      } else {
        newNoteController.readOnly = true;
      }
    });
  }

  @override
  void dispose() {
    quillController.dispose(); // Sửa: Dispose quillController thay vì _controller
    _titleController.dispose();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
              selector: (context, newNoteController) => newNoteController.readOnly,
              builder: (context, readOnly, child) => NoteIconButtonOutlined(
                key: UniqueKey(),
                icon: readOnly ? FontAwesomeIcons.pen : FontAwesomeIcons.bookOpen,
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
            NoteIconButtonOutlined(
              key: UniqueKey(),
              icon: FontAwesomeIcons.check,
              onPressed: () {
                // TODO: Lưu ghi chú và thoát
                Navigator.pop(context); // Ví dụ: thoát sau khi lưu
              },
            ),
          ],
        ),
        body: Selector<NewNoteController, bool>(
          selector: (_, controller) => controller.readOnly,
          builder: (_, readOnly, __) => Stack(
            children: [
              SingleChildScrollView(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Selector<NewNoteController, bool>(
                      selector: (context, controller) => controller.readOnly,
                      builder: (context, readOnly, child) => TextField(
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
                    if (!widget.isNewNote) ...[
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Sửa đổi lần cuối',
                              style: metadataStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              '10/07/2025, 12:00 AM',
                              style: metadataStyle.copyWith(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Expanded(
                            flex: 3,
                            child: Text(
                              'Ngày tạo',
                              style: metadataStyle,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Text(
                              '10/07/2025, 12:00 AM',
                              style: metadataStyle.copyWith(
                                color: Colors.black,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                    ],
                    Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  'Nhãn',
                                  style: metadataStyle,
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 8),
                              NoteIconButton(
                                key: UniqueKey(),
                                icon: FontAwesomeIcons.circlePlus,
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (context) => Center(
                                      child: Material(
                                        child: Container(
                                          width: MediaQuery.sizeOf(context).width * 0.75,
                                          padding: const EdgeInsets.all(16.0),
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,
                                            crossAxisAlignment: CrossAxisAlignment.stretch,
                                            children: [
                                              Text(
                                                'Thêm nhãn',
                                                style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                textAlign: TextAlign.left,
                                              ),
                                              TextField(
                                                decoration: InputDecoration(
                                                  hintText: 'Thêm nhãn (<16 kí tự)',
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                    borderSide: BorderSide(color: primary),
                                                  ),
                                                ),
                                              ),
                                              ElevatedButton(
                                                onPressed: () {},
                                                style: ElevatedButton.styleFrom(  // Sửa: Di chuyển style vào đây
                                                  backgroundColor: primary,
                                                  foregroundColor: white,  // Sửa từ foregroundBuilder
                                                  side: BorderSide(color: black),
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(12),
                                                  ),
                                                ),
                                                child: Text('Thêm nhãn'),  // Sửa: Text không có style ButtonStyle
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 5,
                          child: Text(
                            'Không có nhãn nào được thêm',
                            style: metadataStyle.copyWith(
                              color: Colors.black,
                            ),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ],
                    ),
                    const Divider(
                      thickness: 1,
                      color: Colors.grey,
                      height: 20,
                    ),
                    SizedBox(
                      height: 300,
                      child: QuillEditor.basic(
                        controller: quillController,  // Sửa: Dùng quillController thay _controller
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
                  child: NoteToolbar(controller: quillController),  // Sửa: Dùng quillController thay _controller
                ),
            ],
          ),
        ),
      ),
    );
  }
  //test git
}