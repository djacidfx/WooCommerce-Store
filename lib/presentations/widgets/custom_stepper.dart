import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CustomStepper extends StatefulWidget {
  CustomStepper({
    Key? key,
    this.lowerLimit,
    this.upperLimit,
    this.stepValue,
    this.onChanged,
    required this.value
  }) : super(key: key);

  int? lowerLimit;
  int? upperLimit;
  int? stepValue;
  int value;
  ValueChanged<dynamic>? onChanged;

  @override
  _CustomStepperState createState() => _CustomStepperState();
}

class _CustomStepperState extends State<CustomStepper> {
  @override
  Widget build(BuildContext context) {
    return Container(
    height: 30,
    width: 110,
      decoration: const BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
            ),
            child: Center(
              child: IconButton(onPressed: () {
                setState(() {
                  widget.value = (widget.value == widget.lowerLimit ? widget.lowerLimit : widget.value -= widget.stepValue!)!;

                  widget.onChanged!(widget.value);
                });
              }, 
              icon: const Icon(Icons.remove, size: 18,)),
            ),
          ),
          const SizedBox(width: 10),
          Text(
              "${widget.value}",
              style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                  fontWeight: FontWeight.w600,
                  fontSize: 23,
                  ),
                  textAlign: TextAlign.center,
          ),
          const SizedBox(width: 10),
          Container(
            width: 30,
            height: 30,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              boxShadow: [
                  BoxShadow(
                    color: Colors.black,
                    blurRadius: 5.0, // soften the shadow
                    spreadRadius: 1.0, //extend the shadow
                    offset: Offset(
                      0.0, // Move to right 10  horizontally
                      1.0, // Move to bottom 10 Vertically
                    ),
                  )
                ],
            ),
            child: Center(
              child: IconButton(
                onPressed: () {
                  setState(() {
                  widget.value = (widget.value == widget.upperLimit ? widget.upperLimit : widget.value += widget.stepValue!)!;

                  widget.onChanged!(widget.value);
                });
                }, 
                icon: const Icon(Icons.add, size: 18,)),
            ),
          ),
        ],
      ),
    );
  }
}
