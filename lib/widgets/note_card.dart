import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../core/constants.dart';
import '../models/note.dart';
import '../pages/new_or_edit_page.dart';

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
            builder: (context) => NewOrEditPage(isNewNote: false),
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
            Text(
              'Tiêu đề',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: gray900,
              ),
            ),
            SizedBox(height: 4),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                  3,
                  (index) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: gray100,
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                    margin: EdgeInsets.only(right: 4),
                    child: Text(
                      'First',
                      style: TextStyle(fontSize: 12, color: gray700),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 4),
            if (isInGrid)
              Expanded(
                child: Text(
                  'Nội dung',
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(color: gray700),
                ),
              )
            else
              Text('Nội dung', style: TextStyle(color: gray700)),
            Row(
              children: [
                Text(
                  '10/07/2025',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: gray500,
                  ),
                ),
                Spacer(),
                FaIcon(FontAwesomeIcons.trash, color: gray500, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
