import 'package:connectivity/connectivity.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/data_models/address.dart';
import 'package:rider_app/data_provider/app_data.dart';
import 'package:rider_app/global_variables.dart';
import 'package:rider_app/helpers/request_helper.dart';

class HelperMethods {
  static Future<String> findCordinateAddress(Position position, context) async {
    String placeAddress = '';

    // Check network availability
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult != ConnectivityResult.mobile &&
        connectivityResult != ConnectivityResult.wifi) {
      return placeAddress;
    }

    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=${mapKey}";

    var response = await RequestHelper.getRequest(url);

    if (response != 'failed') {
      placeAddress = response['results'][0]['formatted_address'];

      Address pickUpAddress = Address();
      pickUpAddress.longitude = position.longitude;
      pickUpAddress.latitude = position.latitude;
      pickUpAddress.placeName = placeAddress;

      Provider.of<AppData>(context, listen: false)
          .updatePickUpAddress(pickUpAddress);
    }

    return placeAddress;
  }
}
