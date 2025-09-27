import 'package:flutter/material.dart';
import 'package:note_app/widgets/messasge_dialog.dart';

import '../widgets/confirmation_dialog.dart';
import '../widgets/dialog_card.dart';
import '../widgets/new_tag_dialog.dart';

Future<String?> showNewTagDialog({required BuildContext context, String? tag}) {
  return showDialog<String>(
    context: context,
    builder: (context) => NewTagDialog(tag: tag),
  );
}

Future<bool?> showConfirmationDialog({
  required BuildContext context,
  required String title,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => ConfirmationDialog(title: title),
  );
}

Future<bool?> showMessageDialog({
  required BuildContext context,
  required String message,
}) {
  return showDialog<bool?>(
    context: context,
    builder: (_) => MessasgeDialog(message: message),
  );
}
