import 'package:permission_handler/permission_handler.dart';

class LocationPermissionHandler {
  bool? isClick;
  Future<bool> checkLocationPermission() async {
    var status = await Permission.location.status;

    if (status.isGranted) {
      // SMS permission is granted
      return true;
    } else {
      // Request SMS permission
      var result = await Permission.location.request();

      if (result.isGranted) {
        // SMS permission granted after request
        return true;
      } else {
        // SMS permission denied
        return false;
      }
    }
  }
}
