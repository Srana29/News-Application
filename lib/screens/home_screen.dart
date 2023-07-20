import 'dart:convert';
import 'package:amplify_flutter/amplify_flutter.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:http/http.dart';
import 'package:newsapp/screens/category.dart';
import 'package:newsapp/screens/newview_screen.dart';
import 'package:newsapp/services/apis.dart';

import '../model/news_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  static const String routeName = "home";

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController searchController =  TextEditingController();
  List<NewsQueryModel> newsModelList = <NewsQueryModel>[];
  List<NewsQueryModel> newsModelListCarousel = <NewsQueryModel>[];
  List<String> navBarItem = [
    "Top News",
    "India",
    "Sports",
    "Finance",
    "Politics",
    "Entertainment"
  ];

  bool isLoading = true;
  getNewsByQuery(String query) async {
    Map element;
    int i=0;
    String url =
        "${APIs().baseUrl}everything?domains=$query&apiKey=${APIs().apikey}";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      // data["articles"].forEach((element)
      for(element in data["articles"]) {
        try{
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelList.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if(i==5){
            break;
          }
        }catch(e){safePrint(e);}
        //newsModelList.sublist(0,6);
      }
    });

  }





  getNewsOfIndia() async {
    Map element;
    int i=0;
    String url = "${APIs().baseUrl}top-headlines?country=in&category=business&apiKey=${APIs().apikey}";
    Response response = await get(Uri.parse(url));
    Map data = jsonDecode(response.body);
    setState(() {
      // data["articles"].forEach((element)
      for(element in data["articles"]) {
        try{
          i++;
          NewsQueryModel newsQueryModel = NewsQueryModel();
          newsQueryModel = NewsQueryModel.fromMap(element);
          newsModelListCarousel.add(newsQueryModel);
          setState(() {
            isLoading = false;
          });
          if(i==4){
            break;
          }

        }catch(e){safePrint(e);}
      }
    });

  }


  @override
  void initState() {
    super.initState();
    getNewsByQuery("aajtak.in");
    getNewsOfIndia();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("NEWS UPDATES"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              //Search Wala Container

              padding: const EdgeInsets.symmetric(horizontal: 8),
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
              decoration: BoxDecoration(
                  color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.black
                )
              ),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      if ((searchController.text).isEmpty) {
                        safePrint("Blank Search");
                      } else {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(query: searchController.text)));
                      }
                    },
                    child: Container(
                      margin: const EdgeInsets.fromLTRB(3, 0, 7, 0),
                      child: const Icon(
                        Icons.search,
                        color: Colors.blueAccent,
                      ),
                    ),
                  ),
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (value) {
                        if(value.isEmpty){
                          safePrint("Blank Search");
                        }
                        else{
                          Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(query: value)));
                        }
                      },
                      decoration: const InputDecoration(
                          border: InputBorder.none, hintText: "Search"),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
                height: 50,
                child: ListView.builder(
                    shrinkWrap: true,
                    scrollDirection: Axis.horizontal,
                    itemCount: navBarItem.length,
                    itemBuilder: (context, index) {
                      return InkWell(
                        onTap: () {
                         Navigator.push(context, MaterialPageRoute(builder: (context)=> CategoryScreen(query: navBarItem[index])));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          margin: const EdgeInsets.symmetric(horizontal: 5),
                          decoration: BoxDecoration(
                              color: Colors.blueAccent,
                              borderRadius: BorderRadius.circular(15)),
                          child: Center(
                            child: Text(navBarItem[index],
                                style: const TextStyle(
                                    fontSize: 19,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold)),
                          ),
                        ),
                      );
                    })),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 15),
              child: isLoading ? const SizedBox(height:200,child: Center(child: CircularProgressIndicator())) :
              CarouselSlider(
                options: CarouselOptions(
                    height: 200, autoPlay: true, enlargeCenterPage: true),
                items: newsModelListCarousel.map((instance) {
                  return Builder(builder: (BuildContext context) {
                    try{
                      return InkWell(
                        onTap: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>NewsViewScreen(instance.newsUrl)));
                        },
                        child: Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)
                            ),
                            child : Stack(
                                children : [
                                  ClipRRect(
                                      borderRadius : BorderRadius.circular(10),
                                      child : Image.network(instance.newsImg , fit: BoxFit.fitHeight, width: double.infinity,)
                                  ) ,
                                  Positioned(
                                      left: 0,
                                      right: 0,
                                      bottom: 0,
                                      child: Container(

                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            gradient: LinearGradient(
                                                colors: [
                                                  Colors.black12.withOpacity(0),
                                                  Colors.black
                                                ],
                                                begin: Alignment.topCenter,
                                                end: Alignment.bottomCenter
                                            )
                                        ),
                                        child : Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 5 , vertical: 10),
                                            child:Container( margin: const EdgeInsets.symmetric(horizontal: 10), child: Text(instance.newsHead , style: const TextStyle(fontSize: 18 , color: Colors.white , fontWeight: FontWeight.bold),))
                                        ),
                                      )
                                  ),
                                ]
                            )
                        ),
                      );
                    }catch(e){safePrint(e); return Container();}
                  });
                }).toList(),
              ),
            ),
            Column(
              children: [
                Container(
                  margin : const EdgeInsets.fromLTRB(15, 25, 0, 0),
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Text("LATEST NEWS " , style: TextStyle(fontWeight: FontWeight.bold , fontSize: 28
                      ),),
                    ],
                  ),
                ),
                isLoading ?  SizedBox(height:MediaQuery.of(context).size.height-450,child: const Center(child: CircularProgressIndicator())) :  ListView.builder(
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
                                                Text(newsModelList[index].newsDes.length > 50 ? "${newsModelList[index].newsDes.substring(0,55)}...." : newsModelList[index].newsDes , style: const TextStyle(color: Colors.white , fontSize: 12)
                                                  ,)
                                              ],
                                            )))
                                  ],
                                )),
                          ),
                        );
                      }catch(e){safePrint(e); return Container();}
                    }),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(onPressed: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => CategoryScreen(query: "LATEST NEWS")));
                      }, child: const Text("SHOW MORE")),
                    ],
                  ),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}