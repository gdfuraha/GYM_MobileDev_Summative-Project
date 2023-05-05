import 'package:firebase_database/firebase_database.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mdev_carpool/Assistants/request_assistant.dart';
import 'package:mdev_carpool/global/map_key.dart';
import 'package:mdev_carpool/models/directions.dart';
import 'package:provider/provider.dart';

import '../InfoHandler/app_info.dart';
import '../global/global.dart';
import '../models/user_model.dart';

class AssistantMethods {

  static void readCurrentOnlineUserInfo() async {
    currentUser = firebaseAuth.currentUser;
    DatabaseReference userRef = FirebaseDatabase.instance
      .ref()
      .child("users")
      .child(currentUser!.uid);

    userRef.once().then((snap){
      if(snap.snapshot.value != null){
        userModelCurrentInfo = UserModel.fromSnapshot(snap.snapshot);
      }
    });
    }

    static Future<String> searchAddressForGeographicCoordinates(Position position, context) async {

      String apiUrl = "https://maps.googleapis.com/maps/api/geocode/json?Latlng=${position.latitude}, ${position.longitude}&key=$mapKey";
      String readableAddress = "";

      var requestResponse = await RequestAssitant.receiveRequest(apiUrl);

      if(requestResponse != "Error Occured. Failed. No response"){
        readableAddress = requestResponse["results"][0]["formatted_address"];

        Directions userPickUpAddress = Directions();
        userPickUpAddress.locationLatitude = position.latitude;
        userPickUpAddress.locationLongitude = position.longitude;
        userPickUpAddress.locationName = readableAddress;

        Provider.of<AppInfo>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);
      }


      return readableAddress;
    }

}