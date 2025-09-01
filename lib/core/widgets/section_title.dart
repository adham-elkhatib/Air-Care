//t2 Core Packages Imports
import 'package:flutter/material.dart';

//t2 Dependancies Imports
//t3 Services
//t3 Models
//t1 Exports
class SectionTitle extends StatelessWidget {
  //SECTION - Widget Arguments
  final String title;
  final Function? onPressed;

  //!SECTION
  //
  const SectionTitle({super.key, required this.title, this.onPressed});

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
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 24,
            fontFamily: 'SF Pro Display',
            fontWeight: FontWeight.w500,
            letterSpacing: -0.48,
          ),
        ),
        (onPressed != null)
            ? IconButton(
                onPressed: () => onPressed!(),
                icon: const Icon(Icons.add, size: 24),
              )
            : Container(),
      ],
    );
    //!SECTION
  }
}
