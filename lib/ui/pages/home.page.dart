// ignore_for_file: avoid_print

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location_proj/ui/widgets/city.item.dart';
import 'package:location_proj/ui/widgets/textfiled.custom.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final textController = TextEditingController();
  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    return await Geolocator.getCurrentPosition();
  }

  List cities = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _determinePosition().then((value) => setState(() {
                print("Latitude : ${value.latitude}");
                print("Longitude : ${value.longitude}");
                placemarkFromCoordinates(value.latitude, value.longitude).then(
                  (value) {
                    print(value.first.country);
                    print(value.first.locality);
                  },
                );
              }));
        },
      ),
      appBar: AppBar(
        title: const Text(
          "Location app",
          style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.teal,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            _buldItems(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() => Row(
        children: [
          Expanded(
              flex: 4,
              child: MyTextFiled(
                  hintText: "City name ..", controller: textController)),
          Expanded(
            flex: 1,
            child: Container(
                margin: const EdgeInsets.only(right: 10),
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.teal,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: IconButton(
                    onPressed: () {
                      setState(() {
                        cities.add(textController.text);
                      });
                      textController.clear();
                    },
                    icon: const Icon(
                      Icons.add_box_outlined,
                      color: Colors.white,
                      size: 35,
                    ))),
          ),
        ],
      );

  Widget _buldItems(context) {
    return Container(
      height: MediaQuery.of(context).size.height * .8,
      child: ListView.builder(
          itemCount: cities.length,
          itemBuilder: (c, index) => CityItem(
                cityName: cities[index],
                deleteItem: () {
                  setState(() {
                    cities.removeAt(index);
                  });
                },
              )),
    );
  }
}
