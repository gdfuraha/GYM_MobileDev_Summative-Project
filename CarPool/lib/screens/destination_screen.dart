import 'package:flutter/material.dart';
import 'package:mdev_carpool/Assistants/request_assistant.dart';
import 'package:mdev_carpool/global/map_key.dart';
import 'package:mdev_carpool/models/predicted_places.dart';
import 'package:mdev_carpool/widgets/place_prediction_menu.dart';

class DestinationScreen extends StatefulWidget {
  const DestinationScreen({Key? key}) : super(key: key);

  @override
  State<DestinationScreen> createState() => _DestinationScreenState();
}

class _DestinationScreenState extends State<DestinationScreen> {

  List<PredictedPlaces> predictedPlacesList = [];

  autoCompleteSearch(String inputText) async {
    if(inputText.length > 1){
      String urlAutoCompleteSearch = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$inputText&key=$mapKey&components=country:US";

      var responseAutoCompleteSearch = await RequestAssitant.receiveRequest(urlAutoCompleteSearch);
      if(responseAutoCompleteSearch == "Error Occurred. No response."){
        return;
      }
      if(responseAutoCompleteSearch["status"] == "OK"){
        var placePredictions = responseAutoCompleteSearch["predictions"];

        var placePredictionsList = (placePredictions as List).map((jsonData) => PredictedPlaces.fromJson(jsonData)).toList();

        setState(() {
          predictedPlacesList = placePredictionsList;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: darkTheme ? Colors.black : Colors.white,
        appBar: AppBar(
          backgroundColor: darkTheme ? Colors.amber.shade400 : Colors.blue,
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child:Icon(Icons.arrow_back, color: darkTheme ? Colors.black : Colors.white,),
          ),
          title: Text(
            "Search & Set Your Destination",
            style: TextStyle(color:darkTheme ? Colors.black : Colors.white),
          ),
            elevation: 0.0,
        ),
        body: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white54,
                    blurRadius: 8,
                    spreadRadius: 0.5,
                    offset: Offset(
                      0.7,
                      0.7,
                    )
                  )
                ]
              ),

              child: Padding(
                  padding: EdgeInsets.all(10.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.adjust_sharp,
                            color: darkTheme ? Colors.black : Colors.white,
                          ),

                          SizedBox(height: 18.0,),

                          Expanded(
                              child: Padding(
                                padding: EdgeInsets.all(8),
                                child:  TextField(
                                  onChanged: (value) {
                                    autoCompleteSearch(value);
                                  },
                                  decoration: InputDecoration(
                                    hintText: "Search location here...",
                                    fillColor: darkTheme ? Colors.black : Colors.white54,
                                    filled: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                      left: 11,
                                      top: 8,
                                      bottom: 8,
                                    )
                                  ),
                                ),
                              )
                          )

                        ],
                      )
                    ],
                  ),
              ),
            ),

            //display place predictions result
            (predictedPlacesList.length > 0)
            ? Expanded(
              child: ListView.separated(
                  itemCount: predictedPlacesList.length,
                  physics: ClampingScrollPhysics(),
                  itemBuilder: (context, index){
                    return PredictionMenu(
                      predictedPlaces: predictedPlacesList[index],
                    );
                  },
                  separatorBuilder: (BuildContext context, int index) {
                    return Divider(
                      height: 0,
                      color: darkTheme ? Colors.amber.shade400 : Colors.blue,
                      thickness: 0,
                    );
                  },
              ),

            ) : Container(),

          ],
        ),
      ),
    );
  }
}
