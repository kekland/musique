import 'dart:math' as math;

import 'package:flutter/material.dart';

class SeparatedSliverChildBuilderDelegate extends SliverChildBuilderDelegate {
  SeparatedSliverChildBuilderDelegate({
    required Widget Function(BuildContext context, int index) itemBuilder,
    required Widget Function(BuildContext context, int index) separatorBuilder,
    required int? itemCount,

    super.addAutomaticKeepAlives,
    super.addRepaintBoundaries,
    super.addSemanticIndexes,
  }) : super(
         (BuildContext context, int index) {
           final int itemIndex = index ~/ 2;
           final Widget? widget;

           if (index.isEven) {
             widget = itemBuilder(context, itemIndex);
           } else {
             widget = separatorBuilder(context, itemIndex);
           }

           return widget;
         },
         childCount: itemCount == null ? null : math.max(0, itemCount * 2 - 1),
         semanticIndexCallback: (Widget _, int index) {
           return index.isEven ? index ~/ 2 : null;
         },
       );
}
