import 'package:flutter/widgets.dart';

import 'colors.dart';

class DialogAnimation {
  static Future openDialog(BuildContext context, Widget dialog) {
    return showGeneralDialog(
        barrierColor: HColors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: dialog,
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 200),
        barrierDismissible: true,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
}