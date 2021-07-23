import 'package:artwork_app/providers/state_management/is_post_center.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import '../providers/state_management/post_like.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class PostImages extends StatefulWidget {
  final List images;
  final int index;
  final String postId;

  PostImages(this.images, this.index, this.postId);

  @override
  _PostImagesState createState() => _PostImagesState();
}

class _PostImagesState extends State<PostImages> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _controller,
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return  Container(
                  margin: EdgeInsets.only(right: 10),
                  //alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                    child:
                        widget.images[index]['img'].toString().contains('mp4')
                            ? Video(
                                widget.images[index]['img']
                                    .toString()
                                    .replaceAll('\\', '/'),
                                widget.index,
                                _current == index,
                                widget.postId)
                            : FadeInImage(
                                placeholder: NetworkImage(
                                    'https://t4.ftcdn.net/jpg/02/07/87/79/360_F_207877921_BtG6ZKAVvtLyc5GWpBNEIlIxsffTtWkv.jpg'),
                                image: NetworkImage(
                                  '${dotenv.env['IP_ADDRESS']}/${widget.images[index]['img'].toString().replaceAll('\\', '/')}',
                                ),
                                fit: BoxFit.cover,
                              ),
                  ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 1.5,
              viewportFraction: 0.95,
              autoPlay: false,
              enableInfiniteScroll: false,
              scrollDirection: Axis.horizontal,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 8,
                height: 8,
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: (Theme.of(context).brightness == Brightness.dark
                          ? Colors.white
                          : Colors.black)
                      .withOpacity(_current == entry.key ? 0.9 : 0.1),
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}

class Video extends StatefulWidget {
  final String _path;
  final int index;
  final bool isActive;
  final String postId;

  Video(this._path, this.index, this.isActive, this.postId);

  @override
  _VideoState createState() => _VideoState();
}

class _VideoState extends State<Video> {
  VideoPlayerController _controller;

  @override
  void initState() {
    _controller = VideoPlayerController.network(
      '${dotenv.env['IP_ADDRESS']}/${widget._path}',
    )..addListener(()=>setState((){}))
      ..setLooping(true)
      ..initialize().then(
        (_) async {
          _controller.pause();
          setState(() {});
        },
      );
    super.initState();
  }


  @override
  Future<void> dispose() async {
    super.dispose();
    await _controller.dispose();
    _controller.removeListener(() { });

  }



  @override
  Widget build(BuildContext context) {
    return VisibilityDetector(
          key: Key('${widget.index}'),
          onVisibilityChanged: (value) async {
            var v = value.visibleFraction * 100;
            //print('${widget.index} : ' + v.toInt().toString());
            if (v.toInt() == 100) {
              final post = Provider.of<PostCenter>(context, listen: false);
              if (!post.isPause) {
                post.onClick(true, widget.index);
                _controller.play();
              }
            } else {
              _controller.pause();
              _controller.seekTo(Duration.zero);
            }
          },
          child: GestureDetector(
            onDoubleTap: () {
              print('yazan');
              Provider.of<PostLike>(context, listen: false)
                  .doubleTap(widget.postId);
            },
            onTap: () async {
              final post = Provider.of<PostCenter>(context, listen: false);
              if (_controller.value.isPlaying) {
                post.onClick(false, widget.index);
                post.pause(true);
                await _controller.pause();
              } else {
                post.onClick(true, widget.index);
                post.pause(false);
                await _controller.play();
              }
            },
            child: Stack(
              children: [
                _controller.value.isInitialized
                    ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller))
                    : Container(),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Consumer<PostCenter>(
                    builder: (ctx, post, _) {
                      print(post.index);
                      return Icon(
                        post.index == widget.index && post.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        color: Colors.white,
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

    );
  }
}
