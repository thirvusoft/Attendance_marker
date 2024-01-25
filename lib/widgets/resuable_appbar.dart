import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ReusableAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final String? subtitle;
  final TabBar? tabBar;
  final List<Widget>? actions;
  final Widget? leading;
  const ReusableAppBar({
    required this.title,
    this.actions,
    this.leading,
    this.subtitle,
    this.tabBar,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFEA5455),
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
      ),
      bottom: tabBar != null
          ? PreferredSize(
              preferredSize: Size.fromHeight(30), // Adjust the height as needed
              child: tabBar!,
            )
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
