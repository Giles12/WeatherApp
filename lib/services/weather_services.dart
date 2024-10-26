// ignore_for_file: deprecated_member_use

import 'dart:convert';

// ignore: unused_import
import 'package:flutter/material.dart';
import 'package:weatherapp/models/weather_model.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class WeatherServices {
  // ignore: constant_identifier_names
  static const BASE_URL = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherServices(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final responce = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (responce.statusCode == 200) {
      return Weather.fromJson(jsonDecode(responce.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    //fetch the current location
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // convert the location to city name

    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);
    //extract the city name from the location

    String? city = placemarks[0].locality;

    return city ?? 'Unknown City';
  }
}
