import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:note_app/widgets/dialog_card.dart';

import '../core/constants.dart';
import 'note_button.dart';
import 'note_form_field.dart';

class NewTagDialog extends StatefulWidget {
  const NewTagDialog({super.key, this.tag});

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
    return DialogCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Thêm nhãn',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            textAlign: TextAlign.left,
          ),
          SizedBox(height: 24),
          NoteFormField(
            key: tagKey,
            controller: tagController,
            hintText: 'Thêm nhãn (<16 kí tự)',
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
            autofocus: true,
          ),
          SizedBox(height: 24),
          DecoratedBox(
            decoration: BoxDecoration(
              boxShadow: [BoxShadow(offset: Offset(2, 2), color: black)],
              borderRadius: BorderRadius.circular(8),
            ),
            child: NoteButton(
              child: Text('Add'),
              onPressed: () {
                if (tagKey.currentState?.validate() ?? false) {
                  Navigator.pop(context, tagController.text.trim());
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}


