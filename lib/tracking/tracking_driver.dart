import 'dart:convert';
import 'dart:async';
import 'package:dotted_line/dotted_line.dart';
import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/bottom_navigation.dart';
import 'package:driver_kangsayur/ui/widget/main_button.dart';
import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:location/location.dart' as loc;
import 'package:latlong2/latlong.dart';
import 'package:http/http.dart' as http;
import 'package:share_plus/share_plus.dart';
import 'package:slide_action/slide_action.dart';
import '../contants/app_contans.dart';

class TrackingDriver extends StatefulWidget {
  const TrackingDriver({Key? key}) : super(key: key);

  @override
  State<TrackingDriver> createState() => _TrackingDriverState();
}

class _TrackingDriverState extends State<TrackingDriver> {

  String? _currentAddress;
  LatLng _currentPosition = AppConstants.myLocation;
  final List<Marker> _markers = [];
  Marker? _currentMarker;
  Marker? _destinationMarker;
  List<LatLng> polylineCoordinates = [];
  PolylinePoints polylinePoints = PolylinePoints();
  Timer? refreshTimer;

  int _duration = 0;
  double _distance = 0;
  List<String> _steps = [];

  double bottomSheetHeight = 220.0;
  bool isExpanded = false;


  var mapController = MapController();

  void _handleTap(tapPosition, LatLng tappedPoint) async {
    _currentPosition = tappedPoint;
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: tappedPoint,
          builder: (context) => const Icon(
            Icons.location_pin,
            size: 50,
            color: ColorValue.primaryColor,
          ),
        ),
      );
      _markers.add(
        Marker(
          point: AppConstants.myLocation,
          builder: (context) => const Icon(
            Icons.location_pin,
            size: 50,
            color: Colors.red, // Warna merah untuk marker tujuan
          ),
        ),
      );
    });

    // Mendapatkan alamat berdasarkan koordinat marker
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      if (placemarks.isNotEmpty) {
        Placemark currentPlacemark = placemarks[0];
        String formattedAddress =
            "${currentPlacemark.street}, ${currentPlacemark.locality}, ${currentPlacemark.administrativeArea} ${currentPlacemark.postalCode}, ${currentPlacemark.country}";
        setState(() {
          _currentAddress = formattedAddress;
        });
      }
    } catch (e) {
      print(e);
    }

    _getPolyline(); // Panggil fungsi untuk mengambil polyline
    _updatePolyline(); // Perbarui polyline dan posisi pengguna
  }

  void _getAddressFromLatLng() async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(_currentPosition.latitude, _currentPosition.longitude);

      if (placemarks.isNotEmpty) {
        Placemark currentPlacemark = placemarks[0];
        String formattedAddress = "${currentPlacemark.street}, ${currentPlacemark.locality}, ${currentPlacemark.administrativeArea} ${currentPlacemark.postalCode}, ${currentPlacemark.country}";
        setState(() {
          _currentAddress = formattedAddress;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  void _getCurrentLocation() async {
    final CollectionReference<Map<String, dynamic>> driverCollection =
    FirebaseFirestore.instance.collection('drivers');
    final location = loc.Location();
    bool serviceEnabled;
    loc.PermissionStatus permissionGranted;
    loc.LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == loc.PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != loc.PermissionStatus.granted) {
        return;
      }
    }

    await driverCollection.doc('driver1').set({
      'latitude': _currentPosition.latitude,
      'longitude': _currentPosition.longitude,
      'destinationLatitude': AppConstants.myLocation.latitude,
      'destinationLongitude': AppConstants.myLocation.longitude,
      'lastUpdate': DateTime.now(),
    });

    locationData = await location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
    _getAddressFromLatLng();

    _getPolyline(); // Panggil fungsi untuk mengambil polyline

    // Memindahkan peta ke lokasi pengguna atau marker
    mapController.move(_currentPosition, 14.0); // Sesuaikan level zoom jika perlu
  }

  void _getPolyline() async {
    String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentPosition.longitude},${_currentPosition.latitude};${AppConstants.myLocation.longitude},${AppConstants.myLocation.latitude}?overview=full&geometries=geojson&access_token=${AppConstants.mapBoxAccessToken}';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> coordinates = data['routes'][0]['geometry']['coordinates'];

      setState(() {
        polylineCoordinates = coordinates
            .map((coord) => LatLng(coord[1], coord[0]))
            .toList();
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  void _updatePolyline() async {
    final locationData = await loc.Location().getLocation();
    final userPosition = LatLng(locationData.latitude!, locationData.longitude!);

    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      AppConstants.mapBoxAccessToken,
      PointLatLng(userPosition.latitude, userPosition.longitude),
      PointLatLng(_currentPosition.latitude, _currentPosition.longitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {
      List<LatLng> updatedPolylineCoordinates = result.points
          .map((point) => LatLng(point.latitude, point.longitude))
          .toList();

      updatedPolylineCoordinates.add(userPosition);

      setState(() {
        polylineCoordinates = updatedPolylineCoordinates;
        _currentPosition = userPosition; // Perbarui posisi pengguna
      });
    }
  }

  void _updateMarkerAndPolyline() {
    setState(() {
      _markers.clear();
      _markers.add(
        Marker(
          point: _currentPosition,
          builder: (context) => const Icon(
            Icons.location_pin,
            size: 50,
            color: ColorValue.primaryColor,
          ),
        ),
      );
    });
  }

  Future<void> _getDirections() async {
    String url = 'https://api.mapbox.com/directions/v5/mapbox/driving/${_currentPosition.longitude},${_currentPosition.latitude};${AppConstants.myLocation.longitude},${AppConstants.myLocation.latitude}?overview=full&geometries=geojson&access_token=${AppConstants.mapBoxAccessToken}&language=id';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      Map<String, dynamic> data = json.decode(response.body);
      List<dynamic> steps = data['routes'][0]['legs'][0]['steps'];
      int duration = data['routes'][0]['duration'].toInt();
      double distance = data['routes'][0]['distance'].toDouble();

      setState(() {

        _steps = steps.map((step) => step['maneuver']['instruction'].toString()).toList();
        _duration = duration;
        _distance = distance;
      });
    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddressFromLatLng();
    _getCurrentLocation();
    _updateMarkerAndPolyline();
    refreshTimer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      setState(() {
        _getDirections();
        _getCurrentLocation();
        _updatePolyline();
      });
    });
  }

  @override
  void dispose() {
    refreshTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            FlutterMap(
              options: MapOptions(
                center: AppConstants.myLocation,
                zoom: 14.0,
                onTap: _handleTap,
              ),
              mapController: mapController,
              children: [
                TileLayer(
                  urlTemplate: AppConstants.mapBoxStyleId,
                  additionalOptions: const {
                    'accessToken': AppConstants.mapBoxAccessToken,
                    'id': 'mapbox.mapbox-streets-v8',
                    'mapStyleId': AppConstants.mapBoxStyleId
                  },
                ),
                MarkerLayer(
                  markers: [
                    Marker(
                        width: 80.0,
                        height: 80.0,
                        point: _currentPosition,
                        builder: (ctx) => const Image(
                          image: AssetImage('assets/images/driver.png'),
                          width: 50,
                          height: 50,
                        )
                    ),
                    Marker(
                      width: 80.0,
                      height: 80.0,
                      point: AppConstants.myLocation,
                      builder: (ctx) => const Icon(
                        Icons.location_pin,
                        size: 50,
                        color: ColorValue.quaternaryColor,
                      ),
                    ),
                  ],
                ),
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: polylineCoordinates,
                      strokeWidth: 4.0,
                      color: ColorValue.primaryColor,
                    ),
                  ],
                ),
              ],
            ),
            //center Positioned Widget
            Positioned(
              //center top
              top: 0,
              left: 0,
              right: 0,
              //terakhir update
              child: Container(
                height: 100,
                padding: const EdgeInsets.all(10.0),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      spreadRadius: 0,
                      blurRadius: 10,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      child: IconButton(
                        //height and with
                        padding: const EdgeInsets.all(5),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color: ColorValue.neutralColor,
                        ),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width - 100,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            //konversi detik ke menit dan jam
                            'Jarak: ${_distance > 1000 ? (_distance / 1000).toStringAsFixed(2) + ' km' : _distance.toStringAsFixed(0) + ' meter'}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              color: ColorValue.neutralColor,
                            ),
                          ),
                          const SizedBox(height: 8),
                          const Divider(
                            height: 1,
                            thickness: 0.5,
                            color: ColorValue.neutralColor,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    //jika meter konveriskan ke km
                                    'Kamu akan tiba dalam: ${_duration > 3600 ? (_duration / 3600).toStringAsFixed(0) + ' jam' : (_duration / 60).toStringAsFixed(0) + ' menit'}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: ColorValue.neutralColor,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            NotificationListener<OverscrollIndicatorNotification>(
              onNotification: (notification) {
                notification.disallowGlow();
                return true;
              },
              //bottom sheet dapat di scroll hingga full screen dari tinggi awal 220
              child: DraggableScrollableSheet(
                initialChildSize: 0.3,
                minChildSize: 0.3,
                maxChildSize: 1,
                builder: (BuildContext context, ScrollController scrollController) {
                  return Container(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          spreadRadius: 0,
                          blurRadius: 10,
                          offset: const Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: SingleChildScrollView(
                      controller: scrollController,
                      child: Column(
                        children: [
                          cardCustomer('Alwan Athallah Mumtaz', 'https://cdn.pixabay.com/photo/2015/04/23/22/00/tree-736885__480.jpg'),
                          const SizedBox(height: 20),
                          cardAlamat('Kebun Teh Bu Darmi, Jl Panjaitan 02', 'Jl Kebayoran 23 Jakarta Pusat'),
                          const SizedBox(height: 20),
                          Container(
                            height: 170,
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                              color: ColorValue.bluePricecolor,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(
                                color: ColorValue.hintColor,
                                width: 0.5,
                              ),
                            ),
                            child: Stack(
                              children: [
                                Container(
                                  height: 120,
                                  width: MediaQuery.of(context).size.width,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(15),
                                      topRight: Radius.circular(15),
                                    ),
                                    border: Border.all(
                                      color: ColorValue.hintColor,
                                      width: 0.5,
                                    ),
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                                  child: ListView.builder(
                                    itemCount: 4,
                                    itemBuilder: (context, index) {
                                      return Container(
                                        margin: const EdgeInsets.only(bottom: 10),
                                        child: Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${index + 1}. Jenis Barang',
                                              style: textTheme.bodyText1!.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: ColorValue.neutralColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                            Text(
                                              'Rp 15.000',
                                              style: textTheme.bodyText1!.copyWith(
                                                fontWeight: FontWeight.w600,
                                                color: ColorValue.neutralColor,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
                                  alignment: Alignment.bottomCenter,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Total',
                                        style: textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: ColorValue.tertiaryColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      Text(
                                        'Rp 60.000',
                                        style: textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          fontSize: 14,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 20),
                          Row(
                            children: [
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                                  width: MediaQuery.of(context).size.width * 0.55,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: ColorValue.hintColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Text(
                                    'Jenis Pembayaran :',
                                    style: textTheme.bodyText1!.copyWith(
                                      fontWeight: FontWeight.w600,
                                      color: ColorValue.neutralColor,
                                      fontSize: 14,
                                    ),
                                  )
                              ),
                              const Spacer(),
                              Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15),
                                    border: Border.all(
                                      color: ColorValue.hintColor,
                                      width: 0.5,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Text(
                                        'Tunai',
                                        style: textTheme.bodyText1!.copyWith(
                                          fontWeight: FontWeight.w600,
                                          color: ColorValue.neutralColor,
                                          fontSize: 14,
                                        ),
                                      ),
                                      const SizedBox(width: 10),
                                      const Icon(
                                        Icons.money,
                                        size: 24,
                                        color: ColorValue.primaryColor,
                                      ),
                                    ],
                                  )
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          slideButton(),
                        ],
                      )
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget slideButton(){
    final textTheme = Theme.of(context).textTheme;
    return SlideAction(
      trackBuilder: (context, state) {
        return Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 8,
              ),
            ],
          ),
          child: Center(
            child: Text(
              // Show loading if async operation is being performed
                state.isPerformingAction
                    ? "Tunggu sebentar..."
                    : "Pesanan Selesai",
                style: textTheme.subtitle1!.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: ColorValue.neutralColor)
            ),
          ),
        );
      },
      thumbBuilder: (context, state) {
        return Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: ColorValue.primaryColor,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            // Show loading indicator if async operation is being performed
            child: state.isPerformingAction
                ? const CupertinoActivityIndicator(
              color: Colors.white,
            )
                : const Icon(
              Icons.chevron_right,
              color: Colors.white,
            ),
          ),
        );
      },
      action: () async {
        // Async operation
        await Future.delayed(
          const Duration(seconds: 2),
              () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const BottomNavigation(),
            ),
          ),
        );
      },
    );
  }

  Widget cardAlamat(String penjemputan, String dropOut){
    final textTheme = Theme.of(context).textTheme;
    return Container(
      height: 140,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: ColorValue.hintColor,
          width: 0.5,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            alignment: Alignment.center,
            margin: const EdgeInsets.only(top: 35, bottom: 10, left: 10),
            child: Column(
              children: [
                Stack(
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorValue.primaryColor,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Container(
                  width: 1,
                  height: 25,
                  color: ColorValue.hintColor,
                  //break line
                  child: const DottedLine(
                    direction: Axis.vertical,
                    lineThickness: 1.0,
                    dashLength: 5.0,
                    dashColor: ColorValue.neutralColor,
                    dashGapColor: Colors.white,
                  ),
                ),
                const SizedBox(height: 5),
                Stack(
                  children: const [
                    CircleAvatar(
                      radius: 10,
                      backgroundColor: ColorValue.tertiaryColor,
                    ),
                    Positioned(
                      top: 0,
                      left: 0,
                      right: 0,
                      bottom: 0,
                      child: Icon(
                        Icons.circle,
                        color: Colors.white,
                        size: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SizedBox(
            width: MediaQuery.of(context).size.width - 100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Tempat penjemputan barang',
                      style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w500,
                          color: ColorValue.neutralColor,
                          fontSize: 12
                      ),
                    ),
                     const SizedBox(height: 5),
                    SizedBox(
                      width: 300,
                      child: Text(
                        penjemputan.length > 70 ? '${penjemputan.substring(0, 70)}...' : penjemputan,
                        style: textTheme.bodyText2!.copyWith(
                          fontWeight: FontWeight.w600,
                          color: ColorValue.neutralColor,
                          fontSize: 14
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(
                  height: 1,
                  thickness: 0.5,
                  color: ColorValue.neutralColor,
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Tempat drop out barang',
                          style: textTheme.bodyText2!.copyWith(
                              fontWeight: FontWeight.w500,
                              color: ColorValue.neutralColor,
                              fontSize: 12
                          ),
                        ),
                        const SizedBox(height: 5),
                        SizedBox(
                          width: 250,
                          child: Text(
                            dropOut.length > 70 ? '${dropOut.substring(0, 70)}...' : dropOut,
                            style: textTheme.bodyText2!.copyWith(
                                fontWeight: FontWeight.w600,
                                color: ColorValue.neutralColor,
                                fontSize: 14
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget cardCustomer(String name, String image){
    final textTheme = Theme.of(context).textTheme;
    return Column(
      children: [
        const SizedBox(height: 5),
        Container(
          alignment: Alignment.center,
          width: 50,
          height: 4,
          decoration: BoxDecoration(
            color: ColorValue.hintColor,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          height: 150,
          width: MediaQuery.of(context).size.width,
          decoration: BoxDecoration(
            color: ColorValue.primaryColor,
            borderRadius: BorderRadius.circular(15),
            border: Border.all(
              color: ColorValue.hintColor,
              width: 0.5,
            ),
          ),
          margin: const EdgeInsets.only(top: 10),
          child: Stack(
            children: [
              Container(
                height: 85,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(15),
                    topRight: Radius.circular(15),
                  ),
                  border: Border.all(
                    color: ColorValue.hintColor,
                    width: 0.5,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 30, right: 30, top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          width: 150,
                          height: 40,
                          child: Text(
                            name,
                            style: textTheme.headline6!.copyWith(
                              fontWeight: FontWeight.bold,
                              color: ColorValue.neutralColor,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        //container with stack for icon
                        Row(
                          children: [
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: ColorValue.primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.message,
                                        color: ColorValue.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              height: 30,
                              width: 30,
                              decoration: BoxDecoration(
                                color: ColorValue.primaryColor,
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 50,
                                    width: 50,
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                    ),
                                  ),
                                  Container(
                                    height: 50,
                                    width: 50,
                                    alignment: Alignment.center,
                                    child: IconButton(
                                      padding: EdgeInsets.zero,
                                      onPressed: () {},
                                      icon: const Icon(
                                        Icons.call,
                                        color: ColorValue.primaryColor,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                    //image network
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: DecorationImage(
                          image: NetworkImage(
                            image,
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
