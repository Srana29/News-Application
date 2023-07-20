import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';

import '../model/news_model.dart';
import '../services/apis.dart';
import 'newview_screen.dart';

// ignore: must_be_immutable
class CategoryScreen extends StatefulWidget {

  String query;
  CategoryScreen({super.key, required this.query});

  @override
  State<CategoryScreen> createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {

  bool isLoading = true;

  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];

  getNewsByQuery(String query) async {
    String url="";

    if(query=="Top News"){
      url = "https://newsapi.org/v2/top-headlines?country=in&apiKey=${APIs().apikey}";

    }else if(query=="India"){
      url="${APIs().baseUrl}top-headlines?country=in&apiKey=${APIs().apikey}";
    }else  if (query=="Finance"){
      url = "${APIs().baseUrl}everything?q=finance&from=2023-07-01&to=2023-07-20&sortBy=popularity&apiKey=${APIs().apikey}";
    }else if(query=="Politics"){
      url="${APIs().baseUrl}everything?q=politics&from=2023-07-01&to=2023-07-20&sortBy=popularity&apiKey=${APIs().apikey}";
    } else if(query=="Sports"){
      url="${APIs().baseUrl}top-headlines?country=in&category=sports&apiKey=${APIs().apikey}";
    }else if(query=="Entertainment"){
      url="${APIs().baseUrl}top-headlines?country=in&category=entertainment&apiKey=${APIs().apikey}";
    }else if(query=="LATEST NEWS"){
      url="${APIs().baseUrl}everything?domains=aajtak.in&apiKey=${APIs().apikey}";
    }else{
      url="${APIs().baseUrl}everything?q=$query&from=2023-07-01&to=2023-07-20&sortBy=popularity&apiKey=${APIs().apikey}";
    }


    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      data["articles"].forEach((element) {
        try{
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
        }catch(e){
          safePrint(e);
        }
      });
    });

  }

  @override
  void initState() {
    super.initState();
    getNewsByQuery(widget.query);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NEWS UPDATES"),
        centerTitle: true,
      ),
      body:  SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin : const EdgeInsets.fromLTRB(15, 10, 0, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 12,),

                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Text(widget.query, style: const TextStyle(  fontSize: 39
                    ),),
                  ),
                ],
              ),
            ),
            isLoading ?  SizedBox(height:MediaQuery.of(context).size.height-450,child: const Center(child: CircularProgressIndicator())) :
            ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: newsModelList.length,
                itemBuilder: (context, index) {
                  try{
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                      child: InkWell(
                        onTap: () {
                          if(newsModelList[index].newsUrl!=null){
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsViewScreen(newsModelList[index].newsUrl)));
                          }else{
                            Fluttertoast.showToast(
                                msg: "Data not available",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.redAccent,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }

                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            elevation: 1.0,
                            child: Stack(
                              children: [
                                ClipRRect(
                                    borderRadius: BorderRadius.circular(15),
                                    child: Image.network(newsModelList[index].newsImg ,fit: BoxFit.fitHeight, height: 230,width: double.infinity, )),

                                Positioned(
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(15),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                            )
                                        ),
                                        padding: const EdgeInsets.fromLTRB(15, 15, 10, 8),
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              newsModelList[index].newsHead,
                                              style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,50)}...." : newsModelList[index].newsDes , style: const TextStyle(color: Colors.white , fontSize: 12))
                                          ],
                                        )))
                              ],
                            )),
                      ),
                    );
                  }catch(e){safePrint(e); return Container();}
                }),
          ],
        ),
      ),
    );
  }
}