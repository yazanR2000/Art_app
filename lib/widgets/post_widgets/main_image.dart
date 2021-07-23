import 'dart:io';

import 'package:artwork_app/widgets/profile_widgets/gallery.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../providers/state_management/post.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class MainImage extends StatefulWidget {
  final BoxConstraints _constraints;

  MainImage(this._constraints);

  @override
  _MainImageState createState() => _MainImageState();
}

class _MainImageState extends State<MainImage> {
  VideoPlayerController _controller = VideoPlayerController.asset('');

  bool _isImage = true;
  final _picker = ImagePicker();
  File _file;

  Future _pickImage() async {
    try {
      PickedFile image = _isImage
          ? await _picker.getImage(
              source: ImageSource.gallery,
              imageQuality: 80,

            )
          : await _picker.getVideo(
              source: ImageSource.gallery,
              maxDuration: const Duration(seconds: 10),
            );
      print(image.path);
      if (!_isImage) {
        _controller = VideoPlayerController.file(
          File(image.path),
        )
          ..addListener(() => setState(() {}))
          ..setLooping(true)
          ..initialize().then((_) {
            _controller.play();
            setState(() {});
          });
      }
      setState(() {
        _file = File(image.path);
      });
    } catch (err) {
      print(err);
      throw err;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mainImage = Provider.of<Post>(context);
    return Stack(
      children: [
        GestureDetector(
          onTap: () async {
            try {
              await _pickImage();
              mainImage.changeMainImage(_file);
            } catch (err) {
              throw err;
            }
          },
          child: Container(
            height: widget._constraints.maxHeight * 0.3,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(15),
            ),
            child: mainImage.post['main_image'] == null
                ? Center(
                    child: Icon(
                      Icons.add,
                      color: Colors.grey,
                      size: 30,
                    ),
                  )
                : _isImage
                    ? ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: Image.file(
                          mainImage.post['main_image'],
                          fit: BoxFit.cover,
                        ),
                      )
                    : AspectRatio(
                        aspectRatio: _controller.value.aspectRatio,
                        child: VideoPlayer(_controller),
                      ),
          ),
        ),
        if (_file != null)
          Positioned(
            top: 0,
            left: 0,
            child: IconButton(
              onPressed: (){
                setState(() {
                  mainImage.changeMainImage(null);
                  _file = null;
                  _controller.pause();
                });
              },
              color: Colors.grey,
              icon:Icon(Icons.cancel),
            ),
          ),
        if (_file == null)
          Positioned(
            bottom: 5,
            right: 5,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isImage = true;
                    });
                  },
                  icon: Icon(Icons.image),
                  color: _isImage ? Colors.blue : Colors.black,
                ),
                SizedBox(
                  width: 10,
                ),
                IconButton(
                  onPressed: () {
                    setState(() {
                      _isImage = false;
                    });
                  },
                  icon: Icon(Icons.play_circle_fill),
                  color: !_isImage ? Colors.blue : Colors.black,
                ),
              ],
            ),
          ),
      ],
    );
  }
}
