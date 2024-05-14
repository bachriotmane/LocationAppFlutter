// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatefulWidget {
  const MapPage(
      {super.key,
      required this.latitude,
      required this.longtitude,
      required this.cityname});
  final double latitude;
  final double longtitude;
  final String cityname;

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  Future<List<Location>> getLocationFromCityName(city) async {
    try {
      final resp = await locationFromAddress(city);
      return resp;
    } catch (err) {
      return [];
    }
  }

  void _loadLocation() {
    getLocationFromCityName(widget.cityname).then((locations) {
      if (locations.isNotEmpty) {
        setState(() {
          lat = locations.first.latitude;
          long = locations.first.longitude;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
          cityNotFound = true;
        });
      }
    });
  }

  bool isLoading = true;

  bool cityNotFound = false;
  @override
  void initState() {
    super.initState();
    _loadLocation();
  }

  double lat = 44;
  double long = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Map"),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : cityNotFound
              ? const Center(
                  child: Text("No city found at this location!"),
                )
              : FlutterMap(
                  options: MapOptions(
                    initialCenter: LatLng(lat, long),
                    initialZoom: 10,
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                      userAgentPackageName: 'com.example.app',
                    ),
                  ],
                ),
    );
  }
}
