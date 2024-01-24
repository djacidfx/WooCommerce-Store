import 'package:flutter/material.dart';

class ProgressModal extends StatelessWidget {
  final Widget child;
  final bool inAsyncCall;
  final double opacity;

  const ProgressModal({
    Key? key,
    required this.child,
    required this.inAsyncCall,
    this.opacity = 0.3,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> widgetList = <Widget>[];
    widgetList.add(child);
    if (inAsyncCall) {
      final modal = SizedBox(
          height: MediaQuery.of(context).size.height,
          child: Stack(children: [
            Opacity(
              opacity: opacity,
              child: const ModalBarrier(dismissible: false, color: Colors.red),
            ),
            const Center(
              child: CircularProgressIndicator(
                color: Colors.red,
              ),
            )
          ]));
      widgetList.add(modal);
    }
    return Stack(
      children: widgetList,
    );
  }
}
