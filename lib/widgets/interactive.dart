import 'package:flutter/material.dart';

class Interactive extends StatefulWidget {
  final String image;

  Interactive(this.image);

  @override
  _InteractiveState createState() => _InteractiveState();
}

class _InteractiveState extends State<Interactive> {
  final TransformationController _transformationController = new TransformationController();
  @override
  Widget build(BuildContext context) {
    return InteractiveViewer(
      transformationController: _transformationController,
      minScale: 1.0,
      maxScale: 2.0,
      onInteractionEnd: (details){
        setState(() {
          _transformationController.toScene(Offset.zero);
        });
      },
      child: Container(
        margin: EdgeInsets.only(right: 10),
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          child: Image.network(
            widget.image,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
