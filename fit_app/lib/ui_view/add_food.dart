import 'dart:async';
import 'dart:convert';

import 'package:fit_app/fitness_app_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<List<FoodGen>> fetchDishes(http.Client client) async {
  final response = await client.get(
      'https://api.nal.usda.gov/fdc/v1/foods/list?dataType=Foundation,SR%20Legacy&pageSize=200&api_key=h8GO51P1H4e0dfvWOmVsu75dafKwNqJk41kf0HMD');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseDishes, response.body);
}
Future<List<FoodGen>> fetchQueryDish(http.Client client, String query) async {
  final response = await client.get(
      'https://api.nal.usda.gov/fdc/v1/foods/search/?query=$query&api_key=h8GO51P1H4e0dfvWOmVsu75dafKwNqJk41kf0HMD');

  // Use the compute function to run parsePhotos in a separate isolate.
  return compute(parseDishes, response.body);
}

// A function that converts a response body into a List<Photo>.
List<FoodGen> parseDishes(String responseBody) {
  final parsed = jsonDecode(responseBody).cast<Map<String, dynamic>>();

  return parsed.map<FoodGen>((json) => FoodGen.fromJson(json)).toList();
}

class FoodGen {
  int fdcId;
  String description;
  String dataType;
  String publicationDate;
  String ndbNumber;
  List<FoodNutrients> foodNutrients;

  FoodGen(
      {this.fdcId,
      this.description,
      this.dataType,
      this.publicationDate,
      this.ndbNumber,
      this.foodNutrients});

