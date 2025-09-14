import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../core/constants.dart';
import 'note_button.dart';

class NewTagDialog extends StatefulWidget {
  const NewTagDialog({
    super.key,
    this.tag,
  });

  final String? tag;

  @override
  State<NewTagDialog> createState() => _NewTagDialogState();
}

class _NewTagDialogState extends State<NewTagDialog> {
  late final TextEditingController tagController;

  late final GlobalKey<FormFieldState> tagKey;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    tagController = TextEditingController(text: widget.tag);

    tagKey = GlobalKey();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    tagController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Thêm nhãn',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          textAlign: TextAlign.left,
        ),
        SizedBox(height: 24),
        TextFormField(
          key: tagKey,
          controller: tagController,
          autofocus: true,
          decoration: InputDecoration(
            hintText: 'Thêm nhãn (<16 kí tự)',
            contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
            isDense: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: primary),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.red),
            ),
          ),
          validator: (value) {
            if (value!.trim().isEmpty) {
              return 'Chưa nhập nhãn';
            } else if (value!.trim().length > 16) {
              return 'Nhãn không được dài hơn 16 kí tự';
            }
            return null;
          },
          onChanged: (newValue) {
            tagKey.currentState?.validate();
          },
        ),
        SizedBox(height: 24),
        DecoratedBox(
          decoration: BoxDecoration(
            boxShadow: [BoxShadow(offset: Offset(2, 2), color: black)],
            borderRadius: BorderRadius.circular(8),
          ),
          child: NoteButton(
              label: 'Add',
              onPressed: () {
                if (tagKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, tagController.text.trim());
                }
              },
        ),
        ),
      ],
    );
  }
}
