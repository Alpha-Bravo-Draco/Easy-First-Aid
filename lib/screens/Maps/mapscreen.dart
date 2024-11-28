import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Mapscreen extends StatefulWidget {
  const Mapscreen({Key? key}) : super(key: key);

  @override
  State<Mapscreen> createState() => _MapscreenState();
}

class _MapscreenState extends State<Mapscreen> {
  GoogleMapController? _mapController;
  Position? _currentPosition;
  Set<Marker> _markers = {};
  Map<PolylineId, Polyline> _polylines = {};

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  void _getCurrentLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Location services are disabled.')),
      );
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Location permissions are denied.')),
        );
        return;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Location permissions are permanently denied.')),
      );
      return;
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      _currentPosition = position;
    });
    _getNearbyHospitals();
  }

  void _getNearbyHospitals() async {
    if (_currentPosition == null) return;

    final url = 'https://maps.googleapis.com/maps/api/place/nearbysearch/json?'
        'location=${_currentPosition!.latitude},${_currentPosition!.longitude}'
        '&radius=5000&type=hospital&key=YOUR_API_KEY';

    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        _markers.clear();
        for (var hospital in data['results']) {
          _markers.add(
            Marker(
              markerId: MarkerId(hospital['place_id']),
              position: LatLng(
                hospital['geometry']['location']['lat'],
                hospital['geometry']['location']['lng'],
              ),
              infoWindow: InfoWindow(
                title: hospital['name'],
                snippet: hospital['vicinity'],
              ),
              onTap: () => _getDirections(
                LatLng(
                  hospital['geometry']['location']['lat'],
                  hospital['geometry']['location']['lng'],
                ),
              ),
            ),
          );
        }
      });
    }
  }

  void _getDirections(LatLng destination) async {
    if (_currentPosition == null) return;

    PolylinePoints polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      googleApiKey: 'AIzaSyDfH1-36pRzgE8dXbaUGtyhWu7P6yoGICY',
      request: PolylineRequest(
        origin: PointLatLng(
            _currentPosition!.latitude, _currentPosition!.longitude),
        destination: PointLatLng(destination.latitude, destination.longitude),
        mode: TravelMode.driving,
      ),
    );

    if (result.points.isNotEmpty) {
      List<LatLng> polylineCoordinates = [];
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });

      setState(() {
        _polylines.clear();
        _polylines[PolylineId('route')] = Polyline(
          polylineId: PolylineId('route'),
          color: Colors.blue,
          points: polylineCoordinates,
          width: 5,
        );
      });

      _mapController?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            southwest: LatLng(
              _currentPosition!.latitude < destination.latitude
                  ? _currentPosition!.latitude
                  : destination.latitude,
              _currentPosition!.longitude < destination.longitude
                  ? _currentPosition!.longitude
                  : destination.longitude,
            ),
            northeast: LatLng(
              _currentPosition!.latitude > destination.latitude
                  ? _currentPosition!.latitude
                  : destination.latitude,
              _currentPosition!.longitude > destination.longitude
                  ? _currentPosition!.longitude
                  : destination.longitude,
            ),
          ),
          100.0,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Hospitals'),
        actions: [
          if (_currentPosition != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  const Icon(Icons.location_on, color: Colors.red),
                  const SizedBox(width: 8),
                  Text(
                    '${_currentPosition!.latitude.toStringAsFixed(4)}, '
                    '${_currentPosition!.longitude.toStringAsFixed(4)}',
                    style: const TextStyle(fontSize: 12),
                  ),
                ],
              ),
            ),
        ],
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                    _currentPosition!.latitude, _currentPosition!.longitude),
                zoom: 14,
              ),
              onMapCreated: (controller) => _mapController = controller,
              markers: _markers,
              polylines: Set<Polyline>.of(_polylines.values),
              myLocationEnabled: true,
              myLocationButtonEnabled: true,
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: _getNearbyHospitals,
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
