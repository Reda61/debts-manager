import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

class clsCustomSearchBar extends StatelessWidget {
  final void Function()? onSearchTap;
  final void Function(String)? onChanged;
  final TextEditingController? textController;
  clsCustomSearchBar({
    super.key,
    this.onSearchTap,
    this.onChanged,
    this.textController,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      onChanged: onChanged,
      onTap: onSearchTap,
      controller: textController,
      decoration: InputDecoration(
        hintText: 'search'.tr(),
        filled: true,
        // fillColor: Color.fromARGB(255, 156, 224, 147),
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 16),
      ),
    );
  }
}
