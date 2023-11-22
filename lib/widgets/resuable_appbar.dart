import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;

  final List<Widget>? actions;
  final Widget? leading;
  const ReusableAppBar(
      {super.key,
      required this.title,
      this.actions,
      this.leading,
      this.subtitle});

  @override
  Widget build(BuildContext context) {
    return AppBar(
        backgroundColor: const Color(0xFFEA5455),
        toolbarHeight: 240,
        elevation: 0,
        actions: actions,
        automaticallyImplyLeading: false,
        title: ListTile(
          title: Text(
            "Hi  $title !",
            style: GoogleFonts.sansita(fontSize: 20, color: Colors.white),
          ),
          subtitle: Text(
            subtitle.toString(),
            style: GoogleFonts.poppins(color: Colors.white),
          ),
          leading: leading,
        ));
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
