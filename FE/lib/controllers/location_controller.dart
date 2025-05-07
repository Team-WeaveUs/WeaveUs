import 'package:geolocator/geolocator.dart';
import '../services/location_service.dart';
import 'package:get/get.dart';

class LocationController extends GetxController {
  final LocationService _locationService = LocationService();

  Rxn<Position> position = Rxn<Position>();
  RxString error = ''.obs;
  RxBool isLoading = false.obs;

  Future<void> fetchLocation() async {
    isLoading.value = true;
    error.value = '';
    try {
      position.value = await _locationService.getCurrentLocation();
    } catch (e) {
      error.value = e.toString();
    } finally {
      isLoading.value = false;
    }
  }
}
