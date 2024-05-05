import 'package:flutter/material.dart';
import 'package:flutter_tunes/app/app_colors.dart';

class GenreFilterChip extends StatelessWidget {
  const GenreFilterChip({
    required this.text,
    required this.isEnabled,
    this.onSelected,
    super.key,
  });

  final String text;

  final bool isEnabled;
  final void Function()? onSelected;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16.0),
      child: ActionChip(
        label: Text(
          text,
          style: const TextStyle(color: Colors.black),
        ),
        side: const BorderSide(color: Colors.grey, width: 0.5),
        backgroundColor: isEnabled ? AppColors.primaryColor : Colors.white,
        disabledColor: Colors.white,
        onPressed: onSelected,
      ),
    );
  }
}
