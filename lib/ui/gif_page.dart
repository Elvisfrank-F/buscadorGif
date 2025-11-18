import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';


class GifPage extends StatelessWidget {


  final Map _gifData;

  GifPage(this._gifData);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_gifData["title"],
        style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.black,
        iconTheme: IconThemeData(color: Colors.white),

        actions: [
          IconButton(icon: Icon(Icons.share),
            onPressed: (){
             SharePlus.instance.share(
               ShareParams(text: _gifData["images"]["fixed_height"]["url"])
             );
            }
          )
        ],

      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Image.network(_gifData["images"]["fixed_height"]["url"]),
      )
    );
  }
}
