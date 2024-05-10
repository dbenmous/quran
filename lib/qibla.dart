import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:vibration/vibration.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class QiblaPage extends StatefulWidget {
  @override
  _QiblaPageState createState() => _QiblaPageState();
}

class _QiblaPageState extends State<QiblaPage> {
  final _locationPermissionGranted = ValueNotifier<bool>(false);
  Timer? _navigationTimer;
  final StreamController<bool> _locationStreamController = StreamController<bool>.broadcast();

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _checkLocationPermission();
  }

  void _showNavigationTemporarily() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    _navigationTimer?.cancel();
    _navigationTimer = Timer(const Duration(seconds: 2), () {
      SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    });
  }

  Future<void> _checkLocationPermission() async {
    PermissionStatus status = await Permission.location.status;
    if (status == PermissionStatus.denied) {
      status = await Permission.location.request();
    }

    if (status == PermissionStatus.granted) {
      _locationPermissionGranted.value = true;
      _locationStreamController.add(true);
    } else {
      _locationStreamController.add(false);
    }
  }

  @override
  void dispose() {
    _navigationTimer?.cancel();
    _locationStreamController.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
        onVerticalDragUpdate: (_) => _showNavigationTemporarily(),
        onHorizontalDragUpdate: (_) => _showNavigationTemporarily(),
        child: Stack(
          children: [
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: Center(
                    child: Column(
                      children: [
                        Text(
                          'إتجاه القبلة',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 48,
                            fontFamily: 'thuluth',
                          ),
                        ),
                        const SizedBox(height: 20),
                        Icon(
                          Icons.arrow_upward,
                          color: Colors.green,
                          size: 70,
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: ValueListenableBuilder<bool>(
                    valueListenable: _locationPermissionGranted,
                    builder: (context, bool granted, _) {
                      if (!granted) {
                        return Center(
                          child: Text(
                            'يجب منح إذن الموقع لرؤية اتجاه القبلة',
                            style: TextStyle(
                              fontSize: 16,
                              fontFamily: 'arabic_roman',
                              color: Colors.black,
                            ),
                          ),
                        );
                      }

                      return FutureBuilder<bool?>(
                        future: FlutterQiblah.androidDeviceSensorSupport(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return Center(
                              child: CircularProgressIndicator(),
                            );
                          }

                          if (snapshot.data == false) {
                            return Center(
                              child: Text(
                                'جهازك لا يدعم مستشعر البوصلة.',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: 'arabic_roman',
                                  color: Colors.black,
                                ),
                              ),
                            );
                          }

                          return QiblahCompassWidget();
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 20,
              left: 0,
              right: 0,
              child: Center(
                child: FloatingActionButton(
                  onPressed: () => Navigator.pop(context),
                  child: Icon(Icons.arrow_back_ios_rounded, color: Colors.white),
                  backgroundColor: Colors.blueGrey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class QiblahCompassWidget extends StatefulWidget {
  @override
  _QiblahCompassWidgetState createState() => _QiblahCompassWidgetState();
}

class _QiblahCompassWidgetState extends State<QiblahCompassWidget> {
  bool _isAligned = false;
  String _cityName = "جارٍ التحميل..."; // Initial loading state
  String _errorMessage = ""; // Error message placeholder

  @override
  void initState() {
    super.initState();
    _fetchCityName(); // Fetch city name when the widget initializes
  }

  Future<void> _fetchCityName() async {
    try {
      // Request permission for location access
      PermissionStatus locationPermission = await Permission.location.request();

      if (locationPermission.isGranted) {
        // Get the current position
        final position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);

        // Reverse geocode to get placemarks
        final placemarks = await placemarkFromCoordinates(position.latitude, position.longitude);
        final placemark = placemarks.isNotEmpty ? placemarks[0] : null;

        setState(() {
          _cityName = placemark?.locality ?? "مدينة غير معروفة";
        });
      } else {
        setState(() {
          _errorMessage = "إذن الموقع غير ممنوح";
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = "خطأ في الحصول على الموقع";
        _cityName = "";
      });
    }
  }

  Future<void> _vibrateIfSupported() async {
    if (await Vibration.hasVibrator() ?? false) {
      if (await Vibration.hasAmplitudeControl() ?? false) {
        Vibration.vibrate(duration: 200, amplitude: 128);
      } else {
        Vibration.vibrate(duration: 200);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QiblahDirection>(
      stream: FlutterQiblah.qiblahStream,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final qiblahDirection = snapshot.data;
        final direction = qiblahDirection?.direction ?? 0;
        final offset = qiblahDirection?.offset ?? 0;

        // Check if aligned within ±10 degrees to account for calibration issues
        final isAlignedNow = offset.abs() < 10;

        if (isAlignedNow && !_isAligned) {
          _isAligned = true;
          _vibrateIfSupported(); // Vibrate if supported
        } else if (!isAlignedNow) {
          _isAligned = false;
        }

        return Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Transform.rotate(
              angle: -direction * (pi / 180) ,
              child: Image.asset(
                'assets/qiblah_compass.png',
                width: 200,
                height: 200,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              '${offset.toStringAsFixed(3)}°',
              style: TextStyle(fontSize: 24, fontFamily: 'thuluth'),
            ),
            const SizedBox(height: 10),
            Text(
              _errorMessage.isNotEmpty ? _errorMessage : _cityName,
              style: TextStyle(fontSize: 24, fontFamily: 'thuluth'),
            ),
          ],
        );
      },
    );
  }
}
