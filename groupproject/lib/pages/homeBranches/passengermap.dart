import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_map/flutter_map.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:latlong/latlong.dart';
import 'package:groupproject/models/passenger.dart';
import 'package:groupproject/models/driver.dart';
import 'package:groupproject/services/notifications.dart';
import 'package:charts_flutter/flutter.dart' as charts;



class PassengerMap extends StatefulWidget {
  PassengerMap({Key key, this.currentPosition, this.drivers}) : super(key: key);
  final Passenger currentPosition;
  List<Driver> drivers;


  @override
  PassengerMapState createState() => PassengerMapState();

}

class PassengerMapState extends State<PassengerMap>{
  var _notifications = Notifications();
  var _geolocator = Geolocator();
  void _notificationNow(Driver driver) {
    _notifications.sendNotificationNow('Invite Sent to ' + driver.name + '!', 'Car: ' + driver.car + '\nSeats: ' + driver.seats.toString(), 'Available');
  }


  @override
  Widget build(BuildContext context) {
    _notifications.init();
    //var path = [widget.currentPosition.location, widget.currentPosition.destinationlatlng];
    //centre =  LatLng(_currentPosition.latitude,_currentPosition.longitude);
    var driverLocation = LatLng( (widget.currentPosition.location.latitude + 0.00222), (widget.currentPosition.location.longitude + 0.00222) );//test location
    String mylocation = '';
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.help),
            onPressed: (){
              showDialog<void>(
                barrierDismissible: false, // user must tap button!
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Help Info'),
                    content: Text('Tap on your Icon to see your current Location. \n Tap on car icons to send invites. \n Tap on Star Icon to see your Destination Location.' ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

          IconButton(
            icon: Icon(Icons.event_seat),
            onPressed: (){
              showDialog<void>(
                barrierDismissible: false, // user must tap button!
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text('Number of Seats Comparison'),
                    content: charts.BarChart(
                      [
                        charts.Series<Driver, String>(
                          id: 'Grade Frequency',
                          colorFn: (a,b) => charts.MaterialPalette.blue.shadeDefault,
                          domainFn: (Driver driver, unused) => driver.name,
                          measureFn: (Driver driver, unused) => driver.seats,
                          data: widget.drivers,
                        ),
                      ],
                      animate: true,
                      vertical: false,
                    ),
                    actions: <Widget>[
                      FlatButton(
                        child: Text('Close'),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),

        ],
      ),
      body: Center(
        child: FlutterMap(
          options: MapOptions(
            minZoom: 14.0,
            center: widget.currentPosition.location,
          ),
          layers: [
            TileLayerOptions(
              ///*
              // for MapBox:
                urlTemplate: 'https://api.tiles.mapbox.com/v4/{id}/{z}/{x}/{y}@2x.png?access_token={accessToken}',
                additionalOptions: {
                  'accessToken': 'pk.eyJ1IjoiZ2hvc3RzaiIsImEiOiJjazNwOWt5ZDYwMHY3M2Ntbm9jNnA2MHE3In0.WTY_0iZKuUXoTKiNjVTgTg',
                  'id': 'mapbox.streets'
                }
            ),
            MarkerLayerOptions(
              markers: [
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: widget.currentPosition.location,
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.location_on),
                      color: Colors.blue,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Icon clicked');
                        mylocation = 'Current Location: ' + widget.currentPosition.locationName;
                        print(mylocation);
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(mylocation),
                        ));
                      },
                    ),
                  ),
                ),
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: widget.drivers[0].location,
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.directions_car),
                      color: Colors.blue,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Icon clicked');

                        _notificationNow(widget.drivers[0]);

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(FlutterI18n.translate(context, 'mappage.Invite')),
                        ));

                      },
                    ),
                  ),
                ),
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: widget.drivers[1].location,
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.directions_car),
                      color: Colors.blue,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Icon clicked');

                        _notificationNow(widget.drivers[1]);

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(FlutterI18n.translate(context, 'mappage.Invite')),
                        ));

                      },
                    ),
                  ),
                ),
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: widget.drivers[2].location,
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.directions_car),
                      color: Colors.blue,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Icon clicked');

                        _notificationNow(widget.drivers[2]);

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text(FlutterI18n.translate(context, 'mappage.Invite')),
                        ));

                      },
                    ),
                  ),
                ),
                Marker(
                  width: 45.0,
                  height: 45.0,
                  point: widget.currentPosition.destinationlatlng,
                  builder: (context) => Container(
                    child: IconButton(
                      icon: Icon(Icons.star),
                      color: Colors.blue,
                      iconSize: 45.0,
                      onPressed: () {
                        print('Icon clicked');

                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Destination: ' + widget.currentPosition.destination),
                        ));

                      },
                    ),
                  ),
                ),



              ],
            ),




          ],
        ),
      ),


    );
  }



}
