import 'package:flutter/material.dart';
import 'package:mdev_carpool/Assistants/request_assistant.dart';
import 'package:mdev_carpool/models/predicted_places.dart';
import 'package:mdev_carpool/widgets/progress_dialog.dart';
import 'package:provider/provider.dart';

import '../InfoHandler/app_info.dart';
import '../global/global.dart';
import '../global/map_key.dart';
import '../models/directions.dart';

class PredictionMenu extends StatefulWidget {

  final PredictedPlaces? predictedPlaces;

  PredictionMenu({this.predictedPlaces});

  @override
  State<PredictionMenu> createState() => _PredictionMenuState();
}

class _PredictionMenuState extends State<PredictionMenu> {

  getPlaceDirectionDetails(String? placeId, context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) => ProgressDialog(
          message: "Setting up Drop-Off. Will only take a moment...",
        ),
    );

    String placeDirectionDetailUrl = "https://maps.google.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var responseApi = await RequestAssitant.receiveRequest(placeDirectionDetailUrl);

    Navigator.pop(context);

    if(responseApi == "Error Occurred. No response."){
      return;
    }

    if(responseApi["status"] == "OK"){
      Directions directions = Directions();
      directions.locationName = responseApi["result"]["name"];
      directions.locationId = placeId;
      directions.locationLatitude = responseApi["result"]["geometry"]["lat"];
      directions.locationLongitude = responseApi["result"]["geometry"]["lng"];

      Provider.of<AppInfo>(context, listen: false).updateDropOffLocationAddress(directions);

      setState(() {
        userDropOffAddress = directions.locationName!;
      });

      Navigator.pop(context, "obtainedDropOff");

    }
  }

  @override
  Widget build(BuildContext context) {

    bool darkTheme = MediaQuery.of(context).platformBrightness == Brightness.dark;

    return ElevatedButton(
        onPressed: () {
          getPlaceDirectionDetails(widget.predictedPlaces!.place_id, context);
        },
        style: ElevatedButton.styleFrom(
          primary: darkTheme ? Colors.black : Colors.white,
        ),
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Row(
            children: [
              Icon(
                Icons.add_location,
                color: darkTheme ? Colors.amber.shade400 : Colors.blue,
              ),

              SizedBox(width: 10,),

              Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.predictedPlaces!.main_text!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: darkTheme ? Colors.amber.shade400: Colors.blue,
                        ),
                      ),

                      Text(
                        widget.predictedPlaces!.secondary_text!,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16,
                          color: darkTheme ? Colors.amber.shade400: Colors.blue,
                        ),
                      )
                    ],
                  ))

            ],
          )
        )
    );
  }
}
