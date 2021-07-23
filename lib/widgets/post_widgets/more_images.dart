import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:provider/provider.dart';
import '../../providers/state_management/post.dart';
class MoreImages extends StatefulWidget {
  final BoxConstraints _constraints;

  MoreImages(this._constraints);

  @override
  _MoreImagesState createState() => _MoreImagesState();
}

class _MoreImagesState extends State<MoreImages> {
  List<File> _imageFiles = List.filled(3, null);

  final _picker = ImagePicker();
  File _file;

  Future _pickImage() async {
    _file = null;
    try {
      PickedFile image = await _picker.getImage(
        source: ImageSource.gallery,
        imageQuality: 80
      );
      _file = File(image.path);
    } catch (err) {
      print(err);
//      ScaffoldMessenger.of(context).hideCurrentSnackBar();
//      ScaffoldMessenger.of(context).showSnackBar(
//        SnackBar(
//          backgroundColor: Colors.red,
//          duration: Duration(milliseconds: 2000),
//          content: Text(
//            err.toString(),
//          ),
//        ),
//      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final moreImages = Provider.of<Post>(context);
    return ListView(
      scrollDirection: Axis.horizontal,
      children: List.generate(
        3,
        (index) => GestureDetector(
          onTap: () async {
            try {
              await _pickImage ();
              moreImages.changeMoreImages (_file, index );
            } catch (err){
              print(err);
            }
          },
          child: Container(
            height: widget._constraints.maxHeight * 0.1,
            width: widget._constraints.maxWidth * 0.2,

            margin: EdgeInsets.only(right: 10),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: widget._constraints.maxHeight * 0.1,
                  width: widget._constraints.maxWidth * 0.2,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: moreImages.moreImages[index] != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.file(
                            moreImages.moreImages[index],
                            fit: BoxFit.cover,
                          ),
                        )
                      : Center(
                          child: Icon(
                            Icons.add,
                            color: Colors.grey,
                          ),
                        ),
                ),
                if(moreImages.moreImages[index] != null)
                Positioned(
                  top: -20,
                  left: -20,
                  child: IconButton(
                    onPressed: (){
                      moreImages.changeMoreImages(null, index);
                    },
                    icon: Icon(
                      Icons.cancel,
                      color: Colors.grey,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
