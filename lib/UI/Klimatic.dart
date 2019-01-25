import 'package:flutter/material.dart';
import '../util/util.dart'  as util;
import 'dart:async';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Klimatic extends StatefulWidget {
  @override
  _KlimaticState createState() => _KlimaticState();
}

class _KlimaticState extends State<Klimatic> {
   String _cityEntered=util.defaultCity;
  //Going to the next Screen
  Future _goToNextScreen(BuildContext context) async{
     Map results = await Navigator.of(context).push(
       new MaterialPageRoute<Map>(builder: (BuildContext context){
         return new ChangeCity();
       }),
     );
     if(results != null && results.containsKey('enter')){
//       print(results['enter'].toString());
       _cityEntered = results['enter'].toString();
     }
     else{
       _cityEntered = util.defaultCity;
     }
  }

//  void showStuff() async {
//    Map data = await getWeather(util.appId,util.defaultCity);
//    print(data.toString());
//  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Klimatic"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
        actions: <Widget>[
          new IconButton(icon: new Icon(Icons.menu), onPressed:(){_goToNextScreen(context);})
        ],
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/umbrella.png",width:600,height:1200,fit: BoxFit.fill,),
          ),

          new Container(
            alignment: Alignment.topRight,
            margin: EdgeInsets.fromLTRB(0, 10, 20, 0),
            child: new Text(_cityEntered == null ? util.defaultCity : _cityEntered ,style: new TextStyle(
                fontSize: 22.9,color: Colors.white,fontStyle: FontStyle.italic),),
          ),
          
          new Container(
            alignment: Alignment.center,
            child: new Image.asset("images/light_rain.png"),
          ),

          new Container(
            alignment: Alignment.center,
            margin: EdgeInsets.fromLTRB(0, 350, 100, 0),
            child: updateWidget(_cityEntered),
          )
        ],
      ),
    );
  }

  Widget updateWidget(String city){
    return new FutureBuilder(
        future: getWeather(util.appId, city == null ? util.defaultCity : city),
        builder: (BuildContext context,AsyncSnapshot<Map> snapshot){
          //get all the json data and code here
          if(snapshot.hasData){
            Map content = snapshot.data;
            return new Container(
              child: new Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                    new Text(content['main']['temp'].toString()+" C",style: new TextStyle(
                        fontSize: 49.9,color: Colors.white,fontWeight: FontWeight.w500),),
                  
                    new Text("Humidity: ${content['main']['temp'].toString()}\n"
                        "Min: ${content['main']['temp_min'].toString()}\n"
                        "Max: ${content['main']['temp_max'].toString()}\n",style: extraData(),)
                ],
              ),
            );
          }
    });
  }

  TextStyle extraData(){
    return new TextStyle(
      color: Colors.white,
      fontSize: 25.0,
      fontStyle: FontStyle.normal
    );
  }

  Future<Map> getWeather(String appId,String city) async{
    String apiUrl = "http://api.openweathermap.org/data/2.5/weather?q=$city&appid=${util.appId}&units=metric";
    http.Response response = await http.get(apiUrl);
    return json.decode(response.body);
  }
}


class ChangeCity extends StatelessWidget {
  final _cityFieldController = new TextEditingController();
  final String finalEnteredString = "";
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Change City"),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),

      body: new Stack(
        children: <Widget>[
          new Center(
            child: new Image.asset("images/white_snow.png",width: 490,height: 1300,fit: BoxFit.fill,),
          ),

          new Column(
            children: <Widget>[
              new Container(
                margin: EdgeInsets.fromLTRB(28, 0, 29, 0),
                child: new TextField(
                  decoration: new InputDecoration(
                      hintText: "Enter City"
                  ),
                  controller: _cityFieldController,
                  keyboardType: TextInputType.text,
                ),
              ),

              new Padding(padding: EdgeInsets.all(10.0)),
              new FlatButton(onPressed: (){
                String enteredString = _cityFieldController.text;
                if(enteredString.isEmpty){
                  enteredString = util.defaultCity;
                }else{
                  enteredString = _cityFieldController.text;
                }
                Navigator.pop(context,{
                  'enter' : enteredString,
                });
              },color: Colors.redAccent,textColor: Colors.white,
                  child: new Text("Get Weather",style: new TextStyle(fontSize: 18.0),))

            ],
          )
        ],
      ),
    );
  }
}

