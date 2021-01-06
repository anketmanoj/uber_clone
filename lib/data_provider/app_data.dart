import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:rider_app/data_models/address.dart';

class AppData extends ChangeNotifier {
  Address pickUpAddress;

  Address destionationAddress;

  void updateDestinationAddress(Address destination) {
    destionationAddress = destination;
    notifyListeners();
  }

  void updatePickUpAddress(Address pickUp) {
    pickUpAddress = pickUp;
    notifyListeners();
  }
}
