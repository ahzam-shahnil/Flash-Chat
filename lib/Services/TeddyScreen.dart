import 'package:flare_flutter/flare_actor.dart';
import 'package:flutter/material.dart';

class TeddyContainer extends StatelessWidget {
  const TeddyContainer({
    Key key,
    @required this.teddyAnimType,
  }) : super(key: key);

  final String teddyAnimType;

  @override
  Widget build(BuildContext context) {
    return Hero(
      tag: 'logo',
      child: ClipOval(
        clipBehavior: Clip.antiAlias,
        child: Container(padding: EdgeInsets.symmetric(horizontal: 15),
          color: Colors.black38,
          width: MediaQuery.of(context).size.width * 0.2,
          height: MediaQuery.of(context).size.height * 0.41,
          child: new FlareActor(
            "images/Teddy.flr",
            alignment: Alignment.center,
            fit: BoxFit.contain,
            animation: teddyAnimType,
            artboard: "Artboard",
          ),
        ),
      ),
    );
  }
}
