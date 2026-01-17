// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, use_key_in_widget_constructors, unnecessary_import

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import 'package:flutter/src/foundation/key.dart';
//import 'package:flutter/src/widgets/framework.dart';

class Poster extends StatelessWidget {
  //const Poster({Key? key}) : super(key: key);
  String imageLink;
  Poster(this.imageLink);

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageLink,
      placeholder: (context, url) {
        return Center(child: CircularProgressIndicator());
      },
      errorWidget: (context, url, error) {
        return Center(child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const [
            Text('error loading poster',style: TextStyle(fontSize: 10), ),
            Icon(Icons.error),
          ],
        ));
      },
    );
    // AssetImage assetImage = AssetImage('images/artificial.png' );
    //Image image = Image(image: assetImage,);
    //  try{
    //return Image.network(imageLink);
    // } catch return Image.asset(null);
  }
}
