import 'package:flutter/material.dart';
import 'package:gomsql/profile_page.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  Future<List> getData() async {

    var urlString = "https://fakestoreapi.com/products?limit=5";
    var url = Uri.parse(urlString);
    var response = await http.get(url);

    print(response.statusCode);
    print(response.body);
    List datas = jsonDecode(response.body);

    return datas;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text("Welcome"),
          actions: [
            IconButton(onPressed: (){
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
                icon: Icon(Icons.person))
          ],
        ),
        body: FutureBuilder(
          future: getData(),
          builder: (BuildContext context,AsyncSnapshot snapshot)
          {
            if (snapshot.hasData){

              List datas = snapshot.data;
              return Center(
                child: ListView.builder(
                    itemCount: datas.length,
                    itemBuilder:(BuildContext context, index){
                      var singleData = datas[index];
                      return Container(
                        padding: EdgeInsets.all(20),
                        child: Column(
                          children: [
                            SizedBox(height: 20,),
                            Center(
                              child: Text(singleData["title"].toString(),
                                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),),
                            ),
                            SizedBox(height: 15,),
                            Row(
                              children: [
                                Container( height: 120, width: 100,
                                    child: Image.network('${datas[index]['image']}')
                                ),
                                SizedBox(width: 15,),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Price: ', style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.green
                                        ),),
                                        Text(singleData["price"].toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Category: ', style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.green
                                        ),),
                                        Text(singleData["category"].toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Rating: ', style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.green
                                        ),),
                                        Text(singleData["rating"]['rate'].toString()),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Count: ', style: TextStyle(
                                            fontWeight: FontWeight.bold, color: Colors.green
                                        ),),
                                        Text(singleData["rating"]['count'].toString()),
                                      ],
                                    ),
                                  ],
                                )
                              ],
                            ),
                            SizedBox(height: 20,),

                            Text(singleData["description"].toString(),
                              style: TextStyle(fontSize: 15, fontStyle: FontStyle.italic),),
                          ],
                        ),
                      );
                    }),
              );
            }
            else {
              return Center(child: Text("Failure"));
            }
          },
        )
    );
  }
}
