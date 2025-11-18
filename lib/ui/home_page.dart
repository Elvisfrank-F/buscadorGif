import 'package:flutter/material.dart';
import 'package:gifs/ui/gif_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  String _search="";
  int _set =19;
  Future<Map> _getGifs() async{
    http.Response response;

    if(_search.isEmpty){
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/trending?api_key=fE32klrG2b2FNVw9pWJdUSgupPtP4AdE&limit=20&offset=75&rating=g&bundle=messaging_non_clips"));
    }
    else {
      response = await http.get(Uri.parse("https://api.giphy.com/v1/gifs/search?api_key=fE32klrG2b2FNVw9pWJdUSgupPtP4AdE&q=$_search&limit=20&offset=$_set&rating=g&lang=en&bundle=messaging_non_clips"));
    }
    return json.decode(response.body);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     appBar: AppBar(
       backgroundColor: Colors.black,
       title: Image.network("https://developers.giphy.com/branch/master/static/header-logo-0fec0225d189bc0eae27dac3e3770582.gif"),
       centerTitle: true,
     ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise Aqui!",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder()
                ),
                  style: TextStyle(color: Colors.white, fontSize: 18.0),
              textAlign: TextAlign.center,

              onSubmitted: (text){
                setState(() {
                  _search = text;
                });

              },
            ),
          ),
          Expanded(
              child: FutureBuilder(future: _getGifs(),
                  builder: (context, snapshot){
                switch(snapshot.connectionState){
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,

                       alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                    )
                    );

                  default:
                    if(snapshot.hasError) return Container();
                    else return _createGifTable(context, snapshot);
                }
                return Text("");
                  }
                  ))
        ],
      )
    );
  }

  int _getCount(List data){
    if(_search.isEmpty){
      return data.length;
    }
    else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot){

    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0
        ),
         itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {

          if(_search == "" || _search.isEmpty || index < snapshot.data["data"].length-1) {
            return GestureDetector(
              onTap: () {
                Navigator.push(context,
                MaterialPageRoute(builder: (context) => GifPage(snapshot.data["data"][index])));
              },
                child: FadeInImage.memoryNetwork(placeholder: kTransparentImage, image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
                height: 300,
                fit: BoxFit.cover
                ),

                onLongPress: () {
                SharePlus.instance.share(
                  ShareParams(text: snapshot.data["data"][index]["images"]["fixed_height"]["url"])
                );
                },


            );
          }
          else if(index == snapshot.data["data"].length-1){
            return Container(
              alignment: Alignment.center,
              child: GestureDetector(
                onTap: (){
                  setState(() {
                    _set += 19;
                  });

                },
                child: Column(
                  //mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.add, color: Colors.white, size: 70.0),
                    Text("Carregar mais......",
                    style: TextStyle(color: Colors.white, fontSize: 22.0))
                  ],
                ),
              )
            );
          }
        }
    );
  }

}
