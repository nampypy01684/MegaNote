import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/change_notifiers/new_note_controllers.dart';
import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/pages/new_or_edit_page.dart';
import 'package:note_app/widgets/view_option.dart';
import 'package:provider/provider.dart';

import '../models/note.dart';
import '../widgets/no_notes.dart';
import '../widgets/note_fab.dart';
import '../widgets/note_grid.dart';
import '../widgets/note_icon_button.dart';
import '../widgets/note_icon_button_outlined.dart';
import '../widgets/notes_list.dart';
import '../widgets/search_field.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final List<String> dropdownOptions = ['Ngày sửa', 'Ngày tạo'];
  late String dropdownValue = dropdownOptions.first;

  bool isDescending = true;
  bool isGrid = true;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mega Notes 📒'),
          actions: [
            NoteIconButtonOutlined(
              icon: FontAwesomeIcons.rightFromBracket,
              onPressed: () {},
            ),
          ],
        ),
        floatingActionButton: NoteFab(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChangeNotifierProvider(
                    create: (context) => NewNoteController(),
                    child: NewOrEditPage(isNewNote: true)),
              ),
            );
          },
        ),
        body: Consumer<NotesProvider>(
          builder: (context, noteProvider, child) {
            final List<Note> notes = noteProvider.notes;
            return notes.isEmpty
                ? NoNotes()
                : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      SearchField(),
                     const ViewOptions(),
                      Expanded(
                        child:
                            noteProvider.isGrid
                                ? NotesGrid(notes: notes)
                                : NotesList(notes: notes),
                      ),
                    ],
                  ),
                );
          },
        ),
      ),
    );
  }
}


