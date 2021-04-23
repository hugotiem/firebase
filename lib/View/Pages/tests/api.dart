import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:google_maps_flutter/google_maps_flutter.dart';

import 'package:flutter/foundation.dart';

class API extends StatefulWidget {
  @override
  _APIState createState() => _APIState();
}

class _APIState extends State<API> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children: [
          TextField(
            decoration: InputDecoration(  
              hintText: 'recherche'
            ),
          ),
          Container(
            height: 300,
            child: GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: CameraPosition(  
                target: LatLng(41.8781, -87.6298)
              ),
            ),
          )
      ], 
      )
    );
}

  // FutureBuilder<dynamic> buildFutureBuilder() {
  //   return FutureBuilder(
  //     future: null,
  //     builder: (context, snapshots) {
  //       if (snapshots.hasData) {
  //         return Container(
  //           child: ListView.builder(
  //             itemCount: snapshots.data.length,
  //             itemBuilder: (context, index) {
  //               return Container(
  //                 child: Text("${snapshots.data[index].getTitle}"),
  //               );
  //             },
  //           ),
  //         );
  //       } else if (snapshots.hasError) {
  //         return Center(
  //           child: Container(
  //             child: Text("Une erreur est survenue. Veuillez réessayer"),
  //           ),
  //         );
  //       } else {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       }
  //     },
  //   );
  // }

//   Future<List<Post>> getPosts() async {
//     http.Response res = await http.post(
//         Uri.parse("https://countriesnow.space/api/v0.1/countries/cities"),
//         body: {"country": "france"});

//     print(res.body);

//     if (res.statusCode == 200) {
//       Map<String, dynamic> map = json.decode(res.body);
//       List<dynamic> data = map["data"];
//       for (int i = 0; i < data.length; i++) {
//         print(data[i]);
//       }
//       // List<Post> posts =
//       //     data.map((dynamic item) => Post.fromJson(item)).toList();
//       // return posts;
//     }
//     return null;
//   }
// }

// class Post {
//   final String title;

//   Post({
//     @required this.title,
//   });

//   String get getTitle {
//     return this.title;
//   }

//   factory Post.fromJson(Map<String, dynamic> json) {
//     return Post(
//       title: json["properties"]["label"] as String,
//     );
//   }
}
