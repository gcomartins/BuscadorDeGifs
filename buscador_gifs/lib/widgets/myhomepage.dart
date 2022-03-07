import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String? _search = "dogs";

  final int _offset = 75;

  Future<Map> _getGifs() async {
    Response response;

    // _search = "dogs";

    Dio dio = Dio();

    if (_search == null) {
      response = await dio.get(
          "https://api.giphy.com/v1/gifs/trending?api_key=lSI7TdrLTG3OJysfQwgHKNhKYtSwLjLb&limit=25&rating=g");
    } else {
      response = await dio.get(
          "https://api.giphy.com/v1/gifs/search?api_key=lSI7TdrLTG3OJysfQwgHKNhKYtSwLjLb&q=$_search&limit=25&offset=$_offset&rating=g&lang=en");
    }

    return json.decode(response.data);
  }

  @override
  void initState() {
    super.initState();

    _getGifs().then((map) {
      print(map);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(
            "https://developers.giphy.com/static/img/dev-logo-lg.gif"),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                labelText: "Pesquise aqui",
                labelStyle: TextStyle(color: Colors.white),
                border: OutlineInputBorder(),
              ),
              style: TextStyle(color: Colors.white, fontSize: 18),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return Container(
                      width: 200,
                      height: 200,
                      alignment: Alignment.center,
                      child: const CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        strokeWidth: 5.0,
                      ),
                    );
                  default:
                    if (snapshot.hasError) {
                      return Container();
                    } else {
                      return _createGifTable(context, snapshot);
                    }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
  return GridView.builder(
    padding: const EdgeInsets.all(10),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 10,
      mainAxisSpacing: 10,
    ),
    itemCount: 4,
    itemBuilder: (context, index) {
      return GestureDetector(
        child: Image.network(
          snapshot.data[index].images.fixed_height.url,
          height: 300,
          fit: BoxFit.cover,
        ),
      );
    },
  );
}
