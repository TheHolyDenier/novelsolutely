import 'package:flutter/material.dart';

//LIBRARIES

//SCREENS && WIDGETS
import './header_widget.dart';

//MODELS
import '../../models/generic.dart';


//UTILS
import '../../utils/dimens.dart';

class SummaryInfoWidget extends StatelessWidget {
  final Generic generic;
  final Size size;


  SummaryInfoWidget(this.generic, this.size);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        HeaderWidget(
          name: generic.name,
          images: generic.imagePath ?? null,
          height: size.height / 3,
          width: size.width,
        ),
        Container(
          margin: EdgeInsets.symmetric(
            vertical: Dimens.small_vertical_margin,
            horizontal: Dimens.horizontal_margin,
          ),
          child: Text(
            generic.summary,
          ),
        )
      ],
    )
    ,
    ;
  }
}
