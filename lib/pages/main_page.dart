import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:note_app/change_notifiers/new_note_controllers.dart';
import 'package:note_app/change_notifiers/notes_provider.dart';
import 'package:note_app/core/constants.dart';
import 'package:note_app/pages/new_or_edit_page.dart';
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
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Row(
                          children: [
                            NoteIconButton(
                              icon:
                                  isDescending
                                      ? FontAwesomeIcons.arrowDown
                                      : FontAwesomeIcons.arrowUp,
                              onPressed: () {
                                setState(() {
                                  isDescending = !isDescending;
                                });
                              },
                            ),

                            SizedBox(width: 16),
                            DropdownButton<String>(
                              value: dropdownValue,
                              icon: Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: FaIcon(
                                  FontAwesomeIcons.arrowDownWideShort,
                                  size: 18,
                                  color: gray700,
                                ),
                              ),
                              underline: SizedBox.shrink(),
                              borderRadius: BorderRadius.circular(16),
                              isDense: true,
                              items:
                                  dropdownOptions
                                      .map(
                                        (e) => DropdownMenuItem<String>(
                                          value: e,
                                          child: Row(
                                            children: [
                                              Text(e),
                                              if (e == dropdownValue) ...[
                                                SizedBox(width: 8),
                                                Icon(Icons.check),
                                              ],
                                            ],
                                          ),
                                        ),
                                      )
                                      .toList(),
                              selectedItemBuilder:
                                  (context) =>
                                      dropdownOptions
                                          .map((e) => Text(e))
                                          .toList(),
                              onChanged: (newValue) {
                                setState(() {
                                  dropdownValue = newValue!;
                                });
                              },
                            ),
                            const Spacer(),
                            NoteIconButton(
                              icon:
                                  isGrid
                                      ? FontAwesomeIcons.tableCellsLarge
                                      : FontAwesomeIcons.bars,
                              onPressed: () {
                                setState(() {
                                  isGrid = !isGrid;
                                });
                              },
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  isGrid = !isGrid;
                                });
                              },
                              icon: FaIcon(
                                isGrid
                                    ? FontAwesomeIcons.tableCellsLarge
                                    : FontAwesomeIcons.bars,
                              ),
                              padding: EdgeInsets.zero,
                              visualDensity: VisualDensity.compact,
                              constraints: BoxConstraints(),
                              style: IconButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              iconSize: 18,
                              color: gray700,
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        child:
                            isGrid
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


