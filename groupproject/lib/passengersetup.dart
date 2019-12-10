import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart' as prefix0;

//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'passengermap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/rendering.dart';
import 'package:location/location.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'passenger.dart';

class PassengerSetup extends StatefulWidget {
  @override
  PassengerSetupState createState() => PassengerSetupState();
}

class PassengerSetupState extends State<PassengerSetup> {
  TextEditingController _controllerName;
  TextEditingController _controllerDestination;
  //Passenger passenger;


  var _geolocator = Geolocator();
  var _positionMessage = '';
  var centre;
  //String address = '301 Front St W, Toronto, ON';
  String address = '160 Lionhead Trail, Toronto, ON';

  void _updateLocation(userLocation) {

    // geolocator plug-in:
    setState(() {
      _positionMessage = userLocation.latitude.toString() + ', ' + userLocation.longitude.toString();
      centre =  LatLng(userLocation.latitude,userLocation.longitude);

    });
    print('New location: ${userLocation.latitude}, ${userLocation.longitude}.');
    print('Centre location: ${centre.latitude}, ${centre.longitude}.');

    _geolocator.placemarkFromCoordinates(userLocation.latitude, userLocation.longitude).then((List<Placemark> places) {
      print('Reverse geocoding results:');
      for (Placemark place in places) {
        print('\t${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}');
        print(place.position.latitude);
        print(place.position.longitude);
      }
    });


    _geolocator.placemarkFromAddress(address).then((List<Placemark> places) {
      print('Forward geocoding results:');
      for (Placemark place in places) {
        print('\t${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}');
      }
    });

  }


  void updateDestination(destination){
    //String address = '301 Front St W, Toronto, ON';
    _geolocator.placemarkFromAddress(address).then((List<Placemark> places) {
      print('Forward geocoding results:');
      for (Placemark place in places) {
        print('\t${place.name}, ${place.subThoroughfare}, ${place.thoroughfare}, ${place.locality}, ${place.subAdministrativeArea}');
      }
    });
  }

  @override
  void initState() {
    // this is called when the location changes
    // geolocator plug-in version:

    super.initState();
    _geolocator.checkGeolocationPermissionStatus().then((GeolocationStatus geolocationStatus) {
      print('Geolocation status: $geolocationStatus.');
    });
    _geolocator.getPositionStream(LocationOptions(accuracy: prefix0.LocationAccuracy.best, timeInterval: 5000))
        .listen((userLocation) {
      _updateLocation(userLocation);
    }
    );
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Passenger Setup'),
          actions: <Widget>[
        FlatButton(
          child: Text('EN'),
          onPressed: () {
            Locale newLocale = Locale('en');
            setState(() {
              FlutterI18n.refresh(context, newLocale);
            });
          },
        ),
        FlatButton(
            child: Text('FR'),
            onPressed: () {
              Locale newLocale = Locale('fr');
              setState(() {
                FlutterI18n.refresh(context, newLocale);
              });
            })
      ]),
      body: Center(
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _controllerName,
              decoration: InputDecoration(
                labelText: (FlutterI18n.translate(context, 'pregister.Name')),
                hintText: (FlutterI18n.translate(context, 'register.NameHint')),
              ),
            ),
            TextField(
              controller: _controllerDestination,
              decoration: InputDecoration(
                labelText:
                    (FlutterI18n.translate(context, 'pregister.Destination')),
                hintText: (FlutterI18n.translate(
                    context, 'pregister.DestinationHint')),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Passenger passenger = Passenger(
            name: _controllerName.toString(),
            destination: _controllerDestination.toString(),
            location: centre,
          );

          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PassengerMap(currentPosition: passenger,)),
          );
        },
        child: Icon(Icons.check),
      ),
    );
  }


}
