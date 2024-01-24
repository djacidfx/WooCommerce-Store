import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class ExpandText extends StatefulWidget {
  const ExpandText({Key? key, 
    this.labelHeader,
    this.desc,
    this.shortDesc,
  }) : super(key: key);

  final String? labelHeader;
  final String? desc;
  final String? shortDesc;

  @override
  _ExpandTextState createState() => _ExpandTextState();
}

class _ExpandTextState extends State<ExpandText> {
  bool descTextShowFlag = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.labelHeader!,
            style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                color: Colors.black, fontSize: 18, fontWeight: FontWeight.w500),
          ),
          HtmlWidget(
            descTextShowFlag ? widget.desc! : widget.shortDesc!,
            textStyle: const TextStyle(
          fontFamily: 'Baloo Da 2',
              color: Colors.black
            ),
          ),
          Align(
            child: InkWell(
              child: Text(
                descTextShowFlag ? "Short Description" : "Long Description",
                style: const TextStyle(
          fontFamily: 'Baloo Da 2',
                    color: Colors.red,
                    fontSize: 14,
                    fontWeight: FontWeight.w600),
              ),
              onTap: () {
                setState(() {
                  descTextShowFlag = !descTextShowFlag;
                });
              },
            ),
          )
        ],
      ),
    );
  }
}
