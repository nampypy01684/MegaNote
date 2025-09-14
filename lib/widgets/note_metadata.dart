import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/core/dialogs.dart';
import 'package:note_app/core/utils.dart';
import 'package:provider/provider.dart';

import '../change_notifiers/new_note_controllers.dart';
import '../core/constants.dart';
import '../models/note.dart' show Note;
import 'dialog_card.dart';
import 'new_tag_dialog.dart';
import 'note_icon_button.dart';
import 'note_tag.dart';

class NoteMetadata extends StatefulWidget {
  const NoteMetadata({required this.note, super.key});

  final Note? note;

  @override
  State<NoteMetadata> createState() => _NoteMetadataState();
}

class _NoteMetadataState extends State<NoteMetadata> {
  late final NewNoteController newNoteController;

  @override
  void initState() {
    newNoteController = context.read();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.note != null) ...[
          Row(
            children: [
              Expanded(
                flex: 3,
                child: Text(
                  'Sửa đổi lần cuối',
                  style: TextStyle(fontWeight: FontWeight.bold, color: gray500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  toLongtDate(widget.note!.dateModified),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                  style: TextStyle(fontWeight: FontWeight.bold, color: gray500),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ),
              Expanded(
                flex: 5,
                child: Text(
                  toLongtDate(widget.note!.dateCreated),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
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
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: gray500,
                      ),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 8),
                  NoteIconButton(
                    key: UniqueKey(),
                    icon: FontAwesomeIcons.circlePlus,
                    onPressed: () async {
                      final String? tag = await showNewTagDialog(
                        context: context,
                      );
                      if (tag != null) {
                        newNoteController.addTag(tag);
                      }
                    },
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Selector<NewNoteController, List<String>>(
                selector: (_, newNoteController) => newNoteController.tags,
                builder:
                    (_, tags, __) =>
                        tags.isEmpty
                            ? const Text(
                              'Chưa có nhãn',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: gray900,
                              ),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            )
                            : SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Row(
                                children: List.generate(
                                  tags.length,
                                  (index) => NoteTag(
                                    label: tags[index],
                                    onClosed: () {
                                      newNoteController.removeTag(index);
                                    },
                                    onTap: () async {
                                    final String? tag = await showNewTagDialog(
                                        context: context,
                                        tag: tags[index],
                                      );

                                    if (tag != null && tag != tags[index]) {
                                      newNoteController.updateTag(index, tag);
                                    }
                                    },
                                  ),
                                ),
                              ),
                            ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
