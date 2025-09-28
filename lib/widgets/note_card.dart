import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:note_app/change_notifiers/new_note_controllers.dart';
import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/core/dialogs.dart';
import 'package:provider/provider.dart';

import '../core/constants.dart';
import '../core/utils.dart';
import '../models/note.dart';
import '../pages/new_or_edit_page.dart';
import 'note_tag.dart';

class NoteCard extends StatelessWidget {
  const NoteCard({required this.note, required this.isInGrid, super.key});

  final Note note;
  final bool isInGrid;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder:
                (context) => ChangeNotifierProvider(
                  create: (_) => NewNoteController()..note = note,
                  child: NewOrEditPage(isNewNote: false),
                ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: white,
          border: Border.all(color: primary, width: 2),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(color: primary.withOpacity(0.5), offset: Offset(4, 4)),
          ],
        ),
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (note.title != null) ...[
              Text(
                note.title!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: gray900,
                ),
              ),
              SizedBox(height: 4),
            ],
            if (note.tags != null) ...[
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: List.generate(
                    note.tags!.length,
                    (index) => NoteTag(label: note.tags![index]),
                  ),
                ),
              ),
            ],
            SizedBox(height: 4),
            if (note.content != null)
              isInGrid
                  ? Expanded(
                    child: Text(
                      note.content!,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(color: gray700),
                    ),
                  )
                  : Text(note.content!, style: TextStyle(color: gray700)),
            if (isInGrid) Spacer(),
            Row(
              children: [
                Text(
                  toShortDate(note.dateModified),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: gray500,
                  ),
                ),
                Spacer(),
                GestureDetector(
                  onTap: () async {
                    final shouldDelete = await showConfirmationDialog(
                      context: context,
                      title: "Chắc chắn muốn xóa ghi ghi chú này?",
                    ) ?? false;
                    // final bool? shouldSave = await showConfirmationDialog(
                    //   context: context,
                    //   title: "Bạn có muốn lưu thay đổi?",
                    // );
                    if (shouldDelete && context.mounted) {
                      context.read<NotesProvider>().deleteNote(note);
                    }
                  },

                  child: FaIcon(
                    FontAwesomeIcons.trash,
                    color: gray500,
                    size: 16,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
