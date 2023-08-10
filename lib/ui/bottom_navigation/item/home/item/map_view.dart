import 'package:driver_kangsayur/common/color_value.dart';
import 'package:driver_kangsayur/contants/app_contans.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/bloc/pesanan_driver_bloc.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/event/pesanan_driver_model.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/home_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/repository/konfirmasi_driver_repository.dart';
import 'package:driver_kangsayur/ui/bottom_navigation/item/home/state/pesanan_driver_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geocoding/geocoding.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart' as loc;
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';

class MapViewDriver extends StatefulWidget {
  const MapViewDriver({super.key});

  @override
  State<MapViewDriver> createState() => _MapViewDriverState();
}

class _MapViewDriverState extends State<MapViewDriver> {

  String? _currentAddress;
  LatLng _currentPosition = AppConstants.myLocation;
  final List<Marker> _markers = [];
  Marker? _currentMarker;
  var mapController = MapController();
  bool _isMapViewAddress = false;
  final pageController = PageController();
  int selectedIndex = 0;

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
    locationData = await location.getLocation();
    setState(() {
      _currentPosition = LatLng(locationData.latitude!, locationData.longitude!);
    });
    _getAddressFromLatLng();

    // Memindahkan peta ke lokasi pengguna atau marker
    mapController.move(_currentPosition, 14.0); // Sesuaikan level zoom jika perlu
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getAddressFromLatLng();
    _getCurrentLocation();
    mapController = MapController();
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Titik Pengantaran",
          style: TextStyle(color: Colors.black, fontSize: 18),),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black,),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocProvider(
        create: (context) => PesananDriverBloc(pesananDriverRepository: PesananDriverRepository(), konfirmasiDriverRepository: KonfirmasiRepository())..add(GetPesanan()),
        child: BlocBuilder<PesananDriverBloc, PesananDriverPageState>(
          builder: (context, state) {
            if(state is PesananDriverPageLoading){
              return shimmerList();
            } else if (state is PesananDriverPageLoaded){
              final pesananDriverModel = state.pesananDriverModel;
              return Stack(
                children: [
                  FlutterMap(
                    options: MapOptions(
                      center: AppConstants.myLocation,
                      zoom: 14.0,
                      onTap: (tapPosition, point) {
                        setState(() {
                          _isMapViewAddress = false;
                        });
                      },
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
                          for (int i = 0; i < pesananDriverModel.data.length; i++)
                              Marker(
                              width: 80.0,
                              height: 80.0,
                              point: LatLng(pesananDriverModel.data[i].userLat, pesananDriverModel.data[i].userLong),
                              builder: (ctx) => IconButton(
                                icon: const Icon(Icons.location_pin, color: ColorValue.primaryColor,),
                                onPressed: () {
                                  print("Marker $i tapped!");
                                    _isMapViewAddress = true;
                                    _currentPosition = LatLng(pesananDriverModel.data[i].userLat, pesananDriverModel.data[i].userLong);
                                    mapController.move(_currentPosition, 14.0);
                                    setState(() {
                                      selectedIndex = i;
                                      if (pageController.hasClients) {
                                        pageController.animateToPage(
                                          selectedIndex,
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                        );
                                        print(i);
                                      }
                                    });
                                },
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                  if (_isMapViewAddress == true)
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 5,
                      height: 178,
                      child: PageView.builder(
                        controller: pageController,
                        itemCount: pesananDriverModel.data.length,
                        onPageChanged: (index) {
                          setState(() {
                            _currentPosition = LatLng(pesananDriverModel.data[index].userLat, pesananDriverModel.data[index].userLong);
                            mapController.move(_currentPosition, 14.0);
                            selectedIndex = index;
                          });
                        },
                        itemBuilder: (context, index) {
                          return Container(
                            margin: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.withOpacity(0.5),
                                  spreadRadius: 1,
                                  blurRadius: 7,
                                  offset: const Offset(0, 3), // changes position of shadow
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FutureBuilder<List<Placemark>>(
                                  future: placemarkFromCoordinates(
                                    pesananDriverModel.data[index].userLat,
                                    pesananDriverModel.data[index].userLong,
                                  ),
                                  builder: (context, snapshot) {
                                    if (snapshot.connectionState == ConnectionState.waiting) {
                                      return Text("Mengambil alamat...");
                                    } else if (snapshot.hasError) {
                                      return Text("Error: ${snapshot.error}");
                                    } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                                      Placemark placemark = snapshot.data![0];
                                      String address = "${placemark.street}, ${placemark.locality}, ${placemark.administrativeArea} ${placemark.postalCode}, ${placemark.country}";
                                      return Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            address,
                                            style: textTheme.bodyMedium!.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 16,
                                            ),
                                          ),
                                          const SizedBox(height: 8,),
                                          //elvetade butoon untuk buka ke google maps
                                          ElevatedButton(
                                            onPressed: () {
                                              launch("https://www.google.com/maps/dir/?api=1&destination=${pesananDriverModel.data[index].userLat},${pesananDriverModel.data[index].userLong}");
                                            },
                                            style: ElevatedButton.styleFrom(
                                              primary: ColorValue.primaryColor,
                                              shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(8),
                                              ),
                                            ),
                                            child: const Text("Lihat Rute"),
                                          )
                                        ],
                                      );
                                    } else {
                                      return Text("Alamat tidak ditemukan.");
                                    }
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                ],
              );
            } else if (state is PesananDriverPageError){
              return shimmerList();
            } else {
              return shimmerList();
            }
          },
        )
      ),
    );
  }

  Widget shimmerList() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.withOpacity(0.5),
      highlightColor: Colors.grey.withOpacity(0.3),
      child: Container(
        color: Colors.white,
        child: FlutterMap(
          options: MapOptions(
            center: AppConstants.myLocation,
            zoom: 14.0,
          ),
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
                  point: AppConstants.myLocation,
                  builder: (ctx) => Container(
                    child: IconButton(
                      icon: Icon(Icons.location_pin, color: ColorValue.primaryColor,),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}