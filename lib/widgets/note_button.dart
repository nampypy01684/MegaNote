import 'package:flutter/material.dart';

import '../core/constants.dart';

class NoteButton extends StatelessWidget {
  const NoteButton({
    super.key,
    required this.label,
    this.onPressed,
  });


  final String label;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        // Sửa: Di chuyển style vào đây
        backgroundColor: primary,
        foregroundColor: white,
        // Sửa từ foregroundBuilder
        side: BorderSide(color: black),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 0,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
      ),
      child: Text(label), // Sửa: Text không có style ButtonStyle
    );
  }
}