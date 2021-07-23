import 'package:flutter/material.dart';

class ShowAllArts extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: EdgeInsets.all(10),
      sliver: SliverList(
        delegate: SliverChildListDelegate(
          [
            Divider(
              color: Colors.grey,
            ),
//            Row(
//              mainAxisAlignment: MainAxisAlignment.spaceBetween,
//              crossAxisAlignment: CrossAxisAlignment.center,
//              children: [
//                Text(
//                  'Nature Arts',
//                  style: TextStyle(color: Colors.black),
//                ),
//                SizedBox(
//                  width: 5,
//                ),
//                Expanded(
//                  child: Divider(
//                    height: 10,
//                    color: Colors.grey,
//                  ),
//                ),
//                TextButton(
//                  style: TextButton.styleFrom(
//                    primary: Colors.black,
//                  ),
//                  onPressed: () {},
//                  child: Row(
//                    crossAxisAlignment: CrossAxisAlignment.center,
//                    children: [
//                      Text(
//                        'Show all',
//                        style: TextStyle(fontSize: 10),
//                      ),
//                      Icon(
//                        Icons.keyboard_arrow_right,
//                        size: 15,
//                      ),
//                    ],
//                  ),
//                ),
//              ],
//            )
          ],
        ),
      ),
    );
  }
}
