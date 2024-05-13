import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class CoordinatesPage extends StatefulWidget {
  const CoordinatesPage({super.key, required this.cityName});
  final String cityName;

  @override
  State<CoordinatesPage> createState() => _CoordinatesPageState();
}

class _CoordinatesPageState extends State<CoordinatesPage> {
  Future<List<Location>> getLocationFromCityName(city) async {
    return await locationFromAddress(city);
  }

  @override
  void initState() {
    super.initState();

    getLocationFromCityName(widget.cityName).then((value) {
      print(value.first);
      setState(() {
        lat = value.first.latitude;
        long = value.first.longitude;
      });
    });
  }

  double lat = 0;
  double long = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          // height: MediaQuery.of(context).size.height,

          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("City name : ${widget.cityName}"),
              Text("Latitude : ${lat}"),
              Text("Longitude name : ${long}"),
            ],
          ),
        ),
      ),
    );
  }
}
