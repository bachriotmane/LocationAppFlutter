import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';

class CoordinatesPage extends StatefulWidget {
  const CoordinatesPage({super.key, required this.cityName});
  final String cityName;

  @override
  State<CoordinatesPage> createState() => _CoordinatesPageState();
}

class _CoordinatesPageState extends State<CoordinatesPage> {
  Future<List<Location>> getLocationFromCityName() async {
    return await locationFromAddress("Settat");
  }

  @override
  void initState() {
    super.initState();
    getLocationFromCityName().then((value) {
      print(value.first);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text(widget.cityName),
      ),
    );
  }
}
