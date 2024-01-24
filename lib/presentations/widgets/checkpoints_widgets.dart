import 'package:flutter/material.dart';

class CheckPoints extends StatelessWidget {
  const CheckPoints(
      {Key? key,
      this.checkedTill = 1,
      this.checkPoints,
      this.checkPointFilledColor})
      : super(key: key);

  final int checkedTill;
  final List<String>? checkPoints;
  final Color? checkPointFilledColor;

  final double circleDia = 32;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (c, s) {
      final double cWidth = ((s.maxWidth - (32.0 * (checkPoints!.length + 1))) /
          (checkPoints!.length - 1));

      return SizedBox(
        height: 56,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                    children: checkPoints!.map((e) {
                  int index = checkPoints!.indexOf(e);
                  return SizedBox(
                    height: circleDia,
                    child: Row(
                      children: [
                        Container(
                          width: circleDia,
                          padding: const EdgeInsets.all(4),
                          child: const Icon(
                            Icons.done,
                            color: Colors.white,
                            size: 18,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: index <= checkedTill
                                ? checkPointFilledColor
                                : checkPointFilledColor!.withOpacity(0.2),
                          ),
                        ),
                        index != (checkPoints!.length - 1)
                            ? Container(
                                color: index < checkedTill
                                    ? checkPointFilledColor
                                    : checkPointFilledColor!.withOpacity(0.2),
                                height: 4,
                                width: cWidth,
                              )
                            : Container()
                      ],
                    ),
                  );
                }).toList())),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: checkPoints!.map((e) {
                    return Text(
                      e,
                      style: const TextStyle(
                          fontFamily: 'Baloo Da 2',
                          fontWeight: FontWeight.w500),
                    );
                  }).toList()),
            )
          ],
        ),
      );
    });
  }
}