  FoodGen.fromJson(Map<String, dynamic> json) {
    fdcId = json['fdcId'];
    description = json['description'];
    dataType = json['dataType'];
    publicationDate = json['publicationDate'];
    ndbNumber = json['ndbNumber'];
    if (json['foodNutrients'] != null) {
      foodNutrients = new List<FoodNutrients>();
      json['foodNutrients'].forEach((v) {
        foodNutrients.add(new FoodNutrients.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fdcId'] = this.fdcId;
    data['description'] = this.description;
    data['dataType'] = this.dataType;
    data['publicationDate'] = this.publicationDate;
    data['ndbNumber'] = this.ndbNumber;
    if (this.foodNutrients != null) {
      data['foodNutrients'] =
          this.foodNutrients.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class FoodNutrients {
  String number;
  String name;
  dynamic amount;
  String unitName;
  String derivationCode;
  String derivationDescription;

  FoodNutrients(
      {this.number,
      this.name,
      this.amount,
      this.unitName,
      this.derivationCode,
      this.derivationDescription});

  FoodNutrients.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    name = json['name'];
    amount = json['amount'];
    unitName = json['unitName'];
    derivationCode = json['derivationCode'];
    derivationDescription = json['derivationDescription'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['name'] = this.name;
    data['amount'] = this.amount;
    data['unitName'] = this.unitName;
    data['derivationCode'] = this.derivationCode;
    data['derivationDescription'] = this.derivationDescription;
    return data;
  }
}

class FoodPage extends StatefulWidget {
  FoodPage({Key key}) : super(key: key);

  @override
  _FoodPageState createState() => _FoodPageState();
}

class _FoodPageState extends State<FoodPage> {
  TextEditingController editingController = TextEditingController();
  List<FoodGen> dishes;
  List<FoodGen> tempDishes = List<FoodGen>();

  List<FoodGen> queryDishes = List<FoodGen>();
  
  List<FoodGen> dummySearchList = List<FoodGen>();
  Widget _widget = Container();
  var energy; 
  @override

  void searchInDatabase(String query){
    _widget = FutureBuilder<List<FoodGen>>(
      future: fetchQueryDish(http.Client(), query),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          queryDishes = snapshot.data;
          return ListView.builder(
          itemCount: queryDishes.length,
          itemBuilder: (context, index) {
            return Card(
                child: ListTile(
                  title: Text(tempDishes[index].description, style: TextStyle(color: Colors.white),), 
                  subtitle: Text('Energy - $energy', style: TextStyle(color: Colors.white))
                  ), 
                  color: FitnessAppTheme.nearlyDark,);
          },
        );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }



  void initState() {
    super.initState();
    _widget = FutureBuilder<List<FoodGen>>(
      future: fetchDishes(http.Client()),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          dishes = snapshot.data;
          tempDishes.clear();
          tempDishes.addAll(dishes);
          return ListView.builder(
          itemCount: tempDishes.length,
          itemBuilder: (context, index) {
            for (var i = 0; i < tempDishes[index].foodNutrients.length; i++) {
              if(tempDishes[index].foodNutrients[i].name == "Energy"){
                 energy =  tempDishes[index].foodNutrients[i].amount.toString();
              }
            }  
            return Card(
                child: ListTile(
                  title: Text(tempDishes[index].description, style: TextStyle(color: Colors.white),), 
                  subtitle: Text('Energy - $energy', style: TextStyle(color: Colors.white))
                  ), 
                  color: FitnessAppTheme.nearlyDark,);
          },
        );

        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  void filterSearchResults(String query) {
    if (tempDishes == null) return;
      dummySearchList.clear();
      dummySearchList.addAll(dishes);
    if (query.isNotEmpty) {
      List<FoodGen> dummyListData = List<FoodGen>();
      dummyListData.clear();
      dummySearchList.forEach((item) {
        String queryLowercase = query.toLowerCase();
        if (item.description.toLowerCase().startsWith('$queryLowercase')) {
          dummyListData.add(item);
        }
        else
        {
        }
        });
          setState(() {
            tempDishes.clear();
            tempDishes.addAll(dummyListData);
            _widget = ListView.builder(
              itemCount: tempDishes.length,
              itemBuilder: (context, index) {
                for (var i = 0; i < tempDishes[index].foodNutrients.length; i++) {
                  if(tempDishes[index].foodNutrients[i].name == "Energy"){
                      energy =  tempDishes[index].foodNutrients[i].amount.toString();
                  }
                }  
                return Card(
                    child: ListTile(
                      
                      title: Text(tempDishes[index].description, style: TextStyle(color: Colors.white),), 
                      subtitle: Text('Energy - $energy', style: TextStyle(color: Colors.white))
                      ), 
                      color: FitnessAppTheme.nearlyDark,);
              },
            );
                });
              } else {
                setState(() {
                  tempDishes.clear();
                  tempDishes.addAll(dishes);
                   _widget = ListView.builder(
                    itemCount: tempDishes.length,
                    itemBuilder: (context, index) {
                      for (var i = 0; i < tempDishes[index].foodNutrients.length; i++) {
                        if(tempDishes[index].foodNutrients[i].name == "Energy"){
                           energy =  dishes[index].foodNutrients[i].amount.toString();
                        }
                      }  
                      return Card(
                        
                          child: ListTile(
                            
                            title: Text(tempDishes[index].description, style: TextStyle(color: Colors.white),), 
                            subtitle: Text('Energy - $energy', style: TextStyle(color: Colors.white))
                            ), 
                            color: FitnessAppTheme.nearlyDark,);
                    },
                  );
          
                });
          
                }
              }          
            @override
            Widget build(BuildContext context) {
              return new Scaffold(
                backgroundColor: FitnessAppTheme.darkBackground,
                body: SafeArea(
                  top: true,
                  child: Container(
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextField(
                            style: TextStyle(color: Colors.white),
                            onChanged: (value) {
                              filterSearchResults(value);
                            },
                            controller: editingController,
                            decoration: InputDecoration(
                                hintStyle: TextStyle(color: FitnessAppTheme.white),
                                labelStyle: TextStyle(color: FitnessAppTheme.white),
                                labelText: "Search",
                                hintText: "Search",
                                prefixIcon: Icon(Icons.search, color: Colors.white,),
                                enabledBorder: const OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                                  borderSide: const BorderSide(color: Colors.white, width: 1.0)
                                  ),
                                border: const OutlineInputBorder()
                            ),
                          ),
                        ),
                        Expanded(
                          child: _widget,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }
          
}
