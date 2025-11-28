import 'dart:typed_data';
import 'dart:ui';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vezem_zerno/core/constants/colors_constants.dart';
import 'package:vezem_zerno/core/entities/application_entity.dart';
import 'package:vezem_zerno/core/widgets/primary_loading_indicator.dart';
import 'package:vezem_zerno/features/applications/presentations/bloc/applications_bloc.dart';
import 'package:vezem_zerno/features/applications/presentations/screens/widgets/application_card_widget.dart';
import 'package:vezem_zerno/routes/router.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

@RoutePage()
class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final List<MapObject> mapObjects = [];
  final MapObjectId clusterizedCollectionId = const MapObjectId(
    'clusterized_placemark_collection',
  );
  bool _isLoading = true;
  YandexMapController? _mapController;
  Position? _userPosition;

  final Map<String, List<ApplicationEntity>> _applicationsByAddress = {};
  final Map<String, Point> _geocodeCache = {};

  @override
  void initState() {
    super.initState();
    _initializeMapObjects();
  }

  Future<void> _moveToUserLocation() async {
    if (_mapController == null) return;

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      LocationPermission permission = await Geolocator.checkPermission();

      if (!serviceEnabled) {
        _moveToDefaultLocation();
        return;
      }

      if (permission == LocationPermission.denied) {
        _moveToDefaultLocation();
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        _moveToDefaultLocation();
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      setState(() {
        _userPosition = position;
      });

      await _mapController!.moveCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: Point(
              latitude: position.latitude,
              longitude: position.longitude,
            ),
            zoom: 10,
          ),
        ),
        animation: const MapAnimation(duration: 1),
      );
    } catch (e) {
      print('Ошибка получения геолокации: $e');
      _moveToDefaultLocation();
    }
  }

  void _moveToDefaultLocation() {
    if (_mapController == null || !mounted) return;

    const defaultPoint = Point(latitude: 55.7558, longitude: 37.6173);
    _mapController!.moveCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(target: defaultPoint, zoom: 10),
      ),
      animation: const MapAnimation(duration: 1),
    );
  }

  Future<void> _initializeMapObjects() async {
    try {
      final currentState = context.read<ApplicationsBloc>().state;
      final applications = currentState is ApplicationsLoadingSuccess
          ? currentState.applications
          : currentState is ResponsesLoadingSuccess
          ? currentState.applications
          : [];

      for (final application in applications) {
        final address =
            '${application.loadingRegion}, ${application.loadingLocality}';
        _applicationsByAddress.putIfAbsent(address, () => []).add(application);
      }

      final List<PlacemarkMapObject> placemarks = [];

      for (final entry in _applicationsByAddress.entries) {
        final address = entry.key;
        final applicationsInCity = entry.value;

        final point = await _geocodeAddress(address);
        if (point != null) {
          placemarks.add(
            PlacemarkMapObject(
              mapId: MapObjectId('address_${address.hashCode}'),
              point: point,
              opacity: 1,
              icon: PlacemarkIcon.single(
                PlacemarkIconStyle(
                  image: BitmapDescriptor.fromBytes(
                    await _createPlacemarkIcon(applicationsInCity.length),
                  ),
                  scale: 1.0,
                ),
              ),
              onTap: (PlacemarkMapObject self, Point point) {
                _showApplicationsList(applicationsInCity);
              },
            ),
          );
        }
      }

      final clusterizedCollection = ClusterizedPlacemarkCollection(
        mapId: clusterizedCollectionId,
        radius: 60,
        minZoom: 5,
        onClusterAdded: _onClusterAdded,
        onClusterTap: (ClusterizedPlacemarkCollection self, Cluster cluster) {
          final List<ApplicationEntity> applicationsInCluster = [];
          for (final placemark in cluster.placemarks) {
            final mapIdString = placemark.mapId.value;
            if (mapIdString.startsWith('address_')) {
              final addressHash = mapIdString.replaceFirst('address_', '');
              final addressEntry = _applicationsByAddress.entries.firstWhere(
                (entry) => entry.key.hashCode.toString() == addressHash,
                orElse: () => _applicationsByAddress.entries.first,
              );
              applicationsInCluster.addAll(addressEntry.value);
            }
          }
          _showApplicationsList(applicationsInCluster);
        },
        placemarks: placemarks,
      );

      if (!mounted) return;
      setState(() {
        mapObjects.add(clusterizedCollection);
        _isLoading = false;
      });
    } catch (e) {
      print('Ошибка инициализации карты: $e');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<Cluster> _onClusterAdded(
    ClusterizedPlacemarkCollection self,
    Cluster cluster,
  ) async {
    int totalApplications = 0;
    for (final placemark in cluster.placemarks) {
      final mapIdString = placemark.mapId.value;
      if (mapIdString.startsWith('address_')) {
        final addressHash = mapIdString.replaceFirst('address_', '');
        final addressEntry = _applicationsByAddress.entries.firstWhere(
          (entry) => entry.key.hashCode.toString() == addressHash,
          orElse: () => _applicationsByAddress.entries.first,
        );
        totalApplications += addressEntry.value.length;
      }
    }

    return cluster.copyWith(
      appearance: cluster.appearance.copyWith(
        icon: PlacemarkIcon.single(
          PlacemarkIconStyle(
            image: BitmapDescriptor.fromBytes(
              await _createClusterIcon(totalApplications),
            ),
            scale: 1.0,
          ),
        ),
      ),
    );
  }

  Future<Uint8List> _createPlacemarkIcon(int count) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(70.w, 70.h);

    final fillPaint = Paint()
      ..color = ColorsConstants.primaryBrownColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = ColorsConstants.primaryTextFormFieldBackgorundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.w;

    final radius = 35.0.sp;

    final textPainter = TextPainter(
      text: TextSpan(
        text: count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0.w, maxWidth: size.width);
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleOffset = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future<Uint8List> _createClusterIcon(int count) async {
    final recorder = PictureRecorder();
    final canvas = Canvas(recorder);
    final size = Size(70.w, 70.h);

    final fillPaint = Paint()
      ..color = ColorsConstants.primaryBrownColor
      ..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..color = ColorsConstants.primaryTextFormFieldBackgorundColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.w;

    final radius = 35.0.sp;

    final textPainter = TextPainter(
      text: TextSpan(
        text: count.toString(),
        style: TextStyle(
          color: Colors.white,
          fontSize: 40.sp,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(minWidth: 0.w, maxWidth: size.width.w);
    final textOffset = Offset(
      (size.width - textPainter.width) / 2,
      (size.height - textPainter.height) / 2,
    );
    final circleOffset = Offset(size.width / 2, size.height / 2);

    canvas.drawCircle(circleOffset, radius, fillPaint);
    canvas.drawCircle(circleOffset, radius, strokePaint);
    textPainter.paint(canvas, textOffset);

    final image = await recorder.endRecording().toImage(
      size.width.toInt(),
      size.height.toInt(),
    );
    final pngBytes = await image.toByteData(format: ImageByteFormat.png);

    return pngBytes!.buffer.asUint8List();
  }

  Future<Point?> _geocodeAddress(String address) async {
    if (_geocodeCache.containsKey(address)) {
      return _geocodeCache[address];
    }

    try {
      final (
        SearchSession session,
        Future<SearchSessionResult> resultFuture,
      ) = await YandexSearch.searchByText(
        searchText: address,
        geometry: Geometry.fromBoundingBox(
          const BoundingBox(
            northEast: Point(latitude: 81.8, longitude: 180.0),
            southWest: Point(latitude: 41.2, longitude: 19.6),
          ),
        ),
        searchOptions: SearchOptions(
          searchType: SearchType.geo,
          resultPageSize: 1,
          geometry: true,
        ),
      );

      final SearchSessionResult result = await resultFuture;

      if (result.error != null) {
        print('Error during geocoding: ${result.error}');
        return null;
      }

      if (result.items != null && result.items!.isNotEmpty) {
        final firstResult = result.items!.first;
        final point = firstResult.toponymMetadata?.balloonPoint;

        if (point != null) {
          _geocodeCache[address] = point;
        }

        return point;
      } else {
        print('No results found for address: $address');
        return null;
      }
    } catch (e) {
      print('Ошибка геокодирования адреса $address: $e');
    }
    return null;
  }

  void _showApplicationsList(List<ApplicationEntity> applications) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: ColorsConstants.backgroundColor,
      builder: (context) {
        return Container(
          height: 500.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              topStart: Radius.circular(32.sp),
              topEnd: Radius.circular(32.sp),
            ),
          ),
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              Text(
                'Количество заявок: ${applications.length}',
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w500,
                  color: ColorsConstants.primaryBrownColor,
                ),
              ),
              SizedBox(height: 16.h),
              Expanded(
                child: ListView.builder(
                  itemCount: applications.length,
                  itemBuilder: (context, index) {
                    final application = applications[index];
                    return ApplicationCard(
                      application: application,
                      onTap: () {
                        context.router.push(
                          InfoAboutApplicationRoute(application: application),
                        );
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16.h),
              Center(
                child: TextButton(
                  onPressed: () => context.router.pop(),
                  child: Text(
                    'Закрыть',
                    style: TextStyle(
                      color: ColorsConstants.primaryBrownColor,
                      fontSize: 16.sp,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorsConstants.backgroundColor,
      body: Stack(
        children: [
          _isLoading
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const PrimaryLoadingIndicator(),
                      SizedBox(height: 16.h),
                      Text(
                        'Загружаем карту...',
                        style: TextStyle(
                          color: ColorsConstants.primaryBrownColor,
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                )
              : YandexMap(
                  mapObjects: mapObjects,
                  onMapCreated: (YandexMapController controller) async {
                    _mapController = controller;
                    await _moveToUserLocation();
                  },
                ),

          SafeArea(
            child: Padding(
              padding: EdgeInsets.all(16.w),
              child: Container(
                decoration: BoxDecoration(
                  color: ColorsConstants.primaryBrownColor,
                  borderRadius: BorderRadius.circular(16.w),
                ),
                child: IconButton(
                  onPressed: () => context.router.pop(),
                  icon: Icon(
                    Icons.arrow_back,
                    color: ColorsConstants.primaryTextFormFieldBackgorundColor,
                    size: 24.sp,
                  ),
                  padding: EdgeInsets.all(8.w),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: ColorsConstants.primaryBrownColor,
        onPressed: () async {
          if (_mapController == null) return;

          if (_userPosition != null) {
            await _mapController!.moveCamera(
              CameraUpdate.newCameraPosition(
                CameraPosition(
                  target: Point(
                    latitude: _userPosition!.latitude,
                    longitude: _userPosition!.longitude,
                  ),
                  zoom: 10,
                ),
              ),
              animation: const MapAnimation(duration: 1),
            );
          } else {
            await _moveToUserLocation();
          }
        },
        child: const Icon(
          Icons.my_location,
          color: ColorsConstants.primaryTextFormFieldBackgorundColor,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
