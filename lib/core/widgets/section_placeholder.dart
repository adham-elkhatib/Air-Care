//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependencies Imports
//t3 Services
//t3 Models
//t1 Exports
class SectionPlaceholder extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;

  //!SECTION
  //
  const SectionPlaceholder({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    //SECTION - Build Setup
    //t2 -Values
    //double w = MediaQuery.of(context).size.width;
    //double h = MediaQuery.of(context).size.height;
    //t2 -Values
    //
    //t2 -Widgets
    //t2 -Widgets
    //!SECTION

    //SECTION - Build Return
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      clipBehavior: Clip.antiAlias,
      decoration: ShapeDecoration(
        shape: RoundedRectangleBorder(
          side: const BorderSide(width: 2, color: Color(0xFFE0E0E0)),
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        title,
        softWrap: true,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 14,
          fontFamily: 'SF Pro Text',
          fontWeight: FontWeight.w400,
          letterSpacing: -0.24,
        ),
      ),
    );
    //!SECTION
  }
}
