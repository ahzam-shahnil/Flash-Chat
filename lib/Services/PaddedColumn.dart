import 'package:flutter/material.dart';

class PaddedCoulmn extends StatefulWidget {
  final List<Widget> children;
  final MainAxisAlignment mainAxisAlignment;

  const PaddedCoulmn({@required this.children, this.mainAxisAlignment});
  @override
  _PaddedCoulmnState createState() => _PaddedCoulmnState();
}

class _PaddedCoulmnState extends State<PaddedCoulmn> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.0, vertical: 11),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: widget.mainAxisAlignment,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: widget.children,
        ),
      ),
    );
  }
}
