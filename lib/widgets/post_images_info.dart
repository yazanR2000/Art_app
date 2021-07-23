import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
class PostImagesInfo extends StatefulWidget {
  final List images;

  PostImagesInfo(this.images);

  @override
  _PostImagesInfoState createState() => _PostImagesInfoState();
}

class _PostImagesInfoState extends State<PostImagesInfo> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: CarouselSlider.builder(
            carouselController: _controller,
            itemCount: widget.images.length,
            itemBuilder: (BuildContext context, int index, int pageViewIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                child: Image.network(
                  '${dotenv.env['IP_ADDRESS']}/${widget.images[index]['img'].toString().replaceAll('\\', '/')}',
                  fit: BoxFit.cover,
                ),
              );
            },
            options: CarouselOptions(
              aspectRatio: 1.4,
              viewportFraction: 1,
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
        Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: widget.images.asMap().entries.map((entry) {
            return GestureDetector(
              onTap: () => _controller.animateToPage(entry.key),
              child: Container(
                width: 60,
                height: 60,
                margin: EdgeInsets.symmetric(vertical: 2, horizontal: 4.0),
                child: Stack(
                  children: [

                    Container(
                      height: 60,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Image.network(
                          '${dotenv.env['IP_ADDRESS']}/${widget.images[entry.key]['img'].toString().replaceAll('\\', '/')}',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                        //shape: BoxShape.circle,
                        borderRadius: BorderRadius.circular(10),
                        color: entry.key == _current
                            ? Colors.transparent
                            : Colors.black26,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
